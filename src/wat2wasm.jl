function wasmer_last_error_length()
    @ccall libwasmer.wasmer_last_error_length()::Cint
end

function wasmer_last_error_message(error_length = get_last_error_length())
    error_length === 0 && return

    buffer = Vector{UInt8}(undef, error_length)
    buffer_ptr = Base.unsafe_convert(Ptr{UInt8}, buffer)
    res = @ccall libwasmer.wasmer_last_error_message(
        buffer_ptr::Cstring,
        error_length::Cint,
    )::Cint
    res === -1 && error("Failed to retrieve last wasmer error")

    unsafe_string(buffer_ptr, error_length)
end

function check_wasmer_error()
    error_length = wasmer_last_error_length()
    if error_length != 0
        error_msg = wasmer_last_error_message(error_length)
        error(error_msg)
    end
end

wat2wasm(str::AbstractString) = wat2wasm(WasmByteVec(collect(wasm_byte_t, str)))
function wat2wasm(wat::WasmByteVec)
    out = WasmByteVec()
    @ccall libwasmer.wat2wasm(wat::Ptr{wasm_byte_vec_t}, out::Ptr{wasm_byte_vec_t})::Cvoid
    check_wasmer_error()

    out
end

macro wat_str(wat::String)
    :(wat2wasm($wat))
end

