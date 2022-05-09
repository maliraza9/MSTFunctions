function capacityConstraint(candNodeU, candNodeV, E_T_capacityConstraint, turnbineConnectionLimit)

    nodeConnectionsU = sum(E_T_capacityConstraint[:,1][1][candNodeU,:])
    nodeConnectionsV = sum(connectedNodeMTXV[:,candNodeV])

    if nodeConnectionsU>turnbineConnectionLimit || nodeconnectionsV>turnbineConnectionLimit
        return true
    else return false
    end
end



function node2coordinate(positionMtx, node)
    x = positionMtx[node,1][1]
    y = positionMtx[node,2][1]
    return (x,y)
end


function cableCrossingConstraint(E_T_cableCrossingConstraint,candNodeU, candNodeV, positionMtx, visitedNodeSet)

    connectedEdgeSet_cableCrossingConstraint = []
    for i in 1:size(E_T_cableCrossingConstraint[:,1])[1]
        visitedSetU_cableCrossingConstraint = push!(E_T_cableCrossingConstraint[:,1][i][1])
        visitedSetV_cableCrossingConstraint = push!(E_T_cableCrossingConstraint[:,1][i][2])
    end

    coordinates = node2coordinate(positionMtx, candNodeU)
    x1 = coordinates[1]
    y1 = coordinates[2]

    coordinates = node2coordinate(positionMtx, candNodeV)
    x2 = coordinates[1]
    y2 = coordinates[2]

    for t in size(connectedEdgeSet[1:end,1])[1]
        coordinates = node2coordinate(positionMtx, visitedSetU_cableCrossingConstraint[t])
        x3 = coordinates[1]
        y3 = coordinates[2]

        coordinates = node2coordinate(positionMtx, visitedSetV_cableCrossingConstraint[t])
        x4 = coordinates[1]
        y4 = coordinates[2]


        den = ((x1-x2)*(y3-y4)-(y1-y2)*(x3-x4))
        if den!=0
            xInter= ((x1*y2-y1*x2)*(x3-x4)-(x1-x2)*(x3*y4-y3*x4))/den
            yInter= ((x1*y2-y1*x2)*(y3-y4)-(y1-y2)*(x3*y4-y3*x4))/den

            if minimum([x1,x2])<xInter<maximum([x1,x2]) && minimum([y1,y2])<yInter<maximum([y1,y2]) && minimum([x3,x4])<xInter<maximum([x3,x4]) && minimum([y3,y4])<yInter<maximum([y3,y4]) == true
                return true
            else
            end
        end
        return false
    end
end


function loopCreation(E_T_loopCreation, candNodeU, candNodeV)
    visitedSet_loopCreation = []
    for i in 1:size(E_T_loopCreation[:,1])[1]
        visitedSetU_loopCreation = push!(E_T_loopCreation[:,1][i][1])
        visitedSetV_loopCreation = push!(E_T_loopCreation[:,1][i][2])
    end
    if candNodeU in visitedSetU_loopCreation && candNodeV in visitedSetV_loopCreation
        return true
    else return false
    end
end
