using PowerModels, LightGraphs, InfrastructureModels, Ipopt, JuMP, SimpleWeightedGraphs
file="./MV_collection_circuits/MV_collection_circuits/data/case3.m"
data=parse_file(file)
run_dc_opf(data, Ipopt.Optimizer)


g = SimpleDiGraph(2);
add_edge!(g, 1, 2);

SimpleWeightedEdge
