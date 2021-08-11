using PowerModels, LightGraphs, InfrastructureModels, Ipopt, JuMP, SimpleWeightedGraphs, SimpleTraits, DataStructures, SimpleGraphs, GraphPlot, TikzPictures, LazySets, GeometryTypes

T = Float64
U = Int32

function prim_mst_yo end
@traitfn function prim_mst_yo(g::AG::(!IsDirected),
    distmx::AbstractMatrix{T}=weights(g)) where {T <: Real, U, AG <: AbstractGraph{U}}
    u = []
    nvg = nv(g)
    distCount = 0
    us = zeros(1)
    vs = zeros(1)
    pq = PriorityQueue{U, T}()
    finished = zeros(Bool, nvg)
    wt = fill(typemax(T), nvg) #Faster access time
    parents = zeros(U, nv(g))

    capNode = zeros(U, nv(g))

    t = zeros(12)

    forCount = 0
    denCount = 0

    connList = zeros(2,2)

    lineVU = zeros()
    xInter = []
    yInter = []
    #pq[1] = typemin(T)
    #pq[1] = typemin(T)
    #wt[1] = typemin(T)
     count = 1
    wt[1] = distmx[1, 1]
    pq[1] = wt[1]
     cc = 1
     cdd = 1

    candList = zeros(12,2)

    denList = zeros(12)
    pqi = zeros(10)
    tt = 1
    while !isempty(pq)
        v = dequeue!(pq)
        pqi[tt] = v
        tt = tt+1
        finished[v] = true
        cc = cc+1
        for u in LightGraphs.neighbors(g, v)
            #u = LightGraphs.neighbors(g, v)[1]
            candU = u
            candV = v
            cdd = cdd + 1
            #den = 1

            finished[u] && continue
            if wt[u] > distmx[u, v] && capNode[u] < 4

                for i in 2:size(connList,2)

                    forCount = forCount+1


                        #if posXrowU>xInter>posXrowV

                        if cableCrossingConstraint(connList,2, pos)
                            wt[u] = distmx[u, v]
                            pq[u] = wt[u]
                            parents[u] = v
                            connList = hcat(connList,[u,v]) # collumn major list. Iterate across columns for connection list u-v. e.g. n[:,i] = [u,v] pair
                            distCount = distCount + 1
                            #global candU = u
                            #global candV = v

                        end
                    end
                end
            end
        end
    end

    return [Edge{U}(parents[v], v) for v in LightGraphs.vertices(g) if parents[v] != 0]

end



function cableCrossingConstraint(connList,i, pos)
    connList = convert(Array{Int},connList)

    posXrowU = pos[collect(connList[1,i])[1],1]
    posYcolU = pos[collect(connList[1,i])[1],2]

    x1 = posXrowU
    y1 = posYcolU

    posXrowV = pos[collect(connList[2,i])[1],1]
    posYcolV = pos[collect(connList[2,i])[1],2]

    x2 = posXrowV
    y2 = posYcolV

    #candXrowU = pos[collect(candU),1][1]
    #candYcolU = pos[collect(candU),2][1]

    candXrowU = pos[collect(connList[1,end]),1][1]
    candYcolU = pos[collect(connList[1,end]),2][1]

    x3 = candXrowU
    y3 = candYcolU

    candXrowV = pos[collect(connList[1,end]),1][1]
    candYcolV = pos[collect(connList[2,end]),2][1]

    x4 = candXrowV
    y4 = candYcolV

    den = ((x1-x2)*(y3-y4)-(y1-y2)*(x3-x4))

    #candList[i] = hcat(candList,[u, v])
    #denList[i] = den

    #candList[i] = [candU, candV]

    if den!=0
        xInter= ((x1*y2-y1*x2)*(x3-x4)-(x1-x2)*(x3*y4-y3*x4))/den
        yInter= ((x1*y2-y1*x2)*(y3-y4)-(y1-y2)*(x3*y4-y3*x4))/den

        ######
        prevU2Intersect = Euclidean()([posXrowU,posYcolU],[xInter, yInter])
        prevV2Intersect = Euclidean()([posXrowV,posYcolV],[xInter, yInter])
        distUVprev      = Euclidean()([posXrowU,posYcolU],[posXrowV,posYcolV])

        candU2Intersect = Euclidean()([candXrowU,candYcolU],[xInter, yInter])
        candV2Intersect = Euclidean()([candXrowV,candYcolV],[xInter, yInter])
        distUVcand      = Euclidean()([candXrowU,candYcolU],[candXrowV,candYcolV])

        denCount = denCount + 1
    end
    if (distUVprev != prevU2Intersect + prevV2Intersect) && (distUVcand != candU2Intersect + candV2Intersect)
        return true
    else return false
    end
end
