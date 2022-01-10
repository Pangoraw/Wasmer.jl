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
    ENV[libwasmer] : get_libwasmer_location()
