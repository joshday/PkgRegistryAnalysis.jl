# JuliaWorld


```julia
using JuliaWorld

# Get DataFrame populated by data in the General registry
df = JuliaWorld.package_data()

# Get DataFrame of packages that depend on StatsBase
JuliaWorld.dependents(df, "StatsBase")
```