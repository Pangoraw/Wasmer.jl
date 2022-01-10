mutable struct WasmModule
    wasm_module_ptr::Ptr{wasm_module_t}

    WasmModule(module_ptr::Ptr{wasm_module_t}) =
        finalizer(wasm_module_delete, new(module_ptr))
end
function WasmModule(store::WasmStore, wasm_byte_vec::WasmByteVec)
    wasm_module_ptr = wasm_module_new(store, wasm_byte_vec)
    wasm_module_ptr == C_NULL && error("Failed to create wasm module")

    WasmModule(wasm_module_ptr)
end

Base.unsafe_convert(::Type{Ptr{wasm_module_t}}, wasm_module::WasmModule) =
    wasm_module.wasm_module_ptr

mutable struct WasmMemory
    wasm_memory_ptr::Ptr{wasm_memory_t}
end
function WasmMemory(store::WasmStore, limits::Pair{UInt32,UInt32})
    limits = wasm_limits_t(limits...)
    memory_type = GC.@preserve limits wasm_memorytype_new(pointer_from_objref(limits))
    @assert memory_type != C_NULL "Failed to create memory type"

    wasm_memory_ptr = wasm_memory_new(store, memory_type)
    @assert wasm_memory_ptr != C_NULL "Failed to create memory"

    WasmMemory(wasm_memory_ptr)
end

map_to_extern(mem::WasmMemory) = wasm_memory_as_extern(mem)
Base.show(io::IO, wasm_memory::WasmMemory) = print(io, "WasmMemory()")
Base.unsafe_convert(::Type{Ptr{wasm_memory_t}}, wasm_memory::WasmMemory) = wasm_memory.wasm_memory_ptr

function WasmFunc(store::WasmStore, func::Function, return_type, input_types)
    params_vec =
        WasmPtrVec(collect(Ptr{wasm_valtype_t}, map(julia_type_to_valtype, input_types)))
    results_vec =
        return_type == Nothing ? WasmPtrVec(wasm_valtype_t) :
        WasmPtrVec([julia_type_to_valtype(return_type)])

    func_type = wasm_functype_new(params_vec, results_vec)
    @assert func_type != C_NULL "Failed to create functype"

    function jl_side_host(
        args::Ptr{wasm_val_vec_t},
        results::Ptr{wasm_val_vec_t},
    )::Ptr{wasm_trap_t}
        # TODO: support passing the arguments
        res = func()
        wasm_res = Ref(convert(wasm_val_t, res))
        data_ptr = unsafe_load(results).data
        wasm_val_copy(data_ptr, Base.pointer_from_objref(wasm_res))

        C_NULL
    end

    # Create a pointer to jl_side_host(args, results)
    func_ptr = Base.@cfunction(
        $jl_side_host,
        Ptr{wasm_trap_t},
        (Ptr{wasm_val_vec_t}, Ptr{wasm_val_vec_t})
    )

    host_func = wasm_func_new(store, func_type, func_ptr)
    wasm_functype_delete(func_type)

    # Keep a reference to func_ptr in the store, so that it not garbage collected
    add_extern_func!(store, func_ptr)

    host_func
end

struct WasmFuncRef
    wasm_func_ptr::Ptr{wasm_func_t}
end

Base.unsafe_convert(::Type{Ptr{wasm_func_t}}, wasm_func::WasmFuncRef) =
    wasm_func.wasm_func_ptr

function (wasm_func::WasmFuncRef)(args...)
    params_arity = wasm_func_param_arity(wasm_func)
    result_arity = wasm_func_result_arity(wasm_func)

    provided_params = length(args)
    if params_arity != provided_params
        error("Wrong number of argument to function, expected $params_arity, got $provided_params",)
    end

    converted_args = collect(wasm_val_t, map(arg -> convert(wasm_val_t, arg), args))
    params_vec = WasmVec(converted_args)

    default_val = wasm_val_t(tuple(zeros(UInt8, 16)...))
    results_vec = WasmVec([default_val for _ = 1:result_arity])

    wasm_func_call(wasm_func, params_vec, results_vec)

    results = map(results_vec) do result
	jltype = valkind_to_julia_type(wasm_valkind_enum(result.kind))
	Base.convert(jltype, result)
    end

    length(results) == 1 ?
	only(results) : results
end

mutable struct WasmExtern
    wasm_extern_ptr::Ptr{wasm_extern_t}
end

Base.unsafe_convert(::Type{Ptr{wasm_extern_t}}, wasm_extern::WasmExtern) =
    wasm_extern.wasm_extern_ptr
function Base.show(io::IO, wasm_extern::WasmExtern)
    kind = wasm_extern_kind(wasm_extern) |> wasm_externkind_enum
    print(io, "WasmExtern($kind)")
end

function (wasm_extern::WasmExtern)(args...)
    extern_as_func = wasm_extern_as_func(wasm_extern)
    @assert extern_as_func != C_NULL "Can not use extern $wasm_extern as a function"

    WasmFuncRef(extern_as_func)(args...)
end

function name_vec_ptr_to_str(name_vec_ptr::Ptr{wasm_name_t})
    @assert name_vec_ptr != C_NULL "Failed to convert wasm_name"
    name_vec = Base.unsafe_load(name_vec_ptr)
    name = unsafe_string(name_vec.data, name_vec.size)
    wasm_name_delete(name_vec_ptr)

    name
end

struct WasmImport
    wasm_importtype_ptr::Ptr{wasm_importtype_t}
    extern_kind::wasm_externkind_enum
    import_module::String
    name::String

    function WasmImport(wasm_importtype_ptr::Ptr{wasm_importtype_t})
        name_vec_ptr = wasm_importtype_name(wasm_importtype_ptr)
        name = name_vec_ptr_to_str(name_vec_ptr)

        import_module_ptr = wasm_importtype_module(wasm_importtype_ptr)
        import_module = name_vec_ptr_to_str(import_module_ptr)

        externtype_ptr = wasm_importtype_type(wasm_importtype_ptr)
        extern_kind = wasm_externkind_enum(wasm_externtype_kind(externtype_ptr))

        new(wasm_importtype_ptr, extern_kind, import_module, name)
    end
end

Base.unsafe_convert(::Type{Ptr{wasm_importtype_t}}, wasm_import::WasmImport) = wasm_import.wasm_importtype_ptr
Base.show(io::IO, wasm_import::WasmImport) = print(
    io,
    "WasmImport($(wasm_import.extern_kind), \"$(wasm_import.import_module)\", \"$(wasm_import.name)\")",
)

struct WasmImports
    wasm_module::WasmModule
    wasm_imports::Vector{WasmImport}

    function WasmImports(wasm_module::WasmModule, wasm_imports_vec)
        wasm_imports = map(imp -> wasm_importtype_copy(imp) |> WasmImport, wasm_imports_vec)
        new(wasm_module, wasm_imports)
    end
end


function Base.show(io::IO, wasm_imports::WasmImports)
    print(io::IO, "WasmImports(")
    show(io, wasm_imports.wasm_imports)
    print(")")
end

function imports(wasm_module::WasmModule)
    wasm_imports_vec = WasmPtrVec(wasm_importtype_t)
    wasm_module_imports(wasm_module, wasm_imports_vec)
    WasmImports(wasm_module, wasm_imports_vec)
end
