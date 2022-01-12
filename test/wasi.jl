using Wasmer

using Test
using Downloads

mktempdir() do tmp_dir
    # TODO: Find a better way to provide the files
    location = joinpath(tmp_dir, "cowsay.wasm")
    Downloads.download(
        "https://registry-cdn.wapm.io/contents/_/cowsay/0.2.0/target/wasm32-wasi/release/cowsay.wasm",
        location,
    )

    wasm_code = read(location) |> Wasmer.WasmVec

    engine = WasmEngine()
    store = WasmStore(engine)
    wasm_module = WasmModule(store, wasm_code)

    msg = "Meuuuh!"

    wasi_config = Wasmer.WasiConfig("wasi_unstable")
    Wasmer.wasi_config_inherit_stderr(wasi_config)
    Wasmer.wasi_config_inherit_stdin(wasi_config)
    Wasmer.wasi_config_capture_stdout(wasi_config)

    env = Wasmer.WasiEnv(wasi_config)

    imports = Wasmer.get_imports(store, wasm_module, env)
    instance = WasmInstance(store, wasm_module, imports)

    exports(instance)._start()

    buffer = Wasmer.wasi_env_read_stdout(env, 512)
    msg = buffer .|> Char |> join |> Text

    @info "WASI worked" msg
end
