# Wasmer.jl

A Julia wrapper around the [wasmer runtime](https://wasmer.io) to run Web Assembly blobs and libraries from Julia.

## Example

```julia
julia> using Wasmer

julia> engine = WasmEngine();

julia> store = WasmStore(engine);

julia> code = wat"""
       (module
           (func $add (param $lhs i32) (param $rhs i32) (result i32)
               local.get $lhs
               local.get $rhs
               i32.add)
           (export "add" (func $add))
       )
       """;

julia> modu = WasmModule(store, code);

julia> instance = WasmInstance(store, modu);

julia> add = exports(instance).add
Wasmer.WasmExport(Ptr{Wasmer.LibWasmer.wasm_exporttype_t} @0x000000000378f2f0, WasmExtern(WASM_EXTERN_FUNC), WasmInstance(), "add")

julia> res = add(Int32(1), Int32(2))
3

julia> res == 3
true
```
