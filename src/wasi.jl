mutable struct WasiConfig
    wasi_config_ptr::Ptr{wasi_config_t}
    program_name::String
end
WasiConfig(name) = WasiConfig(wasi_config_new(name), name)

Base.show(io::IO, config::WasiConfig) = write(io, "WasiConfig(", config.program_name, ")")
Base.unsafe_convert(::Type{Ptr{wasi_config_t}}, config::WasiConfig) = config.wasi_config_ptr

mutable struct WasiEnv
    wasi_env_ptr::Ptr{wasi_env_t}

    WasiEnv(wasi_env_ptr::Ptr{wasi_env_t}) =
        finalizer(new(wasi_env_ptr)) do wasi_env
            wasi_env_delete(wasi_env)
        end
end
function WasiEnv(wasi_config_ptr::Ptr{wasi_config_t})
    wasi_env_ptr =
        @ccall libwasmer.wasi_env_new(wasi_config_ptr::Ptr{wasi_config_t})::Ptr{wasi_env_t}
    @assert wasi_env_ptr != C_NULL "Failed to create env"

    WasiEnv(wasi_env_ptr)
end
WasiEnv(config::WasiConfig) = config.wasi_config_ptr |> WasiEnv

Base.unsafe_convert(::Type{Ptr{wasi_env_t}}, wasi_env::WasiEnv) = wasi_env.wasi_env_ptr

function wasi_env_read_stdout(wasi_env, size = 128)
    vec = Vector{Int8}(undef, size)
    nread = LibWasmer.wasi_env_read_stdout(
        wasi_env,
        pointer(vec),
        size,
    )

    vec[begin:nread]
end
function wasi_env_read_stderr(wasi_env, size = 128)
    vec = Vector{Int8}(undef, size)
    nread = LibWasmer.wasi_env_read_stderr(
        wasi_env,
        pointer(vec),
        size,
    )

    vec[begin:nread]
end

function get_imports(store::WasmStore, wasm_module::WasmModule, wasi_env)
    extern_vec = WasmPtrVec(wasm_extern_t)

    res = wasi_get_imports(
        store,
        wasm_module,
        wasi_env,
        extern_vec,
    )
    @assert res "Failed to get WASI imports"

    extern_vec
end

