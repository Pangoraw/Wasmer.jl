using Wasmer
using Test

@testset "" begin
    engine = WasmEngine()
    store = WasmStore(engine)
    code = wat"""
    (module
        (func $add (param $lhs i32) (param $rhs i32) (result i32)
            local.get $lhs
            local.get $rhs
            i32.add)
        (export "add" (func $add))
    )
    """
    modu = WasmModule(store, code)

    instance = WasmInstance(store, modu)
    add = exports(instance).add

    res = add(Int32(1), Int32(2))

    @test res == Int32(3)
end

include("./wasi.jl")
