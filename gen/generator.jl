using Clang.Generators
using Clang.LibClang.Clang_jll

cd(@__DIR__)

# Location of the extracted wasmer.tar.gz
wasmer_location = joinpath(get(ENV, "WASMER_LOCATION", "../wasmer"), "lib/c-api/")

options = load_options(joinpath(@__DIR__, "generator.toml"))

# add compiler flags
args = get_default_args()
push!(args, "-I" * wasmer_location)

headers = [
    joinpath(wasmer_location, "../../target/release/build/wasmer-c-api-56a33427fae3bc8b/out/wasmer.h"),
]

# create context
ctx = create_context(headers, args, options)

# build without printing so we can do custom rewriting
build!(ctx, BUILDSTAGE_NO_PRINTING)

# custom rewriter
function rewrite!(e::Expr)
    # if Meta.isexpr(e, :function)
    #     pushfirst!(e.args[2].args, Expr(:macrocall, Symbol("@show"), LineNumberNode(1), :libwasmtime))
    #     return e
    # end

    # if Meta.isexpr(e, :struct, 3) && e.args[2] == :wasmtime_extern
    #     e.args = [
    #         e.args[1],
    #         e.args[2],
    #         [:($(Symbol("_pad", i))::$(t)) for (i, t) in enumerate((UInt8, UInt16, UInt32))]...,
    #         e.args[end],
    #         # :(wasmtime_extern(kind, of) = new(kind, 0, 0, 0, of)),
    #     ]
    #     return e
    # end

    Meta.isexpr(e, :const) || return e

    eq = e.args[1]
    if eq.head === :(=) && eq.args[1] === :WASM_EMPTY_VEC
        e.args[1].args[2] = nothing
    elseif eq.head === :(=) && eq.args[1] === :wasm_name && eq.args[2] === :wasm_byte_vec
        e.args[1].args[2] = :wasm_byte_vec_t
    elseif eq.head === :(=) && eq.args[1] === :wasm_byte_t
        e.args[1].args[2] = :UInt8
    end

    return e
end

function rewrite!(dag::ExprDAG)
    for node in get_nodes(dag)
        for expr in get_exprs(node)
            rewrite!(expr)
        end
    end
end

rewrite!(ctx.dag)

# print
build!(ctx, BUILDSTAGE_PRINTING_ONLY)