mutable struct WasmStore
    wasm_store_ptr::Ptr{wasm_store_t}
    externs_func::Vector{Base.CFunction}

    WasmStore(wasm_store_ptr::Ptr{wasm_store_t}) =
        finalizer(wasm_store_delete, new(wasm_store_ptr, []))
end
WasmStore(wasm_engine) = WasmStore(wasm_store_new(wasm_engine))

add_extern_func!(wasm_store::WasmStore, cfunc::Base.CFunction) =
    push!(wasm_store.externs_func, cfunc)

Base.unsafe_convert(::Type{Ptr{wasm_store_t}}, wasm_store::WasmStore) =
    wasm_store.wasm_store_ptr
Base.show(io::IO, ::WasmStore) = print(io, "WasmStore()")
