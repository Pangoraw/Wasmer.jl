module Wasmer

include("./LibWasmer.jl")

using .LibWasmer

include("./vec_t.jl")
include("./val_t.jl")
include("./engine.jl")
include("./store.jl")
include("./module.jl")
include("./wasi.jl")
include("./wat2wasm.jl")
include("./instance.jl")

export WasmEngine,
    WasmMemory,
    WasmStore,
    WasmInstance,
    WasmExports,
    exports,
    WasmStore,
    WasmModule,
    imports,
    WasmImports,
    WasmFunc,
    @wat_str

end # module
