
function kruskal_mst_yo end
@traitfn function kruskal_mst_yo(g::AG::(!IsDirected),
    distmx::AbstractMatrix{T}=weights(g); minimize=true) where {T <: Real, U, AG <: AbstractGraph{U}}

    connected_vs = IntDisjointSets(nv(g))

    mst = Vector{edgetype(g)}()
    sizehint!(mst, nv(g) - 1)

    weights = Vector{T}()
    sizehint!(weights, ne(g))
    edge_list = collect(edges(g))
    for e in edge_list
        push!(weights, distmx[src(e), dst(e)])
    end

    for e in edge_list[sortperm(weights; rev=!minimize)]
        if !in_same_set(connected_vs, src(e), dst(e))
            union!(connected_vs, src(e), dst(e))
            push!(mst, e)
            (length(mst) >= nv(g) - 1) && break
        end
    end

    return mst
end
