using PowerModels, LightGraphs, InfrastructureModels, Ipopt, JuMP, SimpleWeightedGraphs, SimpleTraits, DataStructures, SimpleGraphs, GraphPlot, TikzPictures

function prim_mst_yo end
@traitfn function prim_mst_yo(g::AG::(!IsDirected),
    distmx::AbstractMatrix{T}=weights(g)) where {T <: Real, U, AG <: AbstractGraph{U}}

    nvg = nv(g)

    pq = PriorityQueue{U, T}()
    finished = zeros(Bool, nvg)
    wt = fill(typemax(T), nvg) #Faster access time
    parents = zeros(U, nv(g))
    capNode = zeros(U, nv(g))

    #pq[1] = typemin(T)
    #pq[1] = typemin(T)
    #wt[1] = typemin(T)

    wt[1] = distmx[1, 1]
    pq[1] = wt[1]

    while !isempty(pq)
        v = dequeue!(pq)
        finished[v] = true

        for u in LightGraphs.neighbors(g, v)
            finished[u] && continue

            if wt[u] > distmx[u, v] && capNode[u] < 4 && u =! 1

                capNode[u] = capNode[u] + 1
                wt[u] = distmx[u, v]
                pq[u] = wt[u]
                parents[u] = v
                #println("u = ", u)
                #println("parents", parents[u])

            end
        end
    end

    return [u, Edge{U}(parents[v], v) for v in vertices(g) if parents[v] != 0]

end
