using PowerModels, LightGraphs, InfrastructureModels, Ipopt, JuMP, SimpleWeightedGraphs, SimpleTraits, DataStructures, SimpleGraphs, GraphPlot, TikzPictures, LazySets, GeometryTypes

function kruskal_algorithm end
@traitfn function kruskal_algorithm(g::AG::(!IsDirected),
    distmx::AbstractMatrix{T}=weights(g)) where {T <: Real, U, AG <: AbstractGraph{U}}

    N = nv(g)
    dmx = distmx

    for d in 1:size(dmx[1:end,1])[1]
        dmx[d,d] = Inf
    end
    v_oss = 1 #oss
    vH_oss = argmin(dmx[1:end,v_oss])

    edg_oss = [v_oss, argmin(dmx[1:end,v_oss])]
    Tree = edg_oss
    X = edg_oss

    Y = zeros(Int, N)
    for nn in 1:N
        Y[nn] = nn
    end

    allEdgeWeights = zeros(N*N)
    allEdgesUnsorted = zeros(size(allEdgeWeights)[1],3)

    itr = 0

    for rows in 1:size(dmx[1:end,1])[1]
        for cols in 1:size(dmx[1:end,1])[1]
            allEdgeWeights[itr+1] = dmx[rows, cols]
            allEdgesUnsorted[itr+1,:] = [rows, cols, dmx[rows, cols]]
            itr = itr+1
        end
    end


    itr = 0

    allEdgesUnsorted = allEdgesUnsorted[sortperm(allEdgesUnsorted[:, 3]), :]

    for itr in 1:size(allEdgesUnsorted[1:end,1])[1]
        if allEdgesUnsorted[itr,1]==edg_oss[1] && allEdgesUnsorted[itr,2] == edg_oss[2] || allEdgesUnsorted[itr,1]==edg_oss[2] && allEdgesUnsorted[itr,2] == edg_oss[1]
            allEdgesUnsorted[itr,3] = Inf
        end
    end

    remainingCandidates = allEdgesUnsorted[sortperm(allEdgesUnsorted[:, 3]), :]

    Y = deleteat!(Y,X)

    countWhile = 0

    while !isempty(Y)
        countWhile = countWhile+1
        display(countWhile)

        nodeSelect = argmin(remainingCandidates[:,3])
        nodeU = remainingCandidates[nodeSelect,1]
        nodeV = remainingCandidates[nodeSelect,2]
        nodeU = convert(Int,nodeU)
        nodeV = convert(Int,nodeV)

        if loopCreation(X, nodeU, nodeV) == true
            for itr in 1:size(remainingCandidates[1:end,1])[1]
                if remainingCandidates[itr,1]==nodeU && remainingCandidates[itr,2] == nodeV || remainingCandidates[itr,1]==nodeV && remainingCandidates[itr,2] == nodeU
                    remainingCandidates[itr,3] = Inf
                    count = count+1
                end
            end
        else
            Tree = hcat(Tree,[nodeU, nodeV])
            Tree = convert(Array{Int},Tree)

            X = vcat(X, nodeV)
            X = convert(Array{Int},X)

            allNodes = zeros(Int, N)
            for aN in 1:N
                allNodes[aN] = aN
            end
            Y = deleteat!(allNodes,sort(X[1:end]))


            for itr in 1:size(remainingCandidates[1:end,1])[1]
                if remainingCandidates[itr,1]==nodeU && remainingCandidates[itr,2] == nodeV || remainingCandidates[itr,1]==nodeV && remainingCandidates[itr,2] == nodeU
                    remainingCandidates[itr,3] = Inf
                end
            end
        end
        remainingCandidates = remainingCandidates[sortperm(remainingCandidates[:, 3]), :]
        display(Tree)
    end
end


function loopCreation(visitedNodeSet, candNodeU, candNodeV)
    if candNodeU in visitedNodeSet && candNodeV in visitedNodeSet
        return true
    else return false
    end
end
