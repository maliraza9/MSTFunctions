using PowerModels, LightGraphs, InfrastructureModels, Ipopt, JuMP, SimpleWeightedGraphs, SimpleTraits, DataStructures, SimpleGraphs, GraphPlot, TikzPictures, Compose, GraphRecipes, Distances#, LazySets
using TikzGraphs, XLSX, DataFrames
clearconsole()
pos = [0 0; 1 -1; 1 1; 2 1; 2 -1]
distmx=pairwise(Euclidean(), pos, dims = 1)
g = SimpleWeightedGraph(5)  # or use `SimpleWeightedDiGraph` for directed graphs
add_edge!(g, 1, 2, 1.41421)
add_edge!(g, 1, 3, 1.41421)
add_edge!(g, 1, 4, 2.23607)
add_edge!(g, 1, 5, 2.23607)
add_edge!(g, 2, 3, 2)
add_edge!(g, 2, 4, 2.23607)
add_edge!(g, 2, 5, 1)
add_edge!(g, 3, 4, 1)
add_edge!(g, 3, 5, 2.23607)
add_edge!(g, 4, 5, 2.0)

unified = unified_algorithm(g, weights(g))
prim = prim_algorithm(g, weights(g))
krusk = kruskal_algorithm(g, weights(g))
clearconsole()


kruk = kruskal_mst_yo(g, weights(g); minimize=true)
include("src/economics/main.jl")

include("ConstraintFunctions.jl")

gplot_solution(LightGraphs.vertices(g),edges(g))
gplot_solution(vertices(g),unified)


c220=AC_cbl_mst(mva,km,get_220kV_cables())
#available sizes:
#95 120 150 185 240 300 400 500 630 800 1000 - same as juan's paper
c66=AC_cbl_mst(30,1,get_66kV_cables())

function gplot_solution(vs,es)
    _g=SimpleWeightedGraph(length(vs))
    for e in es; add_edge!(_g, e); end
    p=gplot(_g, nodelabel=[string(i) for i in vs])
    display(es)
    return p
end

############################### GPS to UTM conversion #########################
using Geodesy
df = DataFrame(XLSX.readtable("/Users/shardy/Documents/GitHub/MSTFunctions/data/ronne_bank_gps.xlsx", "north")...)
zone_utm=32; north_south=true;#Denmark
utm_desired = UTMfromLLA(zone_utm, north_south, wgs84)#sets UTM zone
utm = utm_desired(LLA(pcc.node.gps.lat,pcc.node.gps.lng))#coverts to cartesian
utm = utm_desired(LLA(df[!:long(m)]pcc.node.gps.lat,pcc.node.gps.lng))#coverts to cartesian

sth = DataFrame(XLSX.readtable("/Users/shardy/Documents/GitHub/MSTFunctions/data/ronne_bank_gps.xlsx", "south")...)
plotly()
p=plot()
plot!(p,sth[!,:_x], sth[!,:_y],color = :red,seriestype=:scatter,markersize=4, markershape = :cross,label="",xaxis = ("km", font(20, "Courier")),yaxis = ("km", font(20, "Courier")))
gui()
