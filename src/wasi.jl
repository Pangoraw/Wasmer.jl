mutable struct wasi_config_t end
mutable struct wasi_env_t end

mutable struct WasiConfig
    wasi_config_ptr::Ptr{wasi_config_t}
    program_name::String
end
WasiConfig(name) = WasiConfig(wasi_config_new(name), name)

Base.show(io::IO, config::WasiConfig) = write(io, "WasiConfig(", config.program_name, ")")
Base.unsafe_convert(::Type{Ptr{wasi_config_t}}, config::WasiConfig) = config.wasi_config_ptr

wasi_config_new(prg_name) =
    @ccall libwasmer.wasi_config_new(prg_name::Cstring)::Ptr{wasi_config_t}

wasi_config_inherit_stderr!(wasi_config) =
    @ccall libwasmer.wasi_config_inherit_stderr(wasi_config::Ptr{wasi_config_t})::Cvoid
wasi_config_inherit_stdin!(wasi_config) =
    @ccall libwasmer.wasi_config_inherit_stdin(wasi_config::Ptr{wasi_config_t})::Cvoid
wasi_config_inherit_stdout!(wasi_config) =
    @ccall libwasmer.wasi_config_inherit_stdout(wasi_config::Ptr{wasi_config_t})::Cvoid

wasi_config_capture_stdout!(wasi_config) =
    @ccall libwasmer.wasi_config_capture_stdout(wasi_config::Ptr{wasi_config_t})::Cvoid

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

wasi_env_delete(wasi_env) =
    @ccall libwasmer.wasi_env_delete(wasi_env::Ptr{wasi_env_t})::Cvoid

Base.unsafe_convert(::Type{Ptr{wasi_env_t}}, wasi_env::WasiEnv) = wasi_env.wasi_env_ptr

function wasi_env_read_stdout(wasi_env, size = 128)
    wasm_vec = WasmVec(Vector{Int8}(undef, size))
    nread = @ccall libwasmer.wasi_env_read_stdout(
        wasi_env::Ptr{wasi_env_t},
        wasm_vec.data::Ptr{Char},
        wasm_vec.size::Csize_t,
    )::Cint

    GC.@preserve wasm_vec unsafe_string(wasm_vec.data, nread)
end
function wasi_env_read_stderr(wasi_env, size = 128)
    wasm_vec = WasmVec(Vector{Int8}(undef, size))
    nread = @ccall libwasmer.wasi_env_read_stdout(
        wasi_env::Ptr{wasi_env_t},
        wasm_vec.data::Ptr{Char},
        wasm_vec.size::Csize_t,
    )::Cint

    GC.@preserve wasm_vec unsafe_string(wasm_vec.data, nread)
end

function wasi_get_imports(store::WasmStore, wasm_module::WasmModule, wasi_env)
    extern_vec = WasmPtrVec(wasm_extern_t)

    res = @ccall libwasmer.wasi_get_imports(
        store.wasm_store_ptr::Ptr{wasm_store_t},
        wasm_module.wasm_module_ptr::Ptr{wasm_module_t},
        wasi_env::Ptr{wasi_env_t},
        extern_vec::Ptr{wasm_extern_vec_t},
    )::Bool
    @assert res "Failed to get WASI imports"

    extern_vec
end

