module JuliaWorld

using ProgressMeter

function authors_in_general()
    res = String[]
    path = joinpath(homedir(), ".julia", "registries", "General")
    @showprogress for letter in string.('A':'Z')
        for pkg in readdir(joinpath(path, letter))
            s = read(joinpath(path, letter, pkg, "Package.toml"), String)
            m = match(r"repo = \"(.*?).git\"", s)
            if isnothing(m)
                @warn "no match for Package.toml:" s
            else
                out = m.match
                out = replace(out, r"repo = \"https://(.*?).com/" => "")
                out = replace(out, ".jl" => "")
                out = replace(out, ".git" => "")
                push!(res, split(out, '/')[1])
            end
        end
    end
    sort!(unique(res))
end

end # module
