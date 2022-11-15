module Wasmer

include("./LibWasmer.jl")

using .LibWasmer

include("./vec_t.jl")
include("./val_t.jl")
include("./engine.jl")
include("./store.jl")
include("./module.jl")
include("./wat2wasm.jl")
include("./instance.jl")
include("./wasi.jl")

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
    WasiEnv,
    WasiConfig,
    WasiPipe,
    @wat_str

end # module
