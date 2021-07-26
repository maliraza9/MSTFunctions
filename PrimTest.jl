using PowerModels, LightGraphs, InfrastructureModels, Ipopt, JuMP, SimpleWeightedGraphs, SimpleTraits, DataStructures

"""
    prim_mst(g, distmx=weights(g))
Return a vector of edges representing the minimum spanning tree of a connected, undirected graph `g` with optional
distance matrix `distmx` using [Prim's algorithm](https://en.wikipedia.org/wiki/Prim%27s_algorithm).
Return a vector of edges.
"""
function prim_mst_yo end
@traitfn function prim_mst_yo(g::AG::(!IsDirected),
    distmx::AbstractMatrix{T}=weights(g)) where {T <: Real, U, AG <: AbstractGraph{U}}

    nvg = nv(g)

    pq = PriorityQueue{U, T}()
    finished = zeros(Bool, nvg)
    wt = fill(typemax(T), nvg) #Faster access time
    parents = zeros(U, nv(g))

    pq[1] = typemin(T)
    wt[1] = typemin(T)

    while !isempty(pq)
        v = dequeue!(pq)
        finished[v] = true

        for u in neighbors(g, v)
            finished[u] && continue

            if wt[u] > distmx[u, v]
                if wt[u]>0
                    wt[u]=5

                end
                wt[u] = distmx[u, v]
                pq[u] = wt[u]
                parents[u] = v
            end
        end
    end

    return [Edge{U}(parents[v], v) for v in vertices(g) if parents[v] != 0]
end
