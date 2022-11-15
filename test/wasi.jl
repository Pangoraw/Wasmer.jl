using Wasmer

using Test
using Downloads

@testset "Wasi - cowsay" begin
mktempdir() do tmp_dir
    # TODO: Find a better way to provide the files
    location = joinpath(tmp_dir, "cowsay.wasm")
    Downloads.download(
        "https://registry-cdn.wapm.io/contents/_/cowsay/0.2.0/target/wasm32-wasi/release/cowsay.wasm",
        location,
    )

    # location = "./tmp/cowsay.wasm"
    wasm_code = read(location) |> Wasmer.WasmVec

    engine = WasmEngine()
    store = WasmStore(engine)
    wasm_module = WasmModule(store, wasm_code)

    msg = "Meuuuh!"

    wasi_config = WasiConfig("wasi_unstable")

    wstdout, wstderr, wstdin = WasiPipe(), WasiPipe(), WasiPipe(blocking=false)
    Wasmer.override_stderr!(wasi_config, wstderr)
    Wasmer.override_stdout!(wasi_config, wstdout)
    Wasmer.override_stdin!(wasi_config, wstdin)

    env = WasiEnv(store, wasi_config)
    imports = Wasmer.get_imports(store, wasm_module, env)

    instance = WasmInstance(store, wasm_module, imports)
    exports_ = exports(instance)

    memory = exports_.memory
    Wasmer.set_memory!(env, memory)

    Wasmer.write(wstdin, msg * "\n")

    exports(instance)._start()

    result = Wasmer.read(wstdout, String)

    expected = raw"""
     _________
    < Meuuuh! >
     ---------
            \   ^__^
             \  (oo)\_______
                (__)\       )\/\
                   ||----w |
                    ||     ||
    """

    @test length(result) == length(expected)
    @test result == expected
end
end
