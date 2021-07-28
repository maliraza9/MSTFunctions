clearconsole()
using PowerModels, LightGraphs, InfrastructureModels, Ipopt, JuMP, SimpleWeightedGraphs, SimpleTraits, DataStructures, SimpleGraphs, GraphPlot
using XLSX, DataFrames, Plots
include("./src/economics/main.jl")
#source=[1,1,2,2,4,5,6];destination=[2,3,3,2,4,6,5];w8=[1.0,2.0,3.0,2,1,6,3]
#g = SimpleWeightedGraph(source, destination, w8);
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

#prim_mst_yo(g, distmx)
#println(collect(edges(g)))
#println(SimpleWeightedGraph(g))
kruk = kruskal_mst_yo(g, weights(g); minimize=true)

#old = collect(edges(kruk))
#println(old)
#println("===========================")

prim = prim_mst_yo(g, weights(g))

gplot_solution(vertices(g),edges(g))
gplot_solution(vertices(g),kruk)
#println(prim)
#println(kruk)
#New = collect(edges(g))

#gplot(kruk)
"""
#println(SimpleGraph(g.weights))
dist = weights(g);
println("#############################")

kruskal_mst_yo(g, dist; minimize=true)
println(collect(edges(g)))

prim_mst_yo(g, weights(g))
println("=====================================")
"""
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
nrth = DataFrame(XLSX.readtable("/Users/shardy/Documents/GitHub/MSTFunctions/data/ronne_bank_gps.xlsx", "north")...)
plotly()
p=plot()
plot!(p,nrth[!,:_x], nrth[!,:_y],color = :red,seriestype=:scatter,markersize=4, markershape = :cross,label="",xaxis = ("km", font(20, "Courier")),yaxis = ("km", font(20, "Courier")))
gui()

sth = DataFrame(XLSX.readtable("/Users/shardy/Documents/GitHub/MSTFunctions/data/ronne_bank_gps.xlsx", "south")...)
plotly()
p=plot()
plot!(p,sth[!,:_x], sth[!,:_y],color = :red,seriestype=:scatter,markersize=4, markershape = :cross,label="",xaxis = ("km", font(20, "Courier")),yaxis = ("km", font(20, "Courier")))
gui()
