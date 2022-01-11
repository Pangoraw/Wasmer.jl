import Downloads
using GitHub
using Pkg.Artifacts
using Base.BinaryPlatforms
using Tar
using SHA

const gh_auth = GitHub.AnonymousAuth()

version(release::Release) = try
    VersionNumber(release.tag_name)
catch
    v"0.0.0"
end

latest_release(repo; auth) = reduce(releases(repo; auth)[1]) do releaseA, releaseB
    version(releaseA) > version(releaseB) ? releaseA : releaseB
end

function make_artifacts(dir)
    release = latest_release("wasmerio/wasmer"; auth=gh_auth)
    release_version = VersionNumber(release.tag_name)

    platforms = Dict([
        "wasmer-linux-amd64.tar.gz" => Platform("x86_64", "linux"; libc="glibc"),
        "wasmer-linux-musl-amd64.tar.gz" => Platform("x86_64", "linux"; libc="musl"),
        "wasmer-darwin-amd64.tar.gz" => Platform("x86_64", "macos"),
        "wasmer-darwin-arm64.tar.gz" => Platform("aarch64", "macos"),
   ])

    assets = filter(asset -> haskey(platforms, asset["name"]), release.assets)
    artifacts_toml = joinpath(@__DIR__, "Artifacts.toml")

    for asset in assets
        platform = platforms[asset["name"]]

        @info "Downloading $(asset["browser_download_url"]) for $platform"
        archive_location = joinpath(dir, asset["name"])
        download_url = asset["browser_download_url"]
        Downloads.download(download_url, archive_location;
            progress=(t,n) -> print("$(floor(100*n/t))%\r"))
        println()

        artifact_hash = create_artifact() do artifact_dir
            run(`tar -xvf $archive_location -C $artifact_dir`)
        end

        download_hash = open(archive_location, "r") do f
            bytes2hex(sha256(f))
        end
        bind_artifact!(artifacts_toml, "libwasmer", artifact_hash; platform, force=true, download_info=[
            (download_url, download_hash)
        ])
        @info "done $platform"
    end
end

main() = mktempdir(make_artifacts)
