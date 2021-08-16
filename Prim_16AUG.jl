using PowerModels, LightGraphs, InfrastructureModels, Ipopt, JuMP, SimpleWeightedGraphs, SimpleTraits, DataStructures, SimpleGraphs, GraphPlot, TikzPictures, LazySets, GeometryTypes

function prim_Self end
@traitfn function prim_Self(g::AG::(!IsDirected),
    distmx::AbstractMatrix{T}=weights(g)) where {T <: Real, U, AG <: AbstractGraph{U}}


    N = nv(g)
    #display(N)
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
    #display(vH_oss)
    edg = [v_oss, argmin(dmx[1:end,v_oss])]
    #println(vH_oss)
    Tree = edg
    X = edg

    Y = deleteat!(Y,X)
    #display(Y)


    minSet = zeros(1,3)
    minKey = 0
    minVal = 0

    #println(Y[3])

    #display(X)

    #display(T)

    #while size(Tree)<N-1
    #for 1:5
    display(dmx)
    itr = 0

        for xx in X[1:end]
            display(dmx)
            itr = itr+1
            minKey = argmin(dmx[:,xx])
            minVal = minimum(dmx[:,xx])
            #display(minKey)
            #display(minVal)
            #display(xx)
            minSet = vcat(minSet, [xx, minKey, minVal]')
            display(minKey)
            display(minSet)
            display("xxxxx")
        end



    end
