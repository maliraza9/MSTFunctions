T = Float64
e = edge_list[sortperm(Weights; rev=!minimize)][1]



function kruskal_mst_yo end
@traitfn function kruskal_mst_yo(g::AG::(!IsDirected),
    distmx::AbstractMatrix{T}=weights(g); minimize=true) where {T <: Real, U, AG <: AbstractGraph{U}}
    global forCount = 0
    global connected_vs = IntDisjointSets(nv(g))
    global visited = zeros(2)
    global mst = Vector{edgetype(g)}()
    sizehint!(mst, nv(g) - 1)

    Weights = Vector{T}()
    sizehint!(Weights, ne(g))
    global edge_list = collect(edges(g))
    for e in edge_list
        push!(Weights, distmx[src(e), dst(e)])
    end

    for e in edge_list[sortperm(Weights; rev=!minimize)]
        if !in_same_set(connected_vs, src(e), dst(e))

            global srce = src(e)
            global dste = dst(e)
            visited = hcat(visited, [srce, dste])
            visited = convert(Array{Int},visited)

            for i in 2:size(visited,2)

                forCount = forCount+1

                posXrowU = pos[collect(visited[1,i])[1],1]
                posYcolU = pos[collect(visited[1,i])[1],2]

                global x1 = posXrowU
                global y1 = posYcolU

                posXrowV = pos[collect(visited[2,i])[1],1]
                posYcolV = pos[collect(visited[2,i])[1],2]

                global x2 = posXrowV
                global y2 = posYcolV


                candXrowU = pos[srce,1][1]
                candYcolU = pos[srce,2][1]

                global x3 = candXrowU
                global y3 = candYcolU

                candXrowV = pos[dste,1][1]
                candYcolV = pos[dste,2][1]

                global x4 = candXrowV
                global y4 = candYcolV

                global den = ((x1-x2)*(y3-y4)-(y1-y2)*(x3-x4))

                if den!=0
                    xInter= ((x1*y2-y1*x2)*(x3-x4)-(x1-x2)*(x3*y4-y3*x4))/den
                    yInter= ((x1*y2-y1*x2)*(y3-y4)-(y1-y2)*(x3*y4-y3*x4))/den

                    global prevU2Intersect = Euclidean()([posXrowU,posYcolU],[xInter, yInter])
                    global prevV2Intersect = Euclidean()([posXrowV,posYcolV],[xInter, yInter])
                    global distUVprev      = Euclidean()([posXrowU,posYcolU],[posXrowV,posYcolV])

                    global candU2Intersect = Euclidean()([candXrowU,candYcolU],[xInter, yInter])
                    global candV2Intersect = Euclidean()([candXrowV,candYcolV],[xInter, yInter])
                    global distUVcand      = Euclidean()([candXrowU,candYcolU],[candXrowV,candYcolV])

                    if (distUVprev != prevU2Intersect + prevV2Intersect) && (distUVcand != candU2Intersect + candV2Intersect)
                        visited = hcat(visited, [src(e), dst(e)])

                        union!(connected_vs, src(e), dst(e))
                        push!(mst, e)
                        (length(mst) >= nv(g) - 1) && break

                    end
                end
            end
        end
    end

    return mst
end
