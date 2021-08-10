using PowerModels, LightGraphs, InfrastructureModels, Ipopt, JuMP, SimpleWeightedGraphs, SimpleTraits, DataStructures, SimpleGraphs, GraphPlot, TikzPictures, LazySets, GeometryTypes


function prim_mst_yo end
@traitfn function prim_mst_yo(g::AG::(!IsDirected),
    distmx::AbstractMatrix{T}=weights(g)) where {T <: Real, U, AG <: AbstractGraph{U}}

    nvg = nv(g)
    global distCount = 0
    global us = zeros(1)
    global vs = zeros(1)
    global pq = PriorityQueue{U, T}()
    global finished = zeros(Bool, nvg)
    global wt = fill(typemax(T), nvg) #Faster access time
    global parents = zeros(U, nv(g))

    global capNode = zeros(U, nv(g))

    global t = zeros(12)

    global forCount = 0
    global denCount = 0

    global connList = zeros(2)

    global lineVU = zeros()
    global xInter = []
    global yInter = []
    #pq[1] = typemin(T)
    #pq[1] = typemin(T)
    #wt[1] = typemin(T)
    global count = 1
    wt[1] = distmx[1, 1]
    pq[1] = wt[1]
    global cc = 1
    global cdd = 1

    global candList = zeros(12,2)

    global denList = zeros(12)
    global pqi = zeros(10)
    tt = 1
    while !isempty(pq)
        global v = dequeue!(pq)
        pqi[tt] = v
        tt = tt+1
        finished[v] = true
        cc = cc+1
        for u in LightGraphs.neighbors(g, v)
            global candU = u
            global candV = v
            cdd = cdd + 1
            global den = 1

            finished[u] && continue
            if wt[u] > distmx[u, v] && capNode[u] < 4
                count = count+1
                capNode[u] = capNode[u] + 1

                ###########
                #wt[u] = distmx[u, v]
                #pq[u] = wt[u]
                #parents[u] = v
                us = hcat(us,u)
                vs = hcat(vs,v)
                connList = hcat(connList,[u,v]) # collumn major list. Iterate across columns for connection list u-v. e.g. n[:,i] = [u,v] pair
                connList = convert(Array{Int},connList)
                #######
                for i in 2:size(connList,2)

                    forCount = forCount+1

                    posXrowU = pos[collect(connList[1,i])[1],1]
                    posYcolU = pos[collect(connList[1,i])[1],2]

                    global x1 = posXrowU
                    global y1 = posYcolU

                    posXrowV = pos[collect(connList[2,i])[1],1]
                    posYcolV = pos[collect(connList[2,i])[1],2]

                    global x2 = posXrowV
                    global y2 = posYcolV

                    #candXrowU = pos[collect(candU),1][1]
                    #candYcolU = pos[collect(candU),2][1]

                    candXrowU = pos[collect(connList[1,end]),1][1]
                    candYcolU = pos[collect(connList[1,end]),2][1]

                    global x3 = candXrowU
                    global y3 = candYcolU

                    candXrowV = pos[collect(connList[1,end]),1][1]
                    candYcolV = pos[collect(connList[2,end]),2][1]

                    global x4 = candXrowV
                    global y4 = candYcolV

                    global den = ((x1-x2)*(y3-y4)-(y1-y2)*(x3-x4))

                    #candList[i] = hcat(candList,[u, v])
                    #denList[i] = den

                    #candList[i] = [candU, candV]

                    if den!=0
                        xInter= ((x1*y2-y1*x2)*(x3-x4)-(x1-x2)*(x3*y4-y3*x4))/den
                        yInter= ((x1*y2-y1*x2)*(y3-y4)-(y1-y2)*(x3*y4-y3*x4))/den

                        ######
                        global prevU2Intersect = Euclidean()([posXrowU,posYcolU],[xInter, yInter])
                        global prevV2Intersect = Euclidean()([posXrowV,posYcolV],[xInter, yInter])
                        global distUVprev      = Euclidean()([posXrowU,posYcolU],[posXrowV,posYcolV])

                        global candU2Intersect = Euclidean()([candXrowU,candYcolU],[xInter, yInter])
                        global candV2Intersect = Euclidean()([candXrowV,candYcolV],[xInter, yInter])
                        global distUVcand      = Euclidean()([candXrowU,candYcolU],[candXrowV,candYcolV])

                        denCount = denCount + 1

                        if (distUVprev != prevU2Intersect + prevV2Intersect) && (distUVcand != candU2Intersect + candV2Intersect)
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
