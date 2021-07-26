clearconsole()
using PowerModels, LightGraphs, InfrastructureModels, Ipopt, JuMP, SimpleWeightedGraphs, SimpleTraits, DataStructures, SimpleGraphs, GraphPlot, TikzPictures, Compose, GraphRecipes, Distances

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
