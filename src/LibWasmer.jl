module LibWasmer

using CEnum

# This file (`LibWasmer.jl` not `prologue.jl`) is automatically generated using
# Clang.jl and should not be edited manually. Take a look at the `gen/` folder
# if something is to be changed.

using Pkg.Artifacts
using Pkg.BinaryPlatforms

tripletnolibc(platform) = replace(triplet(platform), "-gnu" => "")
get_libwasmer_location(platform) =
    "wasmer-v$release_version-$(tripletnolibc(platform))-c-api"

function get_libwasmer_location()
    artifact_info = artifact_meta("libwasmer", joinpath(@__DIR__, "..", "Artifacts.toml"))
    artifact_info === nothing && return nothing

    parent_path = artifact_path(Base.SHA1(artifact_info["git-tree-sha1"]))
    child_folder = readdir(parent_path)[1]
    return joinpath(
        parent_path,
        child_folder,
        "lib/libwasmer"
    )
end

const libwasmer_key = "LIBWASMER_LOCATION"
const libwasmer = haskey(ENV, libwasmer_key) ?
    ENV[libwasmer_key] : get_libwasmer_location()


const intptr_t = Clong

const byte_t = Cchar

const wasm_byte_t = UInt8

mutable struct wasm_byte_vec_t
    size::Csize_t
    data::Ptr{wasm_byte_t}
end

function wasm_byte_vec_new(out, arg2, arg3)
    ccall((:wasm_byte_vec_new, libwasmer), Cvoid, (Ptr{wasm_byte_vec_t}, Csize_t, Ptr{wasm_byte_t}), out, arg2, arg3)
end

function wasm_byte_vec_new_empty(out)
    ccall((:wasm_byte_vec_new_empty, libwasmer), Cvoid, (Ptr{wasm_byte_vec_t},), out)
end

function wasm_byte_vec_new_uninitialized(out, arg2)
    ccall((:wasm_byte_vec_new_uninitialized, libwasmer), Cvoid, (Ptr{wasm_byte_vec_t}, Csize_t), out, arg2)
end

function wasm_byte_vec_copy(out, arg2)
    ccall((:wasm_byte_vec_copy, libwasmer), Cvoid, (Ptr{wasm_byte_vec_t}, Ptr{wasm_byte_vec_t}), out, arg2)
end

function wasm_byte_vec_delete(arg1)
    ccall((:wasm_byte_vec_delete, libwasmer), Cvoid, (Ptr{wasm_byte_vec_t},), arg1)
end

mutable struct wasm_ref_t end

mutable struct wasm_store_t end

# no prototype is found for this function at wasm.h:29:13, please use with caution
function assertions()
    ccall((:assertions, libwasmer), Cvoid, ())
end

const float32_t = Cfloat

const float64_t = Cdouble

const wasm_name_t = wasm_byte_vec_t

function wasm_name_new_from_string(out, s)
    ccall((:wasm_name_new_from_string, libwasmer), Cvoid, (Ptr{wasm_name_t}, Cstring), out, s)
end

function wasm_name_new_from_string_nt(out, s)
    ccall((:wasm_name_new_from_string_nt, libwasmer), Cvoid, (Ptr{wasm_name_t}, Cstring), out, s)
end

mutable struct wasm_config_t end

function wasm_config_delete(arg1)
    ccall((:wasm_config_delete, libwasmer), Cvoid, (Ptr{wasm_config_t},), arg1)
end

# no prototype is found for this function at wasm.h:127:36, please use with caution
function wasm_config_new()
    ccall((:wasm_config_new, libwasmer), Ptr{wasm_config_t}, ())
end

mutable struct wasm_engine_t end

function wasm_engine_delete(arg1)
    ccall((:wasm_engine_delete, libwasmer), Cvoid, (Ptr{wasm_engine_t},), arg1)
end

# no prototype is found for this function at wasm.h:136:36, please use with caution
function wasm_engine_new()
    ccall((:wasm_engine_new, libwasmer), Ptr{wasm_engine_t}, ())
end

function wasm_engine_new_with_config(arg1)
    ccall((:wasm_engine_new_with_config, libwasmer), Ptr{wasm_engine_t}, (Ptr{wasm_config_t},), arg1)
end

function wasm_store_delete(arg1)
    ccall((:wasm_store_delete, libwasmer), Cvoid, (Ptr{wasm_store_t},), arg1)
end

function wasm_store_new(arg1)
    ccall((:wasm_store_new, libwasmer), Ptr{wasm_store_t}, (Ptr{wasm_engine_t},), arg1)
end

const wasm_mutability_t = UInt8

@cenum wasm_mutability_enum::UInt32 begin
    WASM_CONST = 0
    WASM_VAR = 1
end

mutable struct wasm_limits_t
    min::UInt32
    max::UInt32
end

mutable struct wasm_valtype_t end

function wasm_valtype_delete(arg1)
    ccall((:wasm_valtype_delete, libwasmer), Cvoid, (Ptr{wasm_valtype_t},), arg1)
end

mutable struct wasm_valtype_vec_t
    size::Csize_t
    data::Ptr{Ptr{wasm_valtype_t}}
end

function wasm_valtype_vec_new_empty(out)
    ccall((:wasm_valtype_vec_new_empty, libwasmer), Cvoid, (Ptr{wasm_valtype_vec_t},), out)
end

function wasm_valtype_vec_new_uninitialized(out, arg2)
    ccall((:wasm_valtype_vec_new_uninitialized, libwasmer), Cvoid, (Ptr{wasm_valtype_vec_t}, Csize_t), out, arg2)
end

function wasm_valtype_vec_new(out, arg2, arg3)
    ccall((:wasm_valtype_vec_new, libwasmer), Cvoid, (Ptr{wasm_valtype_vec_t}, Csize_t, Ptr{Ptr{wasm_valtype_t}}), out, arg2, arg3)
end

function wasm_valtype_vec_copy(out, arg2)
    ccall((:wasm_valtype_vec_copy, libwasmer), Cvoid, (Ptr{wasm_valtype_vec_t}, Ptr{wasm_valtype_vec_t}), out, arg2)
end

function wasm_valtype_vec_delete(arg1)
    ccall((:wasm_valtype_vec_delete, libwasmer), Cvoid, (Ptr{wasm_valtype_vec_t},), arg1)
end

function wasm_valtype_copy(arg1)
    ccall((:wasm_valtype_copy, libwasmer), Ptr{wasm_valtype_t}, (Ptr{wasm_valtype_t},), arg1)
end

const wasm_valkind_t = UInt8

@cenum wasm_valkind_enum::UInt32 begin
    WASM_I32 = 0
    WASM_I64 = 1
    WASM_F32 = 2
    WASM_F64 = 3
    WASM_ANYREF = 128
    WASM_FUNCREF = 129
end

function wasm_valtype_new(arg1)
    ccall((:wasm_valtype_new, libwasmer), Ptr{wasm_valtype_t}, (wasm_valkind_t,), arg1)
end

function wasm_valtype_kind(arg1)
    ccall((:wasm_valtype_kind, libwasmer), wasm_valkind_t, (Ptr{wasm_valtype_t},), arg1)
end

function wasm_valkind_is_num(k)
    ccall((:wasm_valkind_is_num, libwasmer), Bool, (wasm_valkind_t,), k)
end

function wasm_valkind_is_ref(k)
    ccall((:wasm_valkind_is_ref, libwasmer), Bool, (wasm_valkind_t,), k)
end

function wasm_valtype_is_num(t)
    ccall((:wasm_valtype_is_num, libwasmer), Bool, (Ptr{wasm_valtype_t},), t)
end

function wasm_valtype_is_ref(t)
    ccall((:wasm_valtype_is_ref, libwasmer), Bool, (Ptr{wasm_valtype_t},), t)
end

mutable struct wasm_functype_t end

function wasm_functype_delete(arg1)
    ccall((:wasm_functype_delete, libwasmer), Cvoid, (Ptr{wasm_functype_t},), arg1)
end

mutable struct wasm_functype_vec_t
    size::Csize_t
    data::Ptr{Ptr{wasm_functype_t}}
end

function wasm_functype_vec_new_empty(out)
    ccall((:wasm_functype_vec_new_empty, libwasmer), Cvoid, (Ptr{wasm_functype_vec_t},), out)
end

function wasm_functype_vec_new_uninitialized(out, arg2)
    ccall((:wasm_functype_vec_new_uninitialized, libwasmer), Cvoid, (Ptr{wasm_functype_vec_t}, Csize_t), out, arg2)
end

function wasm_functype_vec_new(out, arg2, arg3)
    ccall((:wasm_functype_vec_new, libwasmer), Cvoid, (Ptr{wasm_functype_vec_t}, Csize_t, Ptr{Ptr{wasm_functype_t}}), out, arg2, arg3)
end

function wasm_functype_vec_copy(out, arg2)
    ccall((:wasm_functype_vec_copy, libwasmer), Cvoid, (Ptr{wasm_functype_vec_t}, Ptr{wasm_functype_vec_t}), out, arg2)
end

function wasm_functype_vec_delete(arg1)
    ccall((:wasm_functype_vec_delete, libwasmer), Cvoid, (Ptr{wasm_functype_vec_t},), arg1)
end

function wasm_functype_copy(arg1)
    ccall((:wasm_functype_copy, libwasmer), Ptr{wasm_functype_t}, (Ptr{wasm_functype_t},), arg1)
end

function wasm_functype_new(params, results)
    ccall((:wasm_functype_new, libwasmer), Ptr{wasm_functype_t}, (Ptr{wasm_valtype_vec_t}, Ptr{wasm_valtype_vec_t}), params, results)
end

function wasm_functype_params(arg1)
    ccall((:wasm_functype_params, libwasmer), Ptr{wasm_valtype_vec_t}, (Ptr{wasm_functype_t},), arg1)
end

function wasm_functype_results(arg1)
    ccall((:wasm_functype_results, libwasmer), Ptr{wasm_valtype_vec_t}, (Ptr{wasm_functype_t},), arg1)
end

mutable struct wasm_globaltype_t end

function wasm_globaltype_delete(arg1)
    ccall((:wasm_globaltype_delete, libwasmer), Cvoid, (Ptr{wasm_globaltype_t},), arg1)
end

mutable struct wasm_globaltype_vec_t
    size::Csize_t
    data::Ptr{Ptr{wasm_globaltype_t}}
end

function wasm_globaltype_vec_new_empty(out)
    ccall((:wasm_globaltype_vec_new_empty, libwasmer), Cvoid, (Ptr{wasm_globaltype_vec_t},), out)
end

function wasm_globaltype_vec_new_uninitialized(out, arg2)
    ccall((:wasm_globaltype_vec_new_uninitialized, libwasmer), Cvoid, (Ptr{wasm_globaltype_vec_t}, Csize_t), out, arg2)
end

function wasm_globaltype_vec_new(out, arg2, arg3)
    ccall((:wasm_globaltype_vec_new, libwasmer), Cvoid, (Ptr{wasm_globaltype_vec_t}, Csize_t, Ptr{Ptr{wasm_globaltype_t}}), out, arg2, arg3)
end

function wasm_globaltype_vec_copy(out, arg2)
    ccall((:wasm_globaltype_vec_copy, libwasmer), Cvoid, (Ptr{wasm_globaltype_vec_t}, Ptr{wasm_globaltype_vec_t}), out, arg2)
end

function wasm_globaltype_vec_delete(arg1)
    ccall((:wasm_globaltype_vec_delete, libwasmer), Cvoid, (Ptr{wasm_globaltype_vec_t},), arg1)
end

function wasm_globaltype_copy(arg1)
    ccall((:wasm_globaltype_copy, libwasmer), Ptr{wasm_globaltype_t}, (Ptr{wasm_globaltype_t},), arg1)
end

function wasm_globaltype_new(arg1, arg2)
    ccall((:wasm_globaltype_new, libwasmer), Ptr{wasm_globaltype_t}, (Ptr{wasm_valtype_t}, wasm_mutability_t), arg1, arg2)
end

function wasm_globaltype_content(arg1)
    ccall((:wasm_globaltype_content, libwasmer), Ptr{wasm_valtype_t}, (Ptr{wasm_globaltype_t},), arg1)
end

function wasm_globaltype_mutability(arg1)
    ccall((:wasm_globaltype_mutability, libwasmer), wasm_mutability_t, (Ptr{wasm_globaltype_t},), arg1)
end

mutable struct wasm_tabletype_t end

function wasm_tabletype_delete(arg1)
    ccall((:wasm_tabletype_delete, libwasmer), Cvoid, (Ptr{wasm_tabletype_t},), arg1)
end

mutable struct wasm_tabletype_vec_t
    size::Csize_t
    data::Ptr{Ptr{wasm_tabletype_t}}
end

function wasm_tabletype_vec_new_empty(out)
    ccall((:wasm_tabletype_vec_new_empty, libwasmer), Cvoid, (Ptr{wasm_tabletype_vec_t},), out)
end

function wasm_tabletype_vec_new_uninitialized(out, arg2)
    ccall((:wasm_tabletype_vec_new_uninitialized, libwasmer), Cvoid, (Ptr{wasm_tabletype_vec_t}, Csize_t), out, arg2)
end

function wasm_tabletype_vec_new(out, arg2, arg3)
    ccall((:wasm_tabletype_vec_new, libwasmer), Cvoid, (Ptr{wasm_tabletype_vec_t}, Csize_t, Ptr{Ptr{wasm_tabletype_t}}), out, arg2, arg3)
end

function wasm_tabletype_vec_copy(out, arg2)
    ccall((:wasm_tabletype_vec_copy, libwasmer), Cvoid, (Ptr{wasm_tabletype_vec_t}, Ptr{wasm_tabletype_vec_t}), out, arg2)
end

function wasm_tabletype_vec_delete(arg1)
    ccall((:wasm_tabletype_vec_delete, libwasmer), Cvoid, (Ptr{wasm_tabletype_vec_t},), arg1)
end

function wasm_tabletype_copy(arg1)
    ccall((:wasm_tabletype_copy, libwasmer), Ptr{wasm_tabletype_t}, (Ptr{wasm_tabletype_t},), arg1)
end

function wasm_tabletype_new(arg1, arg2)
    ccall((:wasm_tabletype_new, libwasmer), Ptr{wasm_tabletype_t}, (Ptr{wasm_valtype_t}, Ptr{wasm_limits_t}), arg1, arg2)
end

function wasm_tabletype_element(arg1)
    ccall((:wasm_tabletype_element, libwasmer), Ptr{wasm_valtype_t}, (Ptr{wasm_tabletype_t},), arg1)
end

function wasm_tabletype_limits(arg1)
    ccall((:wasm_tabletype_limits, libwasmer), Ptr{wasm_limits_t}, (Ptr{wasm_tabletype_t},), arg1)
end

mutable struct wasm_memorytype_t end

function wasm_memorytype_delete(arg1)
    ccall((:wasm_memorytype_delete, libwasmer), Cvoid, (Ptr{wasm_memorytype_t},), arg1)
end

mutable struct wasm_memorytype_vec_t
    size::Csize_t
    data::Ptr{Ptr{wasm_memorytype_t}}
end

function wasm_memorytype_vec_new_empty(out)
    ccall((:wasm_memorytype_vec_new_empty, libwasmer), Cvoid, (Ptr{wasm_memorytype_vec_t},), out)
end

function wasm_memorytype_vec_new_uninitialized(out, arg2)
    ccall((:wasm_memorytype_vec_new_uninitialized, libwasmer), Cvoid, (Ptr{wasm_memorytype_vec_t}, Csize_t), out, arg2)
end

function wasm_memorytype_vec_new(out, arg2, arg3)
    ccall((:wasm_memorytype_vec_new, libwasmer), Cvoid, (Ptr{wasm_memorytype_vec_t}, Csize_t, Ptr{Ptr{wasm_memorytype_t}}), out, arg2, arg3)
end

function wasm_memorytype_vec_copy(out, arg2)
    ccall((:wasm_memorytype_vec_copy, libwasmer), Cvoid, (Ptr{wasm_memorytype_vec_t}, Ptr{wasm_memorytype_vec_t}), out, arg2)
end

function wasm_memorytype_vec_delete(arg1)
    ccall((:wasm_memorytype_vec_delete, libwasmer), Cvoid, (Ptr{wasm_memorytype_vec_t},), arg1)
end

function wasm_memorytype_copy(arg1)
    ccall((:wasm_memorytype_copy, libwasmer), Ptr{wasm_memorytype_t}, (Ptr{wasm_memorytype_t},), arg1)
end

function wasm_memorytype_new(arg1)
    ccall((:wasm_memorytype_new, libwasmer), Ptr{wasm_memorytype_t}, (Ptr{wasm_limits_t},), arg1)
end

function wasm_memorytype_limits(arg1)
    ccall((:wasm_memorytype_limits, libwasmer), Ptr{wasm_limits_t}, (Ptr{wasm_memorytype_t},), arg1)
end

mutable struct wasm_externtype_t end

function wasm_externtype_delete(arg1)
    ccall((:wasm_externtype_delete, libwasmer), Cvoid, (Ptr{wasm_externtype_t},), arg1)
end

mutable struct wasm_externtype_vec_t
    size::Csize_t
    data::Ptr{Ptr{wasm_externtype_t}}
end

function wasm_externtype_vec_new_empty(out)
    ccall((:wasm_externtype_vec_new_empty, libwasmer), Cvoid, (Ptr{wasm_externtype_vec_t},), out)
end

function wasm_externtype_vec_new_uninitialized(out, arg2)
    ccall((:wasm_externtype_vec_new_uninitialized, libwasmer), Cvoid, (Ptr{wasm_externtype_vec_t}, Csize_t), out, arg2)
end

function wasm_externtype_vec_new(out, arg2, arg3)
    ccall((:wasm_externtype_vec_new, libwasmer), Cvoid, (Ptr{wasm_externtype_vec_t}, Csize_t, Ptr{Ptr{wasm_externtype_t}}), out, arg2, arg3)
end

function wasm_externtype_vec_copy(out, arg2)
    ccall((:wasm_externtype_vec_copy, libwasmer), Cvoid, (Ptr{wasm_externtype_vec_t}, Ptr{wasm_externtype_vec_t}), out, arg2)
end

function wasm_externtype_vec_delete(arg1)
    ccall((:wasm_externtype_vec_delete, libwasmer), Cvoid, (Ptr{wasm_externtype_vec_t},), arg1)
end

function wasm_externtype_copy(arg1)
    ccall((:wasm_externtype_copy, libwasmer), Ptr{wasm_externtype_t}, (Ptr{wasm_externtype_t},), arg1)
end

const wasm_externkind_t = UInt8

@cenum wasm_externkind_enum::UInt32 begin
    WASM_EXTERN_FUNC = 0
    WASM_EXTERN_GLOBAL = 1
    WASM_EXTERN_TABLE = 2
    WASM_EXTERN_MEMORY = 3
end

function wasm_externtype_kind(arg1)
    ccall((:wasm_externtype_kind, libwasmer), wasm_externkind_t, (Ptr{wasm_externtype_t},), arg1)
end

function wasm_functype_as_externtype(arg1)
    ccall((:wasm_functype_as_externtype, libwasmer), Ptr{wasm_externtype_t}, (Ptr{wasm_functype_t},), arg1)
end

function wasm_globaltype_as_externtype(arg1)
    ccall((:wasm_globaltype_as_externtype, libwasmer), Ptr{wasm_externtype_t}, (Ptr{wasm_globaltype_t},), arg1)
end

function wasm_tabletype_as_externtype(arg1)
    ccall((:wasm_tabletype_as_externtype, libwasmer), Ptr{wasm_externtype_t}, (Ptr{wasm_tabletype_t},), arg1)
end

function wasm_memorytype_as_externtype(arg1)
    ccall((:wasm_memorytype_as_externtype, libwasmer), Ptr{wasm_externtype_t}, (Ptr{wasm_memorytype_t},), arg1)
end

function wasm_externtype_as_functype(arg1)
    ccall((:wasm_externtype_as_functype, libwasmer), Ptr{wasm_functype_t}, (Ptr{wasm_externtype_t},), arg1)
end

function wasm_externtype_as_globaltype(arg1)
    ccall((:wasm_externtype_as_globaltype, libwasmer), Ptr{wasm_globaltype_t}, (Ptr{wasm_externtype_t},), arg1)
end

function wasm_externtype_as_tabletype(arg1)
    ccall((:wasm_externtype_as_tabletype, libwasmer), Ptr{wasm_tabletype_t}, (Ptr{wasm_externtype_t},), arg1)
end

function wasm_externtype_as_memorytype(arg1)
    ccall((:wasm_externtype_as_memorytype, libwasmer), Ptr{wasm_memorytype_t}, (Ptr{wasm_externtype_t},), arg1)
end

function wasm_functype_as_externtype_const(arg1)
    ccall((:wasm_functype_as_externtype_const, libwasmer), Ptr{wasm_externtype_t}, (Ptr{wasm_functype_t},), arg1)
end

function wasm_globaltype_as_externtype_const(arg1)
    ccall((:wasm_globaltype_as_externtype_const, libwasmer), Ptr{wasm_externtype_t}, (Ptr{wasm_globaltype_t},), arg1)
end

function wasm_tabletype_as_externtype_const(arg1)
    ccall((:wasm_tabletype_as_externtype_const, libwasmer), Ptr{wasm_externtype_t}, (Ptr{wasm_tabletype_t},), arg1)
end

function wasm_memorytype_as_externtype_const(arg1)
    ccall((:wasm_memorytype_as_externtype_const, libwasmer), Ptr{wasm_externtype_t}, (Ptr{wasm_memorytype_t},), arg1)
end

function wasm_externtype_as_functype_const(arg1)
    ccall((:wasm_externtype_as_functype_const, libwasmer), Ptr{wasm_functype_t}, (Ptr{wasm_externtype_t},), arg1)
end

function wasm_externtype_as_globaltype_const(arg1)
    ccall((:wasm_externtype_as_globaltype_const, libwasmer), Ptr{wasm_globaltype_t}, (Ptr{wasm_externtype_t},), arg1)
end

function wasm_externtype_as_tabletype_const(arg1)
    ccall((:wasm_externtype_as_tabletype_const, libwasmer), Ptr{wasm_tabletype_t}, (Ptr{wasm_externtype_t},), arg1)
end

function wasm_externtype_as_memorytype_const(arg1)
    ccall((:wasm_externtype_as_memorytype_const, libwasmer), Ptr{wasm_memorytype_t}, (Ptr{wasm_externtype_t},), arg1)
end

mutable struct wasm_importtype_t end

function wasm_importtype_delete(arg1)
    ccall((:wasm_importtype_delete, libwasmer), Cvoid, (Ptr{wasm_importtype_t},), arg1)
end

mutable struct wasm_importtype_vec_t
    size::Csize_t
    data::Ptr{Ptr{wasm_importtype_t}}
end

function wasm_importtype_vec_new_empty(out)
    ccall((:wasm_importtype_vec_new_empty, libwasmer), Cvoid, (Ptr{wasm_importtype_vec_t},), out)
end

function wasm_importtype_vec_new_uninitialized(out, arg2)
    ccall((:wasm_importtype_vec_new_uninitialized, libwasmer), Cvoid, (Ptr{wasm_importtype_vec_t}, Csize_t), out, arg2)
end

function wasm_importtype_vec_new(out, arg2, arg3)
    ccall((:wasm_importtype_vec_new, libwasmer), Cvoid, (Ptr{wasm_importtype_vec_t}, Csize_t, Ptr{Ptr{wasm_importtype_t}}), out, arg2, arg3)
end

function wasm_importtype_vec_copy(out, arg2)
    ccall((:wasm_importtype_vec_copy, libwasmer), Cvoid, (Ptr{wasm_importtype_vec_t}, Ptr{wasm_importtype_vec_t}), out, arg2)
end

function wasm_importtype_vec_delete(arg1)
    ccall((:wasm_importtype_vec_delete, libwasmer), Cvoid, (Ptr{wasm_importtype_vec_t},), arg1)
end

function wasm_importtype_copy(arg1)
    ccall((:wasm_importtype_copy, libwasmer), Ptr{wasm_importtype_t}, (Ptr{wasm_importtype_t},), arg1)
end

function wasm_importtype_new(_module, name, arg3)
    ccall((:wasm_importtype_new, libwasmer), Ptr{wasm_importtype_t}, (Ptr{wasm_name_t}, Ptr{wasm_name_t}, Ptr{wasm_externtype_t}), _module, name, arg3)
end

function wasm_importtype_module(arg1)
    ccall((:wasm_importtype_module, libwasmer), Ptr{wasm_name_t}, (Ptr{wasm_importtype_t},), arg1)
end

function wasm_importtype_name(arg1)
    ccall((:wasm_importtype_name, libwasmer), Ptr{wasm_name_t}, (Ptr{wasm_importtype_t},), arg1)
end

function wasm_importtype_type(arg1)
    ccall((:wasm_importtype_type, libwasmer), Ptr{wasm_externtype_t}, (Ptr{wasm_importtype_t},), arg1)
end

mutable struct wasm_exporttype_t end

function wasm_exporttype_delete(arg1)
    ccall((:wasm_exporttype_delete, libwasmer), Cvoid, (Ptr{wasm_exporttype_t},), arg1)
end

mutable struct wasm_exporttype_vec_t
    size::Csize_t
    data::Ptr{Ptr{wasm_exporttype_t}}
end

function wasm_exporttype_vec_new_empty(out)
    ccall((:wasm_exporttype_vec_new_empty, libwasmer), Cvoid, (Ptr{wasm_exporttype_vec_t},), out)
end

function wasm_exporttype_vec_new_uninitialized(out, arg2)
    ccall((:wasm_exporttype_vec_new_uninitialized, libwasmer), Cvoid, (Ptr{wasm_exporttype_vec_t}, Csize_t), out, arg2)
end

function wasm_exporttype_vec_new(out, arg2, arg3)
    ccall((:wasm_exporttype_vec_new, libwasmer), Cvoid, (Ptr{wasm_exporttype_vec_t}, Csize_t, Ptr{Ptr{wasm_exporttype_t}}), out, arg2, arg3)
end

function wasm_exporttype_vec_copy(out, arg2)
    ccall((:wasm_exporttype_vec_copy, libwasmer), Cvoid, (Ptr{wasm_exporttype_vec_t}, Ptr{wasm_exporttype_vec_t}), out, arg2)
end

function wasm_exporttype_vec_delete(arg1)
    ccall((:wasm_exporttype_vec_delete, libwasmer), Cvoid, (Ptr{wasm_exporttype_vec_t},), arg1)
end

function wasm_exporttype_copy(arg1)
    ccall((:wasm_exporttype_copy, libwasmer), Ptr{wasm_exporttype_t}, (Ptr{wasm_exporttype_t},), arg1)
end

function wasm_exporttype_new(arg1, arg2)
    ccall((:wasm_exporttype_new, libwasmer), Ptr{wasm_exporttype_t}, (Ptr{wasm_name_t}, Ptr{wasm_externtype_t}), arg1, arg2)
end

function wasm_exporttype_name(arg1)
    ccall((:wasm_exporttype_name, libwasmer), Ptr{wasm_name_t}, (Ptr{wasm_exporttype_t},), arg1)
end

function wasm_exporttype_type(arg1)
    ccall((:wasm_exporttype_type, libwasmer), Ptr{wasm_externtype_t}, (Ptr{wasm_exporttype_t},), arg1)
end

struct __JL_Ctag_18
    data::NTuple{8, UInt8}
end

function Base.getproperty(x::Ptr{__JL_Ctag_18}, f::Symbol)
    f === :i32 && return Ptr{Int32}(x + 0)
    f === :i64 && return Ptr{Int64}(x + 0)
    f === :f32 && return Ptr{float32_t}(x + 0)
    f === :f64 && return Ptr{float64_t}(x + 0)
    f === :ref && return Ptr{Ptr{wasm_ref_t}}(x + 0)
    return getfield(x, f)
end

function Base.getproperty(x::__JL_Ctag_18, f::Symbol)
    r = Ref{__JL_Ctag_18}(x)
    ptr = Base.unsafe_convert(Ptr{__JL_Ctag_18}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{__JL_Ctag_18}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

struct wasm_val_t
    data::NTuple{16, UInt8}
end

function Base.getproperty(x::Ptr{wasm_val_t}, f::Symbol)
    f === :kind && return Ptr{wasm_valkind_t}(x + 0)
    f === :of && return Ptr{__JL_Ctag_18}(x + 8)
    return getfield(x, f)
end

function Base.getproperty(x::wasm_val_t, f::Symbol)
    r = Ref{wasm_val_t}(x)
    ptr = Base.unsafe_convert(Ptr{wasm_val_t}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{wasm_val_t}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

function wasm_val_delete(v)
    ccall((:wasm_val_delete, libwasmer), Cvoid, (Ptr{wasm_val_t},), v)
end

function wasm_val_copy(out, arg2)
    ccall((:wasm_val_copy, libwasmer), Cvoid, (Ptr{wasm_val_t}, Ptr{wasm_val_t}), out, arg2)
end

mutable struct wasm_val_vec_t
    size::Csize_t
    data::Ptr{wasm_val_t}
end

function wasm_val_vec_new_empty(out)
    ccall((:wasm_val_vec_new_empty, libwasmer), Cvoid, (Ptr{wasm_val_vec_t},), out)
end

function wasm_val_vec_new_uninitialized(out, arg2)
    ccall((:wasm_val_vec_new_uninitialized, libwasmer), Cvoid, (Ptr{wasm_val_vec_t}, Csize_t), out, arg2)
end

function wasm_val_vec_new(out, arg2, arg3)
    ccall((:wasm_val_vec_new, libwasmer), Cvoid, (Ptr{wasm_val_vec_t}, Csize_t, Ptr{wasm_val_t}), out, arg2, arg3)
end

function wasm_val_vec_copy(out, arg2)
    ccall((:wasm_val_vec_copy, libwasmer), Cvoid, (Ptr{wasm_val_vec_t}, Ptr{wasm_val_vec_t}), out, arg2)
end

function wasm_val_vec_delete(arg1)
    ccall((:wasm_val_vec_delete, libwasmer), Cvoid, (Ptr{wasm_val_vec_t},), arg1)
end

function wasm_ref_delete(arg1)
    ccall((:wasm_ref_delete, libwasmer), Cvoid, (Ptr{wasm_ref_t},), arg1)
end

function wasm_ref_copy(arg1)
    ccall((:wasm_ref_copy, libwasmer), Ptr{wasm_ref_t}, (Ptr{wasm_ref_t},), arg1)
end

function wasm_ref_same(arg1, arg2)
    ccall((:wasm_ref_same, libwasmer), Bool, (Ptr{wasm_ref_t}, Ptr{wasm_ref_t}), arg1, arg2)
end

function wasm_ref_get_host_info(arg1)
    ccall((:wasm_ref_get_host_info, libwasmer), Ptr{Cvoid}, (Ptr{wasm_ref_t},), arg1)
end

function wasm_ref_set_host_info(arg1, arg2)
    ccall((:wasm_ref_set_host_info, libwasmer), Cvoid, (Ptr{wasm_ref_t}, Ptr{Cvoid}), arg1, arg2)
end

function wasm_ref_set_host_info_with_finalizer(arg1, arg2, arg3)
    ccall((:wasm_ref_set_host_info_with_finalizer, libwasmer), Cvoid, (Ptr{wasm_ref_t}, Ptr{Cvoid}, Ptr{Cvoid}), arg1, arg2, arg3)
end

mutable struct wasm_frame_t end

function wasm_frame_delete(arg1)
    ccall((:wasm_frame_delete, libwasmer), Cvoid, (Ptr{wasm_frame_t},), arg1)
end

mutable struct wasm_frame_vec_t
    size::Csize_t
    data::Ptr{Ptr{wasm_frame_t}}
end

function wasm_frame_vec_new_empty(out)
    ccall((:wasm_frame_vec_new_empty, libwasmer), Cvoid, (Ptr{wasm_frame_vec_t},), out)
end

function wasm_frame_vec_new_uninitialized(out, arg2)
    ccall((:wasm_frame_vec_new_uninitialized, libwasmer), Cvoid, (Ptr{wasm_frame_vec_t}, Csize_t), out, arg2)
end

function wasm_frame_vec_new(out, arg2, arg3)
    ccall((:wasm_frame_vec_new, libwasmer), Cvoid, (Ptr{wasm_frame_vec_t}, Csize_t, Ptr{Ptr{wasm_frame_t}}), out, arg2, arg3)
end

function wasm_frame_vec_copy(out, arg2)
    ccall((:wasm_frame_vec_copy, libwasmer), Cvoid, (Ptr{wasm_frame_vec_t}, Ptr{wasm_frame_vec_t}), out, arg2)
end

function wasm_frame_vec_delete(arg1)
    ccall((:wasm_frame_vec_delete, libwasmer), Cvoid, (Ptr{wasm_frame_vec_t},), arg1)
end

function wasm_frame_copy(arg1)
    ccall((:wasm_frame_copy, libwasmer), Ptr{wasm_frame_t}, (Ptr{wasm_frame_t},), arg1)
end

mutable struct wasm_instance_t end

function wasm_frame_instance(arg1)
    ccall((:wasm_frame_instance, libwasmer), Ptr{wasm_instance_t}, (Ptr{wasm_frame_t},), arg1)
end

function wasm_frame_func_index(arg1)
    ccall((:wasm_frame_func_index, libwasmer), UInt32, (Ptr{wasm_frame_t},), arg1)
end

function wasm_frame_func_offset(arg1)
    ccall((:wasm_frame_func_offset, libwasmer), Csize_t, (Ptr{wasm_frame_t},), arg1)
end

function wasm_frame_module_offset(arg1)
    ccall((:wasm_frame_module_offset, libwasmer), Csize_t, (Ptr{wasm_frame_t},), arg1)
end

const wasm_message_t = wasm_name_t

mutable struct wasm_trap_t end

function wasm_trap_delete(arg1)
    ccall((:wasm_trap_delete, libwasmer), Cvoid, (Ptr{wasm_trap_t},), arg1)
end

function wasm_trap_copy(arg1)
    ccall((:wasm_trap_copy, libwasmer), Ptr{wasm_trap_t}, (Ptr{wasm_trap_t},), arg1)
end

function wasm_trap_same(arg1, arg2)
    ccall((:wasm_trap_same, libwasmer), Bool, (Ptr{wasm_trap_t}, Ptr{wasm_trap_t}), arg1, arg2)
end

function wasm_trap_get_host_info(arg1)
    ccall((:wasm_trap_get_host_info, libwasmer), Ptr{Cvoid}, (Ptr{wasm_trap_t},), arg1)
end

function wasm_trap_set_host_info(arg1, arg2)
    ccall((:wasm_trap_set_host_info, libwasmer), Cvoid, (Ptr{wasm_trap_t}, Ptr{Cvoid}), arg1, arg2)
end

function wasm_trap_set_host_info_with_finalizer(arg1, arg2, arg3)
    ccall((:wasm_trap_set_host_info_with_finalizer, libwasmer), Cvoid, (Ptr{wasm_trap_t}, Ptr{Cvoid}, Ptr{Cvoid}), arg1, arg2, arg3)
end

function wasm_trap_as_ref(arg1)
    ccall((:wasm_trap_as_ref, libwasmer), Ptr{wasm_ref_t}, (Ptr{wasm_trap_t},), arg1)
end

function wasm_ref_as_trap(arg1)
    ccall((:wasm_ref_as_trap, libwasmer), Ptr{wasm_trap_t}, (Ptr{wasm_ref_t},), arg1)
end

function wasm_trap_as_ref_const(arg1)
    ccall((:wasm_trap_as_ref_const, libwasmer), Ptr{wasm_ref_t}, (Ptr{wasm_trap_t},), arg1)
end

function wasm_ref_as_trap_const(arg1)
    ccall((:wasm_ref_as_trap_const, libwasmer), Ptr{wasm_trap_t}, (Ptr{wasm_ref_t},), arg1)
end

function wasm_trap_new(store, arg2)
    ccall((:wasm_trap_new, libwasmer), Ptr{wasm_trap_t}, (Ptr{wasm_store_t}, Ptr{wasm_message_t}), store, arg2)
end

function wasm_trap_message(arg1, out)
    ccall((:wasm_trap_message, libwasmer), Cvoid, (Ptr{wasm_trap_t}, Ptr{wasm_message_t}), arg1, out)
end

function wasm_trap_origin(arg1)
    ccall((:wasm_trap_origin, libwasmer), Ptr{wasm_frame_t}, (Ptr{wasm_trap_t},), arg1)
end

function wasm_trap_trace(arg1, out)
    ccall((:wasm_trap_trace, libwasmer), Cvoid, (Ptr{wasm_trap_t}, Ptr{wasm_frame_vec_t}), arg1, out)
end

mutable struct wasm_foreign_t end

function wasm_foreign_delete(arg1)
    ccall((:wasm_foreign_delete, libwasmer), Cvoid, (Ptr{wasm_foreign_t},), arg1)
end

function wasm_foreign_copy(arg1)
    ccall((:wasm_foreign_copy, libwasmer), Ptr{wasm_foreign_t}, (Ptr{wasm_foreign_t},), arg1)
end

function wasm_foreign_same(arg1, arg2)
    ccall((:wasm_foreign_same, libwasmer), Bool, (Ptr{wasm_foreign_t}, Ptr{wasm_foreign_t}), arg1, arg2)
end

function wasm_foreign_get_host_info(arg1)
    ccall((:wasm_foreign_get_host_info, libwasmer), Ptr{Cvoid}, (Ptr{wasm_foreign_t},), arg1)
end

function wasm_foreign_set_host_info(arg1, arg2)
    ccall((:wasm_foreign_set_host_info, libwasmer), Cvoid, (Ptr{wasm_foreign_t}, Ptr{Cvoid}), arg1, arg2)
end

function wasm_foreign_set_host_info_with_finalizer(arg1, arg2, arg3)
    ccall((:wasm_foreign_set_host_info_with_finalizer, libwasmer), Cvoid, (Ptr{wasm_foreign_t}, Ptr{Cvoid}, Ptr{Cvoid}), arg1, arg2, arg3)
end

function wasm_foreign_as_ref(arg1)
    ccall((:wasm_foreign_as_ref, libwasmer), Ptr{wasm_ref_t}, (Ptr{wasm_foreign_t},), arg1)
end

function wasm_ref_as_foreign(arg1)
    ccall((:wasm_ref_as_foreign, libwasmer), Ptr{wasm_foreign_t}, (Ptr{wasm_ref_t},), arg1)
end

function wasm_foreign_as_ref_const(arg1)
    ccall((:wasm_foreign_as_ref_const, libwasmer), Ptr{wasm_ref_t}, (Ptr{wasm_foreign_t},), arg1)
end

function wasm_ref_as_foreign_const(arg1)
    ccall((:wasm_ref_as_foreign_const, libwasmer), Ptr{wasm_foreign_t}, (Ptr{wasm_ref_t},), arg1)
end

function wasm_foreign_new(arg1)
    ccall((:wasm_foreign_new, libwasmer), Ptr{wasm_foreign_t}, (Ptr{wasm_store_t},), arg1)
end

mutable struct wasm_module_t end

function wasm_module_delete(arg1)
    ccall((:wasm_module_delete, libwasmer), Cvoid, (Ptr{wasm_module_t},), arg1)
end

function wasm_module_copy(arg1)
    ccall((:wasm_module_copy, libwasmer), Ptr{wasm_module_t}, (Ptr{wasm_module_t},), arg1)
end

function wasm_module_same(arg1, arg2)
    ccall((:wasm_module_same, libwasmer), Bool, (Ptr{wasm_module_t}, Ptr{wasm_module_t}), arg1, arg2)
end

function wasm_module_get_host_info(arg1)
    ccall((:wasm_module_get_host_info, libwasmer), Ptr{Cvoid}, (Ptr{wasm_module_t},), arg1)
end

function wasm_module_set_host_info(arg1, arg2)
    ccall((:wasm_module_set_host_info, libwasmer), Cvoid, (Ptr{wasm_module_t}, Ptr{Cvoid}), arg1, arg2)
end

function wasm_module_set_host_info_with_finalizer(arg1, arg2, arg3)
    ccall((:wasm_module_set_host_info_with_finalizer, libwasmer), Cvoid, (Ptr{wasm_module_t}, Ptr{Cvoid}, Ptr{Cvoid}), arg1, arg2, arg3)
end

function wasm_module_as_ref(arg1)
    ccall((:wasm_module_as_ref, libwasmer), Ptr{wasm_ref_t}, (Ptr{wasm_module_t},), arg1)
end

function wasm_ref_as_module(arg1)
    ccall((:wasm_ref_as_module, libwasmer), Ptr{wasm_module_t}, (Ptr{wasm_ref_t},), arg1)
end

function wasm_module_as_ref_const(arg1)
    ccall((:wasm_module_as_ref_const, libwasmer), Ptr{wasm_ref_t}, (Ptr{wasm_module_t},), arg1)
end

function wasm_ref_as_module_const(arg1)
    ccall((:wasm_ref_as_module_const, libwasmer), Ptr{wasm_module_t}, (Ptr{wasm_ref_t},), arg1)
end

mutable struct wasm_shared_module_t end

function wasm_shared_module_delete(arg1)
    ccall((:wasm_shared_module_delete, libwasmer), Cvoid, (Ptr{wasm_shared_module_t},), arg1)
end

function wasm_module_share(arg1)
    ccall((:wasm_module_share, libwasmer), Ptr{wasm_shared_module_t}, (Ptr{wasm_module_t},), arg1)
end

function wasm_module_obtain(arg1, arg2)
    ccall((:wasm_module_obtain, libwasmer), Ptr{wasm_module_t}, (Ptr{wasm_store_t}, Ptr{wasm_shared_module_t}), arg1, arg2)
end

function wasm_module_new(arg1, binary)
    ccall((:wasm_module_new, libwasmer), Ptr{wasm_module_t}, (Ptr{wasm_store_t}, Ptr{wasm_byte_vec_t}), arg1, binary)
end

function wasm_module_validate(arg1, binary)
    ccall((:wasm_module_validate, libwasmer), Bool, (Ptr{wasm_store_t}, Ptr{wasm_byte_vec_t}), arg1, binary)
end

function wasm_module_imports(arg1, out)
    ccall((:wasm_module_imports, libwasmer), Cvoid, (Ptr{wasm_module_t}, Ptr{wasm_importtype_vec_t}), arg1, out)
end

function wasm_module_exports(arg1, out)
    ccall((:wasm_module_exports, libwasmer), Cvoid, (Ptr{wasm_module_t}, Ptr{wasm_exporttype_vec_t}), arg1, out)
end

function wasm_module_serialize(arg1, out)
    ccall((:wasm_module_serialize, libwasmer), Cvoid, (Ptr{wasm_module_t}, Ptr{wasm_byte_vec_t}), arg1, out)
end

function wasm_module_deserialize(arg1, arg2)
    ccall((:wasm_module_deserialize, libwasmer), Ptr{wasm_module_t}, (Ptr{wasm_store_t}, Ptr{wasm_byte_vec_t}), arg1, arg2)
end

mutable struct wasm_func_t end

function wasm_func_delete(arg1)
    ccall((:wasm_func_delete, libwasmer), Cvoid, (Ptr{wasm_func_t},), arg1)
end

function wasm_func_copy(arg1)
    ccall((:wasm_func_copy, libwasmer), Ptr{wasm_func_t}, (Ptr{wasm_func_t},), arg1)
end

function wasm_func_same(arg1, arg2)
    ccall((:wasm_func_same, libwasmer), Bool, (Ptr{wasm_func_t}, Ptr{wasm_func_t}), arg1, arg2)
end

function wasm_func_get_host_info(arg1)
    ccall((:wasm_func_get_host_info, libwasmer), Ptr{Cvoid}, (Ptr{wasm_func_t},), arg1)
end

function wasm_func_set_host_info(arg1, arg2)
    ccall((:wasm_func_set_host_info, libwasmer), Cvoid, (Ptr{wasm_func_t}, Ptr{Cvoid}), arg1, arg2)
end

function wasm_func_set_host_info_with_finalizer(arg1, arg2, arg3)
    ccall((:wasm_func_set_host_info_with_finalizer, libwasmer), Cvoid, (Ptr{wasm_func_t}, Ptr{Cvoid}, Ptr{Cvoid}), arg1, arg2, arg3)
end

function wasm_func_as_ref(arg1)
    ccall((:wasm_func_as_ref, libwasmer), Ptr{wasm_ref_t}, (Ptr{wasm_func_t},), arg1)
end

function wasm_ref_as_func(arg1)
    ccall((:wasm_ref_as_func, libwasmer), Ptr{wasm_func_t}, (Ptr{wasm_ref_t},), arg1)
end

function wasm_func_as_ref_const(arg1)
    ccall((:wasm_func_as_ref_const, libwasmer), Ptr{wasm_ref_t}, (Ptr{wasm_func_t},), arg1)
end

function wasm_ref_as_func_const(arg1)
    ccall((:wasm_ref_as_func_const, libwasmer), Ptr{wasm_func_t}, (Ptr{wasm_ref_t},), arg1)
end

# typedef own wasm_trap_t * ( * wasm_func_callback_t ) ( const wasm_val_vec_t * args , own wasm_val_vec_t * results )
const wasm_func_callback_t = Ptr{Cvoid}

# typedef own wasm_trap_t * ( * wasm_func_callback_with_env_t ) ( void * env , const wasm_val_vec_t * args , wasm_val_vec_t * results )
const wasm_func_callback_with_env_t = Ptr{Cvoid}

function wasm_func_new(arg1, arg2, arg3)
    ccall((:wasm_func_new, libwasmer), Ptr{wasm_func_t}, (Ptr{wasm_store_t}, Ptr{wasm_functype_t}, wasm_func_callback_t), arg1, arg2, arg3)
end

function wasm_func_new_with_env(arg1, type, arg3, env, finalizer)
    ccall((:wasm_func_new_with_env, libwasmer), Ptr{wasm_func_t}, (Ptr{wasm_store_t}, Ptr{wasm_functype_t}, wasm_func_callback_with_env_t, Ptr{Cvoid}, Ptr{Cvoid}), arg1, type, arg3, env, finalizer)
end

function wasm_func_type(arg1)
    ccall((:wasm_func_type, libwasmer), Ptr{wasm_functype_t}, (Ptr{wasm_func_t},), arg1)
end

function wasm_func_param_arity(arg1)
    ccall((:wasm_func_param_arity, libwasmer), Csize_t, (Ptr{wasm_func_t},), arg1)
end

function wasm_func_result_arity(arg1)
    ccall((:wasm_func_result_arity, libwasmer), Csize_t, (Ptr{wasm_func_t},), arg1)
end

function wasm_func_call(arg1, args, results)
    ccall((:wasm_func_call, libwasmer), Ptr{wasm_trap_t}, (Ptr{wasm_func_t}, Ptr{wasm_val_vec_t}, Ptr{wasm_val_vec_t}), arg1, args, results)
end

mutable struct wasm_global_t end

function wasm_global_delete(arg1)
    ccall((:wasm_global_delete, libwasmer), Cvoid, (Ptr{wasm_global_t},), arg1)
end

function wasm_global_copy(arg1)
    ccall((:wasm_global_copy, libwasmer), Ptr{wasm_global_t}, (Ptr{wasm_global_t},), arg1)
end

function wasm_global_same(arg1, arg2)
    ccall((:wasm_global_same, libwasmer), Bool, (Ptr{wasm_global_t}, Ptr{wasm_global_t}), arg1, arg2)
end

function wasm_global_get_host_info(arg1)
    ccall((:wasm_global_get_host_info, libwasmer), Ptr{Cvoid}, (Ptr{wasm_global_t},), arg1)
end

function wasm_global_set_host_info(arg1, arg2)
    ccall((:wasm_global_set_host_info, libwasmer), Cvoid, (Ptr{wasm_global_t}, Ptr{Cvoid}), arg1, arg2)
end

function wasm_global_set_host_info_with_finalizer(arg1, arg2, arg3)
    ccall((:wasm_global_set_host_info_with_finalizer, libwasmer), Cvoid, (Ptr{wasm_global_t}, Ptr{Cvoid}, Ptr{Cvoid}), arg1, arg2, arg3)
end

function wasm_global_as_ref(arg1)
    ccall((:wasm_global_as_ref, libwasmer), Ptr{wasm_ref_t}, (Ptr{wasm_global_t},), arg1)
end

function wasm_ref_as_global(arg1)
    ccall((:wasm_ref_as_global, libwasmer), Ptr{wasm_global_t}, (Ptr{wasm_ref_t},), arg1)
end

function wasm_global_as_ref_const(arg1)
    ccall((:wasm_global_as_ref_const, libwasmer), Ptr{wasm_ref_t}, (Ptr{wasm_global_t},), arg1)
end

function wasm_ref_as_global_const(arg1)
    ccall((:wasm_ref_as_global_const, libwasmer), Ptr{wasm_global_t}, (Ptr{wasm_ref_t},), arg1)
end

function wasm_global_new(arg1, arg2, arg3)
    ccall((:wasm_global_new, libwasmer), Ptr{wasm_global_t}, (Ptr{wasm_store_t}, Ptr{wasm_globaltype_t}, Ptr{wasm_val_t}), arg1, arg2, arg3)
end

function wasm_global_type(arg1)
    ccall((:wasm_global_type, libwasmer), Ptr{wasm_globaltype_t}, (Ptr{wasm_global_t},), arg1)
end

function wasm_global_get(arg1, out)
    ccall((:wasm_global_get, libwasmer), Cvoid, (Ptr{wasm_global_t}, Ptr{wasm_val_t}), arg1, out)
end

function wasm_global_set(arg1, arg2)
    ccall((:wasm_global_set, libwasmer), Cvoid, (Ptr{wasm_global_t}, Ptr{wasm_val_t}), arg1, arg2)
end

mutable struct wasm_table_t end

function wasm_table_delete(arg1)
    ccall((:wasm_table_delete, libwasmer), Cvoid, (Ptr{wasm_table_t},), arg1)
end

function wasm_table_copy(arg1)
    ccall((:wasm_table_copy, libwasmer), Ptr{wasm_table_t}, (Ptr{wasm_table_t},), arg1)
end

function wasm_table_same(arg1, arg2)
    ccall((:wasm_table_same, libwasmer), Bool, (Ptr{wasm_table_t}, Ptr{wasm_table_t}), arg1, arg2)
end

function wasm_table_get_host_info(arg1)
    ccall((:wasm_table_get_host_info, libwasmer), Ptr{Cvoid}, (Ptr{wasm_table_t},), arg1)
end

function wasm_table_set_host_info(arg1, arg2)
    ccall((:wasm_table_set_host_info, libwasmer), Cvoid, (Ptr{wasm_table_t}, Ptr{Cvoid}), arg1, arg2)
end

function wasm_table_set_host_info_with_finalizer(arg1, arg2, arg3)
    ccall((:wasm_table_set_host_info_with_finalizer, libwasmer), Cvoid, (Ptr{wasm_table_t}, Ptr{Cvoid}, Ptr{Cvoid}), arg1, arg2, arg3)
end

function wasm_table_as_ref(arg1)
    ccall((:wasm_table_as_ref, libwasmer), Ptr{wasm_ref_t}, (Ptr{wasm_table_t},), arg1)
end

function wasm_ref_as_table(arg1)
    ccall((:wasm_ref_as_table, libwasmer), Ptr{wasm_table_t}, (Ptr{wasm_ref_t},), arg1)
end

function wasm_table_as_ref_const(arg1)
    ccall((:wasm_table_as_ref_const, libwasmer), Ptr{wasm_ref_t}, (Ptr{wasm_table_t},), arg1)
end

function wasm_ref_as_table_const(arg1)
    ccall((:wasm_ref_as_table_const, libwasmer), Ptr{wasm_table_t}, (Ptr{wasm_ref_t},), arg1)
end

const wasm_table_size_t = UInt32

function wasm_table_new(arg1, arg2, init)
    ccall((:wasm_table_new, libwasmer), Ptr{wasm_table_t}, (Ptr{wasm_store_t}, Ptr{wasm_tabletype_t}, Ptr{wasm_ref_t}), arg1, arg2, init)
end

function wasm_table_type(arg1)
    ccall((:wasm_table_type, libwasmer), Ptr{wasm_tabletype_t}, (Ptr{wasm_table_t},), arg1)
end

function wasm_table_get(arg1, index)
    ccall((:wasm_table_get, libwasmer), Ptr{wasm_ref_t}, (Ptr{wasm_table_t}, wasm_table_size_t), arg1, index)
end

function wasm_table_set(arg1, index, arg3)
    ccall((:wasm_table_set, libwasmer), Bool, (Ptr{wasm_table_t}, wasm_table_size_t, Ptr{wasm_ref_t}), arg1, index, arg3)
end

function wasm_table_size(arg1)
    ccall((:wasm_table_size, libwasmer), wasm_table_size_t, (Ptr{wasm_table_t},), arg1)
end

function wasm_table_grow(arg1, delta, init)
    ccall((:wasm_table_grow, libwasmer), Bool, (Ptr{wasm_table_t}, wasm_table_size_t, Ptr{wasm_ref_t}), arg1, delta, init)
end

mutable struct wasm_memory_t end

function wasm_memory_delete(arg1)
    ccall((:wasm_memory_delete, libwasmer), Cvoid, (Ptr{wasm_memory_t},), arg1)
end

function wasm_memory_copy(arg1)
    ccall((:wasm_memory_copy, libwasmer), Ptr{wasm_memory_t}, (Ptr{wasm_memory_t},), arg1)
end

function wasm_memory_same(arg1, arg2)
    ccall((:wasm_memory_same, libwasmer), Bool, (Ptr{wasm_memory_t}, Ptr{wasm_memory_t}), arg1, arg2)
end

function wasm_memory_get_host_info(arg1)
    ccall((:wasm_memory_get_host_info, libwasmer), Ptr{Cvoid}, (Ptr{wasm_memory_t},), arg1)
end

function wasm_memory_set_host_info(arg1, arg2)
    ccall((:wasm_memory_set_host_info, libwasmer), Cvoid, (Ptr{wasm_memory_t}, Ptr{Cvoid}), arg1, arg2)
end

function wasm_memory_set_host_info_with_finalizer(arg1, arg2, arg3)
    ccall((:wasm_memory_set_host_info_with_finalizer, libwasmer), Cvoid, (Ptr{wasm_memory_t}, Ptr{Cvoid}, Ptr{Cvoid}), arg1, arg2, arg3)
end

function wasm_memory_as_ref(arg1)
    ccall((:wasm_memory_as_ref, libwasmer), Ptr{wasm_ref_t}, (Ptr{wasm_memory_t},), arg1)
end

function wasm_ref_as_memory(arg1)
    ccall((:wasm_ref_as_memory, libwasmer), Ptr{wasm_memory_t}, (Ptr{wasm_ref_t},), arg1)
end

function wasm_memory_as_ref_const(arg1)
    ccall((:wasm_memory_as_ref_const, libwasmer), Ptr{wasm_ref_t}, (Ptr{wasm_memory_t},), arg1)
end

function wasm_ref_as_memory_const(arg1)
    ccall((:wasm_ref_as_memory_const, libwasmer), Ptr{wasm_memory_t}, (Ptr{wasm_ref_t},), arg1)
end

const wasm_memory_pages_t = UInt32

function wasm_memory_new(arg1, arg2)
    ccall((:wasm_memory_new, libwasmer), Ptr{wasm_memory_t}, (Ptr{wasm_store_t}, Ptr{wasm_memorytype_t}), arg1, arg2)
end

function wasm_memory_type(arg1)
    ccall((:wasm_memory_type, libwasmer), Ptr{wasm_memorytype_t}, (Ptr{wasm_memory_t},), arg1)
end

function wasm_memory_data(arg1)
    ccall((:wasm_memory_data, libwasmer), Ptr{byte_t}, (Ptr{wasm_memory_t},), arg1)
end

function wasm_memory_data_size(arg1)
    ccall((:wasm_memory_data_size, libwasmer), Csize_t, (Ptr{wasm_memory_t},), arg1)
end

function wasm_memory_size(arg1)
    ccall((:wasm_memory_size, libwasmer), wasm_memory_pages_t, (Ptr{wasm_memory_t},), arg1)
end

function wasm_memory_grow(arg1, delta)
    ccall((:wasm_memory_grow, libwasmer), Bool, (Ptr{wasm_memory_t}, wasm_memory_pages_t), arg1, delta)
end

mutable struct wasm_extern_t end

function wasm_extern_delete(arg1)
    ccall((:wasm_extern_delete, libwasmer), Cvoid, (Ptr{wasm_extern_t},), arg1)
end

function wasm_extern_copy(arg1)
    ccall((:wasm_extern_copy, libwasmer), Ptr{wasm_extern_t}, (Ptr{wasm_extern_t},), arg1)
end

function wasm_extern_same(arg1, arg2)
    ccall((:wasm_extern_same, libwasmer), Bool, (Ptr{wasm_extern_t}, Ptr{wasm_extern_t}), arg1, arg2)
end

function wasm_extern_get_host_info(arg1)
    ccall((:wasm_extern_get_host_info, libwasmer), Ptr{Cvoid}, (Ptr{wasm_extern_t},), arg1)
end

function wasm_extern_set_host_info(arg1, arg2)
    ccall((:wasm_extern_set_host_info, libwasmer), Cvoid, (Ptr{wasm_extern_t}, Ptr{Cvoid}), arg1, arg2)
end

function wasm_extern_set_host_info_with_finalizer(arg1, arg2, arg3)
    ccall((:wasm_extern_set_host_info_with_finalizer, libwasmer), Cvoid, (Ptr{wasm_extern_t}, Ptr{Cvoid}, Ptr{Cvoid}), arg1, arg2, arg3)
end

function wasm_extern_as_ref(arg1)
    ccall((:wasm_extern_as_ref, libwasmer), Ptr{wasm_ref_t}, (Ptr{wasm_extern_t},), arg1)
end

function wasm_ref_as_extern(arg1)
    ccall((:wasm_ref_as_extern, libwasmer), Ptr{wasm_extern_t}, (Ptr{wasm_ref_t},), arg1)
end

function wasm_extern_as_ref_const(arg1)
    ccall((:wasm_extern_as_ref_const, libwasmer), Ptr{wasm_ref_t}, (Ptr{wasm_extern_t},), arg1)
end

function wasm_ref_as_extern_const(arg1)
    ccall((:wasm_ref_as_extern_const, libwasmer), Ptr{wasm_extern_t}, (Ptr{wasm_ref_t},), arg1)
end

mutable struct wasm_extern_vec_t
    size::Csize_t
    data::Ptr{Ptr{wasm_extern_t}}
end

function wasm_extern_vec_new_empty(out)
    ccall((:wasm_extern_vec_new_empty, libwasmer), Cvoid, (Ptr{wasm_extern_vec_t},), out)
end

function wasm_extern_vec_new_uninitialized(out, arg2)
    ccall((:wasm_extern_vec_new_uninitialized, libwasmer), Cvoid, (Ptr{wasm_extern_vec_t}, Csize_t), out, arg2)
end

function wasm_extern_vec_new(out, arg2, arg3)
    ccall((:wasm_extern_vec_new, libwasmer), Cvoid, (Ptr{wasm_extern_vec_t}, Csize_t, Ptr{Ptr{wasm_extern_t}}), out, arg2, arg3)
end

function wasm_extern_vec_copy(out, arg2)
    ccall((:wasm_extern_vec_copy, libwasmer), Cvoid, (Ptr{wasm_extern_vec_t}, Ptr{wasm_extern_vec_t}), out, arg2)
end

function wasm_extern_vec_delete(arg1)
    ccall((:wasm_extern_vec_delete, libwasmer), Cvoid, (Ptr{wasm_extern_vec_t},), arg1)
end

function wasm_extern_kind(arg1)
    ccall((:wasm_extern_kind, libwasmer), wasm_externkind_t, (Ptr{wasm_extern_t},), arg1)
end

function wasm_extern_type(arg1)
    ccall((:wasm_extern_type, libwasmer), Ptr{wasm_externtype_t}, (Ptr{wasm_extern_t},), arg1)
end

function wasm_func_as_extern(arg1)
    ccall((:wasm_func_as_extern, libwasmer), Ptr{wasm_extern_t}, (Ptr{wasm_func_t},), arg1)
end

function wasm_global_as_extern(arg1)
    ccall((:wasm_global_as_extern, libwasmer), Ptr{wasm_extern_t}, (Ptr{wasm_global_t},), arg1)
end

function wasm_table_as_extern(arg1)
    ccall((:wasm_table_as_extern, libwasmer), Ptr{wasm_extern_t}, (Ptr{wasm_table_t},), arg1)
end

function wasm_memory_as_extern(arg1)
    ccall((:wasm_memory_as_extern, libwasmer), Ptr{wasm_extern_t}, (Ptr{wasm_memory_t},), arg1)
end

function wasm_extern_as_func(arg1)
    ccall((:wasm_extern_as_func, libwasmer), Ptr{wasm_func_t}, (Ptr{wasm_extern_t},), arg1)
end

function wasm_extern_as_global(arg1)
    ccall((:wasm_extern_as_global, libwasmer), Ptr{wasm_global_t}, (Ptr{wasm_extern_t},), arg1)
end

function wasm_extern_as_table(arg1)
    ccall((:wasm_extern_as_table, libwasmer), Ptr{wasm_table_t}, (Ptr{wasm_extern_t},), arg1)
end

function wasm_extern_as_memory(arg1)
    ccall((:wasm_extern_as_memory, libwasmer), Ptr{wasm_memory_t}, (Ptr{wasm_extern_t},), arg1)
end

function wasm_func_as_extern_const(arg1)
    ccall((:wasm_func_as_extern_const, libwasmer), Ptr{wasm_extern_t}, (Ptr{wasm_func_t},), arg1)
end

function wasm_global_as_extern_const(arg1)
    ccall((:wasm_global_as_extern_const, libwasmer), Ptr{wasm_extern_t}, (Ptr{wasm_global_t},), arg1)
end

function wasm_table_as_extern_const(arg1)
    ccall((:wasm_table_as_extern_const, libwasmer), Ptr{wasm_extern_t}, (Ptr{wasm_table_t},), arg1)
end

function wasm_memory_as_extern_const(arg1)
    ccall((:wasm_memory_as_extern_const, libwasmer), Ptr{wasm_extern_t}, (Ptr{wasm_memory_t},), arg1)
end

function wasm_extern_as_func_const(arg1)
    ccall((:wasm_extern_as_func_const, libwasmer), Ptr{wasm_func_t}, (Ptr{wasm_extern_t},), arg1)
end

function wasm_extern_as_global_const(arg1)
    ccall((:wasm_extern_as_global_const, libwasmer), Ptr{wasm_global_t}, (Ptr{wasm_extern_t},), arg1)
end

function wasm_extern_as_table_const(arg1)
    ccall((:wasm_extern_as_table_const, libwasmer), Ptr{wasm_table_t}, (Ptr{wasm_extern_t},), arg1)
end

function wasm_extern_as_memory_const(arg1)
    ccall((:wasm_extern_as_memory_const, libwasmer), Ptr{wasm_memory_t}, (Ptr{wasm_extern_t},), arg1)
end

function wasm_instance_delete(arg1)
    ccall((:wasm_instance_delete, libwasmer), Cvoid, (Ptr{wasm_instance_t},), arg1)
end

function wasm_instance_copy(arg1)
    ccall((:wasm_instance_copy, libwasmer), Ptr{wasm_instance_t}, (Ptr{wasm_instance_t},), arg1)
end

function wasm_instance_same(arg1, arg2)
    ccall((:wasm_instance_same, libwasmer), Bool, (Ptr{wasm_instance_t}, Ptr{wasm_instance_t}), arg1, arg2)
end

function wasm_instance_get_host_info(arg1)
    ccall((:wasm_instance_get_host_info, libwasmer), Ptr{Cvoid}, (Ptr{wasm_instance_t},), arg1)
end

function wasm_instance_set_host_info(arg1, arg2)
    ccall((:wasm_instance_set_host_info, libwasmer), Cvoid, (Ptr{wasm_instance_t}, Ptr{Cvoid}), arg1, arg2)
end

function wasm_instance_set_host_info_with_finalizer(arg1, arg2, arg3)
    ccall((:wasm_instance_set_host_info_with_finalizer, libwasmer), Cvoid, (Ptr{wasm_instance_t}, Ptr{Cvoid}, Ptr{Cvoid}), arg1, arg2, arg3)
end

function wasm_instance_as_ref(arg1)
    ccall((:wasm_instance_as_ref, libwasmer), Ptr{wasm_ref_t}, (Ptr{wasm_instance_t},), arg1)
end

function wasm_ref_as_instance(arg1)
    ccall((:wasm_ref_as_instance, libwasmer), Ptr{wasm_instance_t}, (Ptr{wasm_ref_t},), arg1)
end

function wasm_instance_as_ref_const(arg1)
    ccall((:wasm_instance_as_ref_const, libwasmer), Ptr{wasm_ref_t}, (Ptr{wasm_instance_t},), arg1)
end

function wasm_ref_as_instance_const(arg1)
    ccall((:wasm_ref_as_instance_const, libwasmer), Ptr{wasm_instance_t}, (Ptr{wasm_ref_t},), arg1)
end

function wasm_instance_new(arg1, arg2, imports, arg4)
    ccall((:wasm_instance_new, libwasmer), Ptr{wasm_instance_t}, (Ptr{wasm_store_t}, Ptr{wasm_module_t}, Ptr{wasm_extern_vec_t}, Ptr{Ptr{wasm_trap_t}}), arg1, arg2, imports, arg4)
end

function wasm_instance_exports(arg1, out)
    ccall((:wasm_instance_exports, libwasmer), Cvoid, (Ptr{wasm_instance_t}, Ptr{wasm_extern_vec_t}), arg1, out)
end

# no prototype is found for this function at wasm.h:537:35, please use with caution
function wasm_valtype_new_i32()
    ccall((:wasm_valtype_new_i32, libwasmer), Ptr{wasm_valtype_t}, ())
end

# no prototype is found for this function at wasm.h:540:35, please use with caution
function wasm_valtype_new_i64()
    ccall((:wasm_valtype_new_i64, libwasmer), Ptr{wasm_valtype_t}, ())
end

# no prototype is found for this function at wasm.h:543:35, please use with caution
function wasm_valtype_new_f32()
    ccall((:wasm_valtype_new_f32, libwasmer), Ptr{wasm_valtype_t}, ())
end

# no prototype is found for this function at wasm.h:546:35, please use with caution
function wasm_valtype_new_f64()
    ccall((:wasm_valtype_new_f64, libwasmer), Ptr{wasm_valtype_t}, ())
end

# no prototype is found for this function at wasm.h:550:35, please use with caution
function wasm_valtype_new_anyref()
    ccall((:wasm_valtype_new_anyref, libwasmer), Ptr{wasm_valtype_t}, ())
end

# no prototype is found for this function at wasm.h:553:35, please use with caution
function wasm_valtype_new_funcref()
    ccall((:wasm_valtype_new_funcref, libwasmer), Ptr{wasm_valtype_t}, ())
end

# no prototype is found for this function at wasm.h:560:36, please use with caution
function wasm_functype_new_0_0()
    ccall((:wasm_functype_new_0_0, libwasmer), Ptr{wasm_functype_t}, ())
end

function wasm_functype_new_1_0(p)
    ccall((:wasm_functype_new_1_0, libwasmer), Ptr{wasm_functype_t}, (Ptr{wasm_valtype_t},), p)
end

function wasm_functype_new_2_0(p1, p2)
    ccall((:wasm_functype_new_2_0, libwasmer), Ptr{wasm_functype_t}, (Ptr{wasm_valtype_t}, Ptr{wasm_valtype_t}), p1, p2)
end

function wasm_functype_new_3_0(p1, p2, p3)
    ccall((:wasm_functype_new_3_0, libwasmer), Ptr{wasm_functype_t}, (Ptr{wasm_valtype_t}, Ptr{wasm_valtype_t}, Ptr{wasm_valtype_t}), p1, p2, p3)
end

function wasm_functype_new_0_1(r)
    ccall((:wasm_functype_new_0_1, libwasmer), Ptr{wasm_functype_t}, (Ptr{wasm_valtype_t},), r)
end

function wasm_functype_new_1_1(p, r)
    ccall((:wasm_functype_new_1_1, libwasmer), Ptr{wasm_functype_t}, (Ptr{wasm_valtype_t}, Ptr{wasm_valtype_t}), p, r)
end

function wasm_functype_new_2_1(p1, p2, r)
    ccall((:wasm_functype_new_2_1, libwasmer), Ptr{wasm_functype_t}, (Ptr{wasm_valtype_t}, Ptr{wasm_valtype_t}, Ptr{wasm_valtype_t}), p1, p2, r)
end

function wasm_functype_new_3_1(p1, p2, p3, r)
    ccall((:wasm_functype_new_3_1, libwasmer), Ptr{wasm_functype_t}, (Ptr{wasm_valtype_t}, Ptr{wasm_valtype_t}, Ptr{wasm_valtype_t}, Ptr{wasm_valtype_t}), p1, p2, p3, r)
end

function wasm_functype_new_0_2(r1, r2)
    ccall((:wasm_functype_new_0_2, libwasmer), Ptr{wasm_functype_t}, (Ptr{wasm_valtype_t}, Ptr{wasm_valtype_t}), r1, r2)
end

function wasm_functype_new_1_2(p, r1, r2)
    ccall((:wasm_functype_new_1_2, libwasmer), Ptr{wasm_functype_t}, (Ptr{wasm_valtype_t}, Ptr{wasm_valtype_t}, Ptr{wasm_valtype_t}), p, r1, r2)
end

function wasm_functype_new_2_2(p1, p2, r1, r2)
    ccall((:wasm_functype_new_2_2, libwasmer), Ptr{wasm_functype_t}, (Ptr{wasm_valtype_t}, Ptr{wasm_valtype_t}, Ptr{wasm_valtype_t}, Ptr{wasm_valtype_t}), p1, p2, r1, r2)
end

function wasm_functype_new_3_2(p1, p2, p3, r1, r2)
    ccall((:wasm_functype_new_3_2, libwasmer), Ptr{wasm_functype_t}, (Ptr{wasm_valtype_t}, Ptr{wasm_valtype_t}, Ptr{wasm_valtype_t}, Ptr{wasm_valtype_t}, Ptr{wasm_valtype_t}), p1, p2, p3, r1, r2)
end

function wasm_val_init_ptr(out, p)
    ccall((:wasm_val_init_ptr, libwasmer), Cvoid, (Ptr{wasm_val_t}, Ptr{Cvoid}), out, p)
end

function wasm_val_ptr(val)
    ccall((:wasm_val_ptr, libwasmer), Ptr{Cvoid}, (Ptr{wasm_val_t},), val)
end

@cenum wasi_version_t::Int32 begin
    INVALID_VERSION = -1
    LATEST = 0
    SNAPSHOT0 = 1
    SNAPSHOT1 = 2
end

@cenum wasmer_compiler_t::UInt32 begin
    CRANELIFT = 0
    LLVM = 1
    SINGLEPASS = 2
end

@cenum wasmer_engine_t::UInt32 begin
    UNIVERSAL = 0
    DYLIB = 1
    STATICLIB = 2
end

@cenum wasmer_parser_operator_t::UInt32 begin
    Unreachable = 0
    Nop = 1
    Block = 2
    Loop = 3
    If = 4
    Else = 5
    Try = 6
    Catch = 7
    CatchAll = 8
    Delegate = 9
    Throw = 10
    Rethrow = 11
    Unwind = 12
    End = 13
    Br = 14
    BrIf = 15
    BrTable = 16
    Return = 17
    Call = 18
    CallIndirect = 19
    ReturnCall = 20
    ReturnCallIndirect = 21
    Drop = 22
    Select = 23
    TypedSelect = 24
    LocalGet = 25
    LocalSet = 26
    LocalTee = 27
    GlobalGet = 28
    GlobalSet = 29
    I32Load = 30
    I64Load = 31
    F32Load = 32
    F64Load = 33
    I32Load8S = 34
    I32Load8U = 35
    I32Load16S = 36
    I32Load16U = 37
    I64Load8S = 38
    I64Load8U = 39
    I64Load16S = 40
    I64Load16U = 41
    I64Load32S = 42
    I64Load32U = 43
    I32Store = 44
    I64Store = 45
    F32Store = 46
    F64Store = 47
    I32Store8 = 48
    I32Store16 = 49
    I64Store8 = 50
    I64Store16 = 51
    I64Store32 = 52
    MemorySize = 53
    MemoryGrow = 54
    I32Const = 55
    I64Const = 56
    F32Const = 57
    F64Const = 58
    RefNull = 59
    RefIsNull = 60
    RefFunc = 61
    I32Eqz = 62
    I32Eq = 63
    I32Ne = 64
    I32LtS = 65
    I32LtU = 66
    I32GtS = 67
    I32GtU = 68
    I32LeS = 69
    I32LeU = 70
    I32GeS = 71
    I32GeU = 72
    I64Eqz = 73
    I64Eq = 74
    I64Ne = 75
    I64LtS = 76
    I64LtU = 77
    I64GtS = 78
    I64GtU = 79
    I64LeS = 80
    I64LeU = 81
    I64GeS = 82
    I64GeU = 83
    F32Eq = 84
    F32Ne = 85
    F32Lt = 86
    F32Gt = 87
    F32Le = 88
    F32Ge = 89
    F64Eq = 90
    F64Ne = 91
    F64Lt = 92
    F64Gt = 93
    F64Le = 94
    F64Ge = 95
    I32Clz = 96
    I32Ctz = 97
    I32Popcnt = 98
    I32Add = 99
    I32Sub = 100
    I32Mul = 101
    I32DivS = 102
    I32DivU = 103
    I32RemS = 104
    I32RemU = 105
    I32And = 106
    I32Or = 107
    I32Xor = 108
    I32Shl = 109
    I32ShrS = 110
    I32ShrU = 111
    I32Rotl = 112
    I32Rotr = 113
    I64Clz = 114
    I64Ctz = 115
    I64Popcnt = 116
    I64Add = 117
    I64Sub = 118
    I64Mul = 119
    I64DivS = 120
    I64DivU = 121
    I64RemS = 122
    I64RemU = 123
    I64And = 124
    I64Or = 125
    I64Xor = 126
    I64Shl = 127
    I64ShrS = 128
    I64ShrU = 129
    I64Rotl = 130
    I64Rotr = 131
    F32Abs = 132
    F32Neg = 133
    F32Ceil = 134
    F32Floor = 135
    F32Trunc = 136
    F32Nearest = 137
    F32Sqrt = 138
    F32Add = 139
    F32Sub = 140
    F32Mul = 141
    F32Div = 142
    F32Min = 143
    F32Max = 144
    F32Copysign = 145
    F64Abs = 146
    F64Neg = 147
    F64Ceil = 148
    F64Floor = 149
    F64Trunc = 150
    F64Nearest = 151
    F64Sqrt = 152
    F64Add = 153
    F64Sub = 154
    F64Mul = 155
    F64Div = 156
    F64Min = 157
    F64Max = 158
    F64Copysign = 159
    I32WrapI64 = 160
    I32TruncF32S = 161
    I32TruncF32U = 162
    I32TruncF64S = 163
    I32TruncF64U = 164
    I64ExtendI32S = 165
    I64ExtendI32U = 166
    I64TruncF32S = 167
    I64TruncF32U = 168
    I64TruncF64S = 169
    I64TruncF64U = 170
    F32ConvertI32S = 171
    F32ConvertI32U = 172
    F32ConvertI64S = 173
    F32ConvertI64U = 174
    F32DemoteF64 = 175
    F64ConvertI32S = 176
    F64ConvertI32U = 177
    F64ConvertI64S = 178
    F64ConvertI64U = 179
    F64PromoteF32 = 180
    I32ReinterpretF32 = 181
    I64ReinterpretF64 = 182
    F32ReinterpretI32 = 183
    F64ReinterpretI64 = 184
    I32Extend8S = 185
    I32Extend16S = 186
    I64Extend8S = 187
    I64Extend16S = 188
    I64Extend32S = 189
    I32TruncSatF32S = 190
    I32TruncSatF32U = 191
    I32TruncSatF64S = 192
    I32TruncSatF64U = 193
    I64TruncSatF32S = 194
    I64TruncSatF32U = 195
    I64TruncSatF64S = 196
    I64TruncSatF64U = 197
    MemoryInit = 198
    DataDrop = 199
    MemoryCopy = 200
    MemoryFill = 201
    TableInit = 202
    ElemDrop = 203
    TableCopy = 204
    TableFill = 205
    TableGet = 206
    TableSet = 207
    TableGrow = 208
    TableSize = 209
    MemoryAtomicNotify = 210
    MemoryAtomicWait32 = 211
    MemoryAtomicWait64 = 212
    AtomicFence = 213
    I32AtomicLoad = 214
    I64AtomicLoad = 215
    I32AtomicLoad8U = 216
    I32AtomicLoad16U = 217
    I64AtomicLoad8U = 218
    I64AtomicLoad16U = 219
    I64AtomicLoad32U = 220
    I32AtomicStore = 221
    I64AtomicStore = 222
    I32AtomicStore8 = 223
    I32AtomicStore16 = 224
    I64AtomicStore8 = 225
    I64AtomicStore16 = 226
    I64AtomicStore32 = 227
    I32AtomicRmwAdd = 228
    I64AtomicRmwAdd = 229
    I32AtomicRmw8AddU = 230
    I32AtomicRmw16AddU = 231
    I64AtomicRmw8AddU = 232
    I64AtomicRmw16AddU = 233
    I64AtomicRmw32AddU = 234
    I32AtomicRmwSub = 235
    I64AtomicRmwSub = 236
    I32AtomicRmw8SubU = 237
    I32AtomicRmw16SubU = 238
    I64AtomicRmw8SubU = 239
    I64AtomicRmw16SubU = 240
    I64AtomicRmw32SubU = 241
    I32AtomicRmwAnd = 242
    I64AtomicRmwAnd = 243
    I32AtomicRmw8AndU = 244
    I32AtomicRmw16AndU = 245
    I64AtomicRmw8AndU = 246
    I64AtomicRmw16AndU = 247
    I64AtomicRmw32AndU = 248
    I32AtomicRmwOr = 249
    I64AtomicRmwOr = 250
    I32AtomicRmw8OrU = 251
    I32AtomicRmw16OrU = 252
    I64AtomicRmw8OrU = 253
    I64AtomicRmw16OrU = 254
    I64AtomicRmw32OrU = 255
    I32AtomicRmwXor = 256
    I64AtomicRmwXor = 257
    I32AtomicRmw8XorU = 258
    I32AtomicRmw16XorU = 259
    I64AtomicRmw8XorU = 260
    I64AtomicRmw16XorU = 261
    I64AtomicRmw32XorU = 262
    I32AtomicRmwXchg = 263
    I64AtomicRmwXchg = 264
    I32AtomicRmw8XchgU = 265
    I32AtomicRmw16XchgU = 266
    I64AtomicRmw8XchgU = 267
    I64AtomicRmw16XchgU = 268
    I64AtomicRmw32XchgU = 269
    I32AtomicRmwCmpxchg = 270
    I64AtomicRmwCmpxchg = 271
    I32AtomicRmw8CmpxchgU = 272
    I32AtomicRmw16CmpxchgU = 273
    I64AtomicRmw8CmpxchgU = 274
    I64AtomicRmw16CmpxchgU = 275
    I64AtomicRmw32CmpxchgU = 276
    V128Load = 277
    V128Store = 278
    V128Const = 279
    I8x16Splat = 280
    I8x16ExtractLaneS = 281
    I8x16ExtractLaneU = 282
    I8x16ReplaceLane = 283
    I16x8Splat = 284
    I16x8ExtractLaneS = 285
    I16x8ExtractLaneU = 286
    I16x8ReplaceLane = 287
    I32x4Splat = 288
    I32x4ExtractLane = 289
    I32x4ReplaceLane = 290
    I64x2Splat = 291
    I64x2ExtractLane = 292
    I64x2ReplaceLane = 293
    F32x4Splat = 294
    F32x4ExtractLane = 295
    F32x4ReplaceLane = 296
    F64x2Splat = 297
    F64x2ExtractLane = 298
    F64x2ReplaceLane = 299
    I8x16Eq = 300
    I8x16Ne = 301
    I8x16LtS = 302
    I8x16LtU = 303
    I8x16GtS = 304
    I8x16GtU = 305
    I8x16LeS = 306
    I8x16LeU = 307
    I8x16GeS = 308
    I8x16GeU = 309
    I16x8Eq = 310
    I16x8Ne = 311
    I16x8LtS = 312
    I16x8LtU = 313
    I16x8GtS = 314
    I16x8GtU = 315
    I16x8LeS = 316
    I16x8LeU = 317
    I16x8GeS = 318
    I16x8GeU = 319
    I32x4Eq = 320
    I32x4Ne = 321
    I32x4LtS = 322
    I32x4LtU = 323
    I32x4GtS = 324
    I32x4GtU = 325
    I32x4LeS = 326
    I32x4LeU = 327
    I32x4GeS = 328
    I32x4GeU = 329
    I64x2Eq = 330
    I64x2Ne = 331
    I64x2LtS = 332
    I64x2GtS = 333
    I64x2LeS = 334
    I64x2GeS = 335
    F32x4Eq = 336
    F32x4Ne = 337
    F32x4Lt = 338
    F32x4Gt = 339
    F32x4Le = 340
    F32x4Ge = 341
    F64x2Eq = 342
    F64x2Ne = 343
    F64x2Lt = 344
    F64x2Gt = 345
    F64x2Le = 346
    F64x2Ge = 347
    V128Not = 348
    V128And = 349
    V128AndNot = 350
    V128Or = 351
    V128Xor = 352
    V128Bitselect = 353
    V128AnyTrue = 354
    I8x16Abs = 355
    I8x16Neg = 356
    I8x16AllTrue = 357
    I8x16Bitmask = 358
    I8x16Shl = 359
    I8x16ShrS = 360
    I8x16ShrU = 361
    I8x16Add = 362
    I8x16AddSatS = 363
    I8x16AddSatU = 364
    I8x16Sub = 365
    I8x16SubSatS = 366
    I8x16SubSatU = 367
    I8x16MinS = 368
    I8x16MinU = 369
    I8x16MaxS = 370
    I8x16MaxU = 371
    I8x16Popcnt = 372
    I16x8Abs = 373
    I16x8Neg = 374
    I16x8AllTrue = 375
    I16x8Bitmask = 376
    I16x8Shl = 377
    I16x8ShrS = 378
    I16x8ShrU = 379
    I16x8Add = 380
    I16x8AddSatS = 381
    I16x8AddSatU = 382
    I16x8Sub = 383
    I16x8SubSatS = 384
    I16x8SubSatU = 385
    I16x8Mul = 386
    I16x8MinS = 387
    I16x8MinU = 388
    I16x8MaxS = 389
    I16x8MaxU = 390
    I16x8ExtAddPairwiseI8x16S = 391
    I16x8ExtAddPairwiseI8x16U = 392
    I32x4Abs = 393
    I32x4Neg = 394
    I32x4AllTrue = 395
    I32x4Bitmask = 396
    I32x4Shl = 397
    I32x4ShrS = 398
    I32x4ShrU = 399
    I32x4Add = 400
    I32x4Sub = 401
    I32x4Mul = 402
    I32x4MinS = 403
    I32x4MinU = 404
    I32x4MaxS = 405
    I32x4MaxU = 406
    I32x4DotI16x8S = 407
    I32x4ExtAddPairwiseI16x8S = 408
    I32x4ExtAddPairwiseI16x8U = 409
    I64x2Abs = 410
    I64x2Neg = 411
    I64x2AllTrue = 412
    I64x2Bitmask = 413
    I64x2Shl = 414
    I64x2ShrS = 415
    I64x2ShrU = 416
    I64x2Add = 417
    I64x2Sub = 418
    I64x2Mul = 419
    F32x4Ceil = 420
    F32x4Floor = 421
    F32x4Trunc = 422
    F32x4Nearest = 423
    F64x2Ceil = 424
    F64x2Floor = 425
    F64x2Trunc = 426
    F64x2Nearest = 427
    F32x4Abs = 428
    F32x4Neg = 429
    F32x4Sqrt = 430
    F32x4Add = 431
    F32x4Sub = 432
    F32x4Mul = 433
    F32x4Div = 434
    F32x4Min = 435
    F32x4Max = 436
    F32x4PMin = 437
    F32x4PMax = 438
    F64x2Abs = 439
    F64x2Neg = 440
    F64x2Sqrt = 441
    F64x2Add = 442
    F64x2Sub = 443
    F64x2Mul = 444
    F64x2Div = 445
    F64x2Min = 446
    F64x2Max = 447
    F64x2PMin = 448
    F64x2PMax = 449
    I32x4TruncSatF32x4S = 450
    I32x4TruncSatF32x4U = 451
    F32x4ConvertI32x4S = 452
    F32x4ConvertI32x4U = 453
    I8x16Swizzle = 454
    I8x16Shuffle = 455
    V128Load8Splat = 456
    V128Load16Splat = 457
    V128Load32Splat = 458
    V128Load32Zero = 459
    V128Load64Splat = 460
    V128Load64Zero = 461
    I8x16NarrowI16x8S = 462
    I8x16NarrowI16x8U = 463
    I16x8NarrowI32x4S = 464
    I16x8NarrowI32x4U = 465
    I16x8ExtendLowI8x16S = 466
    I16x8ExtendHighI8x16S = 467
    I16x8ExtendLowI8x16U = 468
    I16x8ExtendHighI8x16U = 469
    I32x4ExtendLowI16x8S = 470
    I32x4ExtendHighI16x8S = 471
    I32x4ExtendLowI16x8U = 472
    I32x4ExtendHighI16x8U = 473
    I64x2ExtendLowI32x4S = 474
    I64x2ExtendHighI32x4S = 475
    I64x2ExtendLowI32x4U = 476
    I64x2ExtendHighI32x4U = 477
    I16x8ExtMulLowI8x16S = 478
    I16x8ExtMulHighI8x16S = 479
    I16x8ExtMulLowI8x16U = 480
    I16x8ExtMulHighI8x16U = 481
    I32x4ExtMulLowI16x8S = 482
    I32x4ExtMulHighI16x8S = 483
    I32x4ExtMulLowI16x8U = 484
    I32x4ExtMulHighI16x8U = 485
    I64x2ExtMulLowI32x4S = 486
    I64x2ExtMulHighI32x4S = 487
    I64x2ExtMulLowI32x4U = 488
    I64x2ExtMulHighI32x4U = 489
    V128Load8x8S = 490
    V128Load8x8U = 491
    V128Load16x4S = 492
    V128Load16x4U = 493
    V128Load32x2S = 494
    V128Load32x2U = 495
    V128Load8Lane = 496
    V128Load16Lane = 497
    V128Load32Lane = 498
    V128Load64Lane = 499
    V128Store8Lane = 500
    V128Store16Lane = 501
    V128Store32Lane = 502
    V128Store64Lane = 503
    I8x16RoundingAverageU = 504
    I16x8RoundingAverageU = 505
    I16x8Q15MulrSatS = 506
    F32x4DemoteF64x2Zero = 507
    F64x2PromoteLowF32x4 = 508
    F64x2ConvertLowI32x4S = 509
    F64x2ConvertLowI32x4U = 510
    I32x4TruncSatF64x2SZero = 511
    I32x4TruncSatF64x2UZero = 512
end

mutable struct wasi_config_t end

mutable struct wasi_env_t end

mutable struct wasmer_cpu_features_t end

mutable struct wasmer_features_t end

mutable struct wasmer_metering_t end

mutable struct wasmer_middleware_t end

mutable struct wasmer_named_extern_t end

mutable struct wasmer_target_t end

mutable struct wasmer_triple_t end

mutable struct wasmer_named_extern_vec_t
    size::Csize_t
    data::Ptr{Ptr{wasmer_named_extern_t}}
end

# typedef uint64_t ( * wasmer_metering_cost_function_t ) ( enum wasmer_parser_operator_t wasm_operator )
const wasmer_metering_cost_function_t = Ptr{Cvoid}

function wasi_config_arg(config, arg)
    ccall((:wasi_config_arg, libwasmer), Cvoid, (Ptr{wasi_config_t}, Cstring), config, arg)
end

function wasi_config_capture_stderr(config)
    ccall((:wasi_config_capture_stderr, libwasmer), Cvoid, (Ptr{wasi_config_t},), config)
end

function wasi_config_capture_stdout(config)
    ccall((:wasi_config_capture_stdout, libwasmer), Cvoid, (Ptr{wasi_config_t},), config)
end

function wasi_config_env(config, key, value)
    ccall((:wasi_config_env, libwasmer), Cvoid, (Ptr{wasi_config_t}, Cstring, Cstring), config, key, value)
end

function wasi_config_inherit_stderr(config)
    ccall((:wasi_config_inherit_stderr, libwasmer), Cvoid, (Ptr{wasi_config_t},), config)
end

function wasi_config_inherit_stdin(config)
    ccall((:wasi_config_inherit_stdin, libwasmer), Cvoid, (Ptr{wasi_config_t},), config)
end

function wasi_config_inherit_stdout(config)
    ccall((:wasi_config_inherit_stdout, libwasmer), Cvoid, (Ptr{wasi_config_t},), config)
end

function wasi_config_mapdir(config, alias, dir)
    ccall((:wasi_config_mapdir, libwasmer), Bool, (Ptr{wasi_config_t}, Cstring, Cstring), config, alias, dir)
end

function wasi_config_new(program_name)
    ccall((:wasi_config_new, libwasmer), Ptr{wasi_config_t}, (Cstring,), program_name)
end

function wasi_config_preopen_dir(config, dir)
    ccall((:wasi_config_preopen_dir, libwasmer), Bool, (Ptr{wasi_config_t}, Cstring), config, dir)
end

function wasi_env_delete(_state)
    ccall((:wasi_env_delete, libwasmer), Cvoid, (Ptr{wasi_env_t},), _state)
end

function wasi_env_new(config)
    ccall((:wasi_env_new, libwasmer), Ptr{wasi_env_t}, (Ptr{wasi_config_t},), config)
end

function wasi_env_read_stderr(env, buffer, buffer_len)
    ccall((:wasi_env_read_stderr, libwasmer), intptr_t, (Ptr{wasi_env_t}, Cstring, Csize_t), env, buffer, buffer_len)
end

function wasi_env_read_stdout(env, buffer, buffer_len)
    ccall((:wasi_env_read_stdout, libwasmer), intptr_t, (Ptr{wasi_env_t}, Cstring, Csize_t), env, buffer, buffer_len)
end

function wasi_get_imports(store, _module, wasi_env, imports)
    ccall((:wasi_get_imports, libwasmer), Bool, (Ptr{wasm_store_t}, Ptr{wasm_module_t}, Ptr{wasi_env_t}, Ptr{wasm_extern_vec_t}), store, _module, wasi_env, imports)
end

function wasi_get_start_function(instance)
    ccall((:wasi_get_start_function, libwasmer), Ptr{wasm_func_t}, (Ptr{wasm_instance_t},), instance)
end

function wasi_get_unordered_imports(store, _module, wasi_env, imports)
    ccall((:wasi_get_unordered_imports, libwasmer), Bool, (Ptr{wasm_store_t}, Ptr{wasm_module_t}, Ptr{wasi_env_t}, Ptr{wasmer_named_extern_vec_t}), store, _module, wasi_env, imports)
end

function wasi_get_wasi_version(_module)
    ccall((:wasi_get_wasi_version, libwasmer), wasi_version_t, (Ptr{wasm_module_t},), _module)
end

function wasm_config_canonicalize_nans(config, enable)
    ccall((:wasm_config_canonicalize_nans, libwasmer), Cvoid, (Ptr{wasm_config_t}, Bool), config, enable)
end

function wasm_config_push_middleware(config, middleware)
    ccall((:wasm_config_push_middleware, libwasmer), Cvoid, (Ptr{wasm_config_t}, Ptr{wasmer_middleware_t}), config, middleware)
end

function wasm_config_set_compiler(config, compiler)
    ccall((:wasm_config_set_compiler, libwasmer), Cvoid, (Ptr{wasm_config_t}, wasmer_compiler_t), config, compiler)
end

function wasm_config_set_engine(config, engine)
    ccall((:wasm_config_set_engine, libwasmer), Cvoid, (Ptr{wasm_config_t}, wasmer_engine_t), config, engine)
end

function wasm_config_set_features(config, features)
    ccall((:wasm_config_set_features, libwasmer), Cvoid, (Ptr{wasm_config_t}, Ptr{wasmer_features_t}), config, features)
end

function wasm_config_set_target(config, target)
    ccall((:wasm_config_set_target, libwasmer), Cvoid, (Ptr{wasm_config_t}, Ptr{wasmer_target_t}), config, target)
end

function wasmer_cpu_features_add(cpu_features, feature)
    ccall((:wasmer_cpu_features_add, libwasmer), Bool, (Ptr{wasmer_cpu_features_t}, Ptr{wasm_name_t}), cpu_features, feature)
end

function wasmer_cpu_features_delete(_cpu_features)
    ccall((:wasmer_cpu_features_delete, libwasmer), Cvoid, (Ptr{wasmer_cpu_features_t},), _cpu_features)
end

function wasmer_cpu_features_new()
    ccall((:wasmer_cpu_features_new, libwasmer), Ptr{wasmer_cpu_features_t}, ())
end

function wasmer_features_bulk_memory(features, enable)
    ccall((:wasmer_features_bulk_memory, libwasmer), Bool, (Ptr{wasmer_features_t}, Bool), features, enable)
end

function wasmer_features_delete(_features)
    ccall((:wasmer_features_delete, libwasmer), Cvoid, (Ptr{wasmer_features_t},), _features)
end

function wasmer_features_memory64(features, enable)
    ccall((:wasmer_features_memory64, libwasmer), Bool, (Ptr{wasmer_features_t}, Bool), features, enable)
end

function wasmer_features_module_linking(features, enable)
    ccall((:wasmer_features_module_linking, libwasmer), Bool, (Ptr{wasmer_features_t}, Bool), features, enable)
end

function wasmer_features_multi_memory(features, enable)
    ccall((:wasmer_features_multi_memory, libwasmer), Bool, (Ptr{wasmer_features_t}, Bool), features, enable)
end

function wasmer_features_multi_value(features, enable)
    ccall((:wasmer_features_multi_value, libwasmer), Bool, (Ptr{wasmer_features_t}, Bool), features, enable)
end

function wasmer_features_new()
    ccall((:wasmer_features_new, libwasmer), Ptr{wasmer_features_t}, ())
end

function wasmer_features_reference_types(features, enable)
    ccall((:wasmer_features_reference_types, libwasmer), Bool, (Ptr{wasmer_features_t}, Bool), features, enable)
end

function wasmer_features_simd(features, enable)
    ccall((:wasmer_features_simd, libwasmer), Bool, (Ptr{wasmer_features_t}, Bool), features, enable)
end

function wasmer_features_tail_call(features, enable)
    ccall((:wasmer_features_tail_call, libwasmer), Bool, (Ptr{wasmer_features_t}, Bool), features, enable)
end

function wasmer_features_threads(features, enable)
    ccall((:wasmer_features_threads, libwasmer), Bool, (Ptr{wasmer_features_t}, Bool), features, enable)
end

function wasmer_is_compiler_available(compiler)
    ccall((:wasmer_is_compiler_available, libwasmer), Bool, (wasmer_compiler_t,), compiler)
end

function wasmer_is_engine_available(engine)
    ccall((:wasmer_is_engine_available, libwasmer), Bool, (wasmer_engine_t,), engine)
end

function wasmer_is_headless()
    ccall((:wasmer_is_headless, libwasmer), Bool, ())
end

function wasmer_last_error_length()
    ccall((:wasmer_last_error_length, libwasmer), Cint, ())
end

function wasmer_last_error_message(buffer, length)
    ccall((:wasmer_last_error_message, libwasmer), Cint, (Cstring, Cint), buffer, length)
end

function wasmer_metering_as_middleware(metering)
    ccall((:wasmer_metering_as_middleware, libwasmer), Ptr{wasmer_middleware_t}, (Ptr{wasmer_metering_t},), metering)
end

function wasmer_metering_delete(_metering)
    ccall((:wasmer_metering_delete, libwasmer), Cvoid, (Ptr{wasmer_metering_t},), _metering)
end

function wasmer_metering_get_remaining_points(instance)
    ccall((:wasmer_metering_get_remaining_points, libwasmer), UInt64, (Ptr{wasm_instance_t},), instance)
end

function wasmer_metering_new(initial_limit, cost_function)
    ccall((:wasmer_metering_new, libwasmer), Ptr{wasmer_metering_t}, (UInt64, wasmer_metering_cost_function_t), initial_limit, cost_function)
end

function wasmer_metering_points_are_exhausted(instance)
    ccall((:wasmer_metering_points_are_exhausted, libwasmer), Bool, (Ptr{wasm_instance_t},), instance)
end

function wasmer_metering_set_remaining_points(instance, new_limit)
    ccall((:wasmer_metering_set_remaining_points, libwasmer), Cvoid, (Ptr{wasm_instance_t}, UInt64), instance, new_limit)
end

function wasmer_module_name(_module, out)
    ccall((:wasmer_module_name, libwasmer), Cvoid, (Ptr{wasm_module_t}, Ptr{wasm_name_t}), _module, out)
end

function wasmer_module_set_name(_module, name)
    ccall((:wasmer_module_set_name, libwasmer), Bool, (Ptr{wasm_module_t}, Ptr{wasm_name_t}), _module, name)
end

function wasmer_named_extern_module(named_extern)
    ccall((:wasmer_named_extern_module, libwasmer), Ptr{wasm_name_t}, (Ptr{wasmer_named_extern_t},), named_extern)
end

function wasmer_named_extern_name(named_extern)
    ccall((:wasmer_named_extern_name, libwasmer), Ptr{wasm_name_t}, (Ptr{wasmer_named_extern_t},), named_extern)
end

function wasmer_named_extern_unwrap(named_extern)
    ccall((:wasmer_named_extern_unwrap, libwasmer), Ptr{wasm_extern_t}, (Ptr{wasmer_named_extern_t},), named_extern)
end

function wasmer_named_extern_vec_copy(out_ptr, in_ptr)
    ccall((:wasmer_named_extern_vec_copy, libwasmer), Cvoid, (Ptr{wasmer_named_extern_vec_t}, Ptr{wasmer_named_extern_vec_t}), out_ptr, in_ptr)
end

function wasmer_named_extern_vec_delete(ptr)
    ccall((:wasmer_named_extern_vec_delete, libwasmer), Cvoid, (Ptr{wasmer_named_extern_vec_t},), ptr)
end

function wasmer_named_extern_vec_new(out, length, init)
    ccall((:wasmer_named_extern_vec_new, libwasmer), Cvoid, (Ptr{wasmer_named_extern_vec_t}, Csize_t, Ptr{Ptr{wasmer_named_extern_t}}), out, length, init)
end

function wasmer_named_extern_vec_new_empty(out)
    ccall((:wasmer_named_extern_vec_new_empty, libwasmer), Cvoid, (Ptr{wasmer_named_extern_vec_t},), out)
end

function wasmer_named_extern_vec_new_uninitialized(out, length)
    ccall((:wasmer_named_extern_vec_new_uninitialized, libwasmer), Cvoid, (Ptr{wasmer_named_extern_vec_t}, Csize_t), out, length)
end

function wasmer_target_delete(_target)
    ccall((:wasmer_target_delete, libwasmer), Cvoid, (Ptr{wasmer_target_t},), _target)
end

function wasmer_target_new(triple, cpu_features)
    ccall((:wasmer_target_new, libwasmer), Ptr{wasmer_target_t}, (Ptr{wasmer_triple_t}, Ptr{wasmer_cpu_features_t}), triple, cpu_features)
end

function wasmer_triple_delete(_triple)
    ccall((:wasmer_triple_delete, libwasmer), Cvoid, (Ptr{wasmer_triple_t},), _triple)
end

function wasmer_triple_new(triple)
    ccall((:wasmer_triple_new, libwasmer), Ptr{wasmer_triple_t}, (Ptr{wasm_name_t},), triple)
end

function wasmer_triple_new_from_host()
    ccall((:wasmer_triple_new_from_host, libwasmer), Ptr{wasmer_triple_t}, ())
end

function wasmer_version()
    ccall((:wasmer_version, libwasmer), Cstring, ())
end

function wasmer_version_major()
    ccall((:wasmer_version_major, libwasmer), UInt8, ())
end

function wasmer_version_minor()
    ccall((:wasmer_version_minor, libwasmer), UInt8, ())
end

function wasmer_version_patch()
    ccall((:wasmer_version_patch, libwasmer), UInt8, ())
end

function wasmer_version_pre()
    ccall((:wasmer_version_pre, libwasmer), Cstring, ())
end

function wat2wasm(wat, out)
    ccall((:wat2wasm, libwasmer), Cvoid, (Ptr{wasm_byte_vec_t}, Ptr{wasm_byte_vec_t}), wat, out)
end

const WASMER_VERSION = "2.1.1"

const WASMER_VERSION_MAJOR = 2

const WASMER_VERSION_MINOR = 1

const WASMER_VERSION_PATCH = 1

const WASMER_VERSION_PRE = ""

const wasm_name = wasm_byte_vec_t

const wasm_name_new = wasm_byte_vec_new

const wasm_name_new_empty = wasm_byte_vec_new_empty

const wasm_name_new_new_uninitialized = wasm_byte_vec_new_uninitialized

const wasm_name_copy = wasm_byte_vec_copy

const wasm_name_delete = wasm_byte_vec_delete

const WASM_EMPTY_VEC = nothing

# Skipping MacroDefinition: WASM_INIT_VAL { . kind = WASM_ANYREF , . of = { . ref = NULL } }



# exports
const PREFIXES = ["libwasm", "wasm_", "WASM_", "wasi_"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

end # module
