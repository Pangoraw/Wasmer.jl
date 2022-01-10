"A generic wrapper around `wasm_XXX_vec_t`"
mutable struct WasmVec{T,S} <: AbstractVector{S}
    size::Csize_t
    data::Ptr{S}
end

wasm_vec_delete(wasm_vec::WasmVec{T,S}) where {T,S} = _get_delete_function(T)(wasm_vec)

function WasmVec{T,S}(vector::Vector{S} = S[]) where {T,S}
    vec_size = length(vector)

    wasm_vec = WasmVec{T,S}(0, C_NULL)
    vec_uninitialized = _get_uninitialized_function(T)

    vec_uninitialized(wasm_vec, vec_size)
    src_ptr = pointer(vector)

    GC.@preserve vector unsafe_copyto!(wasm_vec.data, src_ptr, vec_size)

    finalizer(wasm_vec_delete, wasm_vec)
end

_get_delete_function(T) =
    getproperty(LibWasmer, Symbol(string(nameof(T))[1:end-6] * "_vec_delete"))
_get_uninitialized_function(T) =
    getproperty(LibWasmer, Symbol(string(nameof(T))[1:end-6] * "_vec_new_uninitialized"))

WasmVec(base_type::Type) = WasmVec(base_type[])
function WasmVec(vec::Vector{S}) where {S}
    vec_type = _get_wasm_vec_name(S)
    WasmVec{vec_type,S}(vec)
end

WasmPtrVec(base_type::Type) = WasmPtrVec(Ptr{base_type}[])
function WasmPtrVec(vec::Vector{Ptr{S}}) where {S}
    vec_type = _get_wasm_vec_name(S)
    WasmVec{vec_type,Ptr{S}}(vec)
end

_get_wasm_vec_name(::Type{Cchar}) = wasm_byte_vec_t
_get_wasm_vec_name(::Type{UInt8}) = wasm_byte_vec_t
function _get_wasm_vec_name(type::Type)
    @assert parentmodule(type) == LibWasmer "$type should be a LibWasm type"
    type_name = string(nameof(type)) # "wasm_XXX_t"
    vec_type_sym = Symbol(replace(type_name, r"_t$" => "_vec_t")) # :wasm_XXX_vec_t
    getproperty(LibWasmer, vec_type_sym)
end

Base.IndexStyle(::Type{WasmVec}) = IndexLinear()
Base.length(vec::WasmVec) = vec.size
Base.size(vec::WasmVec) = (length(vec),)
function Base.getindex(vec::WasmVec, i::Int)
    @assert 1 <= i <= length(vec) BoundsError(vec, i)
    unsafe_load(vec.data, i)
end
function Base.setindex!(vec::WasmVec{T,S}, v::S, i::Int) where {T,S}
    @assert 1 <= i <= length(vec) BoundsError(vec, i)
    elsize = sizeof(S)

    ref = Ref(v)
    src_ptr = Base.unsafe_convert(Ptr{S}, ref)
    dest_ptr = Base.unsafe_convert(Ptr{S}, vec.data + elsize * (i - 1))

    GC.@preserve ref unsafe_copyto!(dest_ptr, src_ptr, 1)

    v
end

Base.unsafe_convert(::Type{Ptr{T}}, vec::WasmVec{T,S}) where {T,S} =
    Base.unsafe_convert(Ptr{T}, pointer_from_objref(vec))
Base.unsafe_convert(::Type{Ptr{S}}, vec::WasmVec{T,S}) where {T,S} = vec.data

const WasmByteVec = WasmVec{wasm_byte_vec_t,UInt8}
const WasmName = WasmByteVec
