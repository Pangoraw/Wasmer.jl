julia_type_to_valtype(julia_type)::Ptr{wasm_valtype_t} =
    julia_type_to_valkind(julia_type) |> wasm_valtype_new

# TODO: the other value types
function WasmInt32(i::Int32)
    val = Ref(wasm_val_t(tuple((zero(UInt8) for _ = 1:16)...)))
    ptr = Base.unsafe_convert(Ptr{wasm_val_t}, Base.pointer_from_objref(val))
    ptr.kind = WASM_I32
    ptr.of.i32 = i

    val[]
end
function WasmInt64(i::Int64)
    val = Ref(wasm_val_t(tuple((zero(UInt8) for _ = 1:16)...)))
    ptr = Base.unsafe_convert(Ptr{wasm_val_t}, Base.pointer_from_objref(val))
    ptr.kind = WASM_I64
    ptr.of.i64 = i

    val[]
end
function WasmFloat32(f::Float32)
    val = Ref(wasm_val_t(tuple((zero(UInt8) for _ = 1:16)...)))
    ptr = Base.unsafe_convert(Ptr{wasm_val_t}, Base.pointer_from_objref(val))
    ptr.kind = WASM_F32
    ptr.of.f32 = f

    val[]
end
function WasmFloat64(f::Float64)
    val = Ref(wasm_val_t(tuple((zero(UInt8) for _ = 1:16)...)))
    ptr = Base.unsafe_convert(Ptr{wasm_val_t}, Base.pointer_from_objref(val))
    ptr.kind = WASM_F64
    ptr.of.f64 = f

    val[]
end

function julia_type_to_valkind(julia_type::Type)::wasm_valkind_enum
    if julia_type == Int32
        WASM_I32
    elseif julia_type == Int64
        WASM_I64
    elseif julia_type == Float32
        WASM_F32
    elseif julia_type == Float64
        WASM_F64
    else
        error("No corresponding valkind for type $julia_type")
    end
end

function valkind_to_julia_type(valkind::wasm_valkind_enum)
    if valkind == WASM_I32
        Int32
    elseif valkind == WASM_I64
        Int64
    elseif valkind == WASM_F32
        Float32
    elseif valkind == WASM_F64
        Float64
    else
        error("No corresponding type for kind $valkind")
    end
end

Base.convert(::Type{wasm_val_t}, i::Int32) = WasmInt32(i)
Base.convert(::Type{wasm_val_t}, i::Int64) = WasmInt64(i)
Base.convert(::Type{wasm_val_t}, f::Float32) = WasmFloat32(f)
Base.convert(::Type{wasm_val_t}, f::Float64) = WasmFloat64(f)

Base.convert(::Type{wasm_val_t}, val::wasm_val_t) = val
function Base.convert(julia_type, wasm_val::wasm_val_t)
    valkind = julia_type_to_valkind(julia_type)
    @assert valkind == wasm_val.kind "Cannot convert a value of kind $(wasm_val.kind) to corresponding kind $valkind"
    ctag = Ref(wasm_val.of)
    ptr = Base.unsafe_convert(Ptr{LibWasmer.__JL_Ctag_18}, ctag)
    jl_val = GC.@preserve ctag unsafe_load(Ptr{julia_type}(ptr))
    jl_val
end

function Base.show(io::IO, wasm_val::wasm_val_t)
    name, maybe_val = if wasm_val.kind == WASM_I32
        "WasmInt32", wasm_val.of.i32 |> string
    elseif wasm_val.kind == WASM_I64
        "WasmInt64", wasm_val.of.i64 |> string
    elseif wasm_val.kind == WASM_F32
        "WasmFloat32", wasm_val.of.f32 |> string
    elseif wasm_val.kind == WASM_F64
        "WasmFloat64", wasm_val.of.f64 |> string
    else
        "WasmAny", ""
    end

    print(io, "$name($maybe_val)")
end
