using PowerModels, LightGraphs, InfrastructureModels, Ipopt, JuMP, SimpleWeightedGraphs, SimpleTraits, DataStructures, SimpleGraphs, GraphPlot, TikzPictures, LazySets, GeometryTypes

function prim_algorithm end
@traitfn function prim_algorithm(g::AG::(!IsDirected),
    distmx::AbstractMatrix{T}=weights(g)) where {T <: Real, U, AG <: AbstractGraph{U}}


    N = nv(g)

    Y = zeros(Int, N)
    for nn in 1:N
        Y[nn] = nn
    end

    dmx = distmx

    for d in 1:size(dmx[1:end,1])[1]
        dmx[d,d] = Inf
    end

    v_oss = 1
    vH_oss = argmin(dmx[1:end,v_oss])

    edg = [v_oss, argmin(dmx[1:end,v_oss])]

    Tree = edg
    X = edg

    Y = deleteat!(Y,X)
    minKey = 0
    minVal = 0


    while !isempty(Y)
        minSet = [Inf Inf Inf]
        dmx[X[end-1],X[end]] = Inf
        dmx[X[end],X[end-1]] = Inf

        for xx in X[1:end]
            minKey = argmin(dmx[:,xx])
            minVal = minimum(dmx[:,xx])
            minSet = vcat(minSet, [xx, minKey, minVal]')
        end
        nodeSelect = argmin(minSet[:,3])
        nodeU = minSet[nodeSelect,1]
        nodeV = minSet[nodeSelect,2]
        nodeU = convert(Int,nodeU)
        nodeV = convert(Int,nodeV)

        Tree = hcat(Tree,[nodeU, nodeV])
        Tree = convert(Array{Int},Tree)

        X = vcat(X, nodeV)
        X = convert(Array{Int},X)

        allNodes = zeros(Int, N)
        for aN in 1:N
            allNodes[aN] = aN
        end

        Y = deleteat!(allNodes,sort(X[1:end]))
    end
    return(Tree)
end
