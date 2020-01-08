module JuliaWorld

using DataFrames
using OrderedCollections
using Pkg.TOML: parsefile
using AbstractTrees

#-----------------------------------------------------------------------------# tree stuff
struct Registry
    path::String 
    Registry(path = joinpath(homedir(), ".julia", "registries", "General")) = new(path)
end

struct Letter 
    path::String
end

struct Package 
    path::String 
end

AbstractTrees.children(r::Registry) = Letter.(joinpath.([r.path], string.('A':'Z')))
AbstractTrees.children(l::Letter) = Package.(joinpath.([l.path], readdir(l.path)))
AbstractTrees.children(p::Package) = ()

#-----------------------------------------------------------------------------# package_data
function package_data(registrypath = joinpath(homedir(), ".julia", "registries", "General"))
    DataFrame(retrieve_package_data(row.path) for row in AbstractTrees.Leaves(Registry(registrypath)))  
end

function retrieve_package_data(path::String)
    package = parsefile(joinpath(path, "Package.toml"))
    versions = sort(parsefile(joinpath(path, "Versions.toml")))
    ( 
        name = package["name"],
        repo = package["repo"],
        uuid = package["uuid"],
        latest = last(collect(keys(versions))),
        versions = Dict(k => v["git-tree-sha1"] for (k,v) in pairs(versions)),
        deps = isfile(joinpath(path, "Deps.toml")) ? sort(parsefile(joinpath(path, "Deps.toml"))) : nothing,
        compat = isfile(joinpath(path, "Compat.toml")) ? sort(parsefile(joinpath(path, "Compat.toml"))) : nothing
    )
end

end # module
