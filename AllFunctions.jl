connectedEdgeSet = [1 2; 2 3]
#t = 1
candNodeU = 1
candNodeV = 4
#positionMtx = [0 0; 1 -1; 1 1; 2 1; 2 -1]
positionMtx = [0 0; 0 1; 1 0;1 1]
visitedNodeSet = [1 2 3]

cableCrossingConstraint(connectedEdgeSet,candNodeU, candNodeV, positionMtx, visitedNodeSet)
    #take a distMX with all zeros. call it connectedNodeMTX. Update this in Update Algorithm Function
    #for all U-V connections: set connectedNodeMTX[u,v]=1

    # check: connectedNodeMTXV = sum(candNodeV=i). e.g @candNodeV=2: [0 0 1 1 1 0]=> nodeConnections = 3
    # ALSO required for candNodeU?????? YES

        # nodeConnectionsU || nodeconnectionsV > limit return vapExceeded = true => UV connection not possible
        #if nodeConnections > turnbineConnectionLimit
        #    return capExceed = true
        #else return capExceed = false
        #end
    #end

function capacityConstraint(candNodeU, candNodeV, connectedNodeMTX, turnbineConnectionLimit)

    nodeConnectionsU = sum(connectedNodeMTXV[candNodeU,:])
    nodeConnectionsV = sum(connectedNodeMTXV[:,candNodeV])

    if nodeConnectionsU>turnbineConnectionLimit || nodeconnectionsV>turnbineConnectionLimit
        return capExceed = true
    else return capExceed = false
    end
end

#function node2coordinate(positionMtx, connectedEdgeSet, candNodeU, candNodeV)
#connectedEdgeSet contains set of edges: [src(e),dst(e);.......;..]
#extract position coordinates for connectedEdgeSet[i] = [u,v].
#extract position coordinates for all candNodeU and candNodeV.
#positionMtx contains coordinates. row wise. for all nodes.
#NodeU is the selected src(e)
#NodeV is the selected dst(e)
#pos[collect(connList[1,end]),1][1]

function node2coordinate(positionMtx, node)
    x = positionMtx[node,1][1]
    y = positionMtx[node,2][1]
    return (x,y)
end

#NOT NEEDED: initialize xInter[i], yInter[i] in the size of size(connectedEdgeSet[1] => gives the number of rows. ALL ZEROS)
#NOT NEEDED: initialize crossed = false
#Find [x1,y1] and [x2,y2] | [candNodeU = [x1,y1], candNodeV=[x2,y2]] using  @node2coordinate
#using @node2coordinate
    #connectedEdgeSet[i,1] => coordinatesPrevU[i] => [x3,y3] and
    #connectedEdgeSet[i,2] => coordinatesPrevV[i] => [x4,y4]

    #now available:
    #[candNodeU = [x1,y1], candNodeV=[x2,y2]]
    #[coordinatesPrevU[i][1:2] = [x3,y3], coordinatesPrevV[i][1:2] = [x4,y4]]


        #if crossed == true
        #    return cableCrossing = true
        #else
    #        return cableCrossing = false
    #    end
    #end

function cableCrossingConstraint(connectedEdgeSet,candNodeU, candNodeV, positionMtx, visitedNodeSet)
    coordinates = node2coordinate(positionMtx, candNodeU)
    x1 = coordinates[1]
    y1 = coordinates[2]

    coordinates = node2coordinate(positionMtx, candNodeV)
    x2 = coordinates[1]
    y2 = coordinates[2]

    for t in size(connectedEdgeSet[1:end,1])[1]
        coordinates = node2coordinate(positionMtx, connectedEdgeSet[t,1])
        x3 = coordinates[1]
        y3 = coordinates[2]

        coordinates = node2coordinate(positionMtx, connectedEdgeSet[t,2])
        x4 = coordinates[1]
        y4 = coordinates[2]


        den = ((x1-x2)*(y3-y4)-(y1-y2)*(x3-x4))
        if den!=0
            xInter= ((x1*y2-y1*x2)*(x3-x4)-(x1-x2)*(x3*y4-y3*x4))/den
            yInter= ((x1*y2-y1*x2)*(y3-y4)-(y1-y2)*(x3*y4-y3*x4))/den

            if minimum([x1,x2])<xInter<maximum([x1,x2]) && minimum([y1,y2])<yInter<maximum([y1,y2]) && minimum([x3,x4])<xInter<maximum([x3,x4]) && minimum([y3,y4])<yInter<maximum([y3,y4]) == true
                return true #crossed = true
            else #return false #crossed = false
            end
        #else
        println(t)
        end return false #crossed = false
    end
end


    #statements
    #statements: loop exists if for candNodeU from disjoint set notVisitedNodeSet, the candNodeV exists in a disjoint set visitedNodeSet

    #if candNodeU or candNodeV
    #if loopExists == true
    #    return branchCycle == true
    #else branchCycle == false
    #end

    #for l in size(visitedNodeSet)
    #end

function loopCreation(visitedNodeSet, candNodeU, candNodeV)
    if candNodeU in visitedNodeSet && candNodeV in visitedNodeSet
        return branchCyclic = true
    else return branchCyclic = false
    end
end

function algorithm()
    #statements
    #statements
    #statemetns
end
