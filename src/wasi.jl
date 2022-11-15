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
function WasiEnv(store, config)
    wasi_env_ptr =
        LibWasmer.wasi_env_new(store, config)
    @assert wasi_env_ptr != C_NULL "Failed to create env"

    WasiEnv(wasi_env_ptr)
end

Base.unsafe_convert(::Type{Ptr{wasi_env_t}}, wasi_env::WasiEnv) = wasi_env.wasi_env_ptr

function set_memory!(env::WasiEnv, mem::WasmExport)
    LibWasmer.wasi_env_set_memory(env, mem)
end

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
        wasi_env,
        wasm_module,
        extern_vec,
    )
    @assert res "Failed to get WASI imports"

    extern_vec
end

mutable struct WasiPipe
    wasi_pipe_ptr::Ptr{wasi_pipe_t}
    user_ptr::Ptr{wasi_pipe_t}
    @atomic closed::Bool

    WasiPipe(ptr, uptr, closed) =
        finalizer(delete_wasi_pipe, new(ptr, uptr, closed))
end
function WasiPipe(;blocking::Bool = false)
    ptr_ref = Ref(Ptr{wasi_pipe_t}())
    ptr = if blocking
        LibWasmer.wasi_pipe_new_blocking(ptr_ref)
    else
        LibWasmer.wasi_pipe_new(ptr_ref)
    end

    WasiPipe(ptr, ptr_ref[], false)
end

function delete_wasi_pipe(wasi_pipe::WasiPipe)
    if !wasi_pipe.closed
        LibWasmer.wasi_pipe_delete(wasi_pipe.wasi_pipe_ptr)
    end
    # LibWasmer.wasi_pipe_delete(wasi_pipe.user_ptr)
end

Base.unsafe_convert(::Type{Ptr{wasi_pipe_t}}, wasi_pipe::WasiPipe) = wasi_pipe.wasi_pipe_ptr

function Base.readbytes!(wasi_pipe::WasiPipe, b::AbstractVector{UInt8}, nb=length(b))
    LibWasmer.wasi_pipe_read_bytes(wasi_pipe, buf, nb)
end

function Base.close(wasi_pipe::WasiPipe)
    LibWasmer.wasi_pipe_delete(wasi_pipe.wasi_pipe_ptr)
    @atomic wasi_pipe.closed = true
    return
end

function Base.read(wasi_pipe::WasiPipe, ::Type{String})
    str_ptr = Ref(Ptr{Cchar}())

    GC.@preserve str_ptr begin
        ptr = Base.pointer_from_objref(str_ptr)
        len = LibWasmer.wasi_pipe_read_str(wasi_pipe, ptr)
    end

    out_str = Base.unsafe_string(str_ptr[], len - 1)
    LibWasmer.wasi_pipe_delete_str(str_ptr[])
    out_str
end

function Base.write(wasi_pipe::WasiPipe, buf::AbstractVector{UInt8})
    LibWasmer.wasi_pipe_write_bytes(wasi_pipe, buf, length(buf))
end

function Base.write(wasi_pipe::WasiPipe, str::AbstractString)
    LibWasmer.wasi_pipe_write_str(wasi_pipe, str)
end

function override_stdout!(config::WasiConfig, pipe::WasiPipe)
    LibWasmer.wasi_config_overwrite_stdout(config, pipe.user_ptr)
end

function override_stderr!(config::WasiConfig, pipe::WasiPipe)
    LibWasmer.wasi_config_overwrite_stderr(config, pipe.user_ptr)
end

function override_stdin!(config::WasiConfig, pipe::WasiPipe)
    LibWasmer.wasi_config_overwrite_stdin(config, pipe.user_ptr)
end
