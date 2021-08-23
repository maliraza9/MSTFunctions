using PowerModels, LightGraphs, InfrastructureModels, Ipopt, JuMP, SimpleWeightedGraphs, SimpleTraits, DataStructures, SimpleGraphs, GraphPlot, TikzPictures, LazySets, GeometryTypes

function unified_algorithm end
@traitfn function unified_algorithm(g::AG::(!IsDirected),
    distmx::AbstractMatrix{T}=weights(g)) where {T <: Real, U, AG <: AbstractGraph{U}}

    N = nv(g)
    dmx = distmx
    for d in 1:N
        dmx[d,d] = 2000000000
    end
    dmx
    v_oss = 1
    #convert(Int,v_oss)

    V_T = [v_oss] # set node oss
    E_T =[]
    W_T = []


    #initialize P in heuristic function
    heur = 1 #from argument of main function

    p_set_zeros = zeros(N)
    oss_Node = [v_oss]

    p_set_initialized = initializeP(heur, oss_Node, p_set_zeros, dmx)
    p_set = p_set_initialized


    C = []
    for i = 1:N
        push!(C,[])
    end

    for i = 1:N
        C[i] = [i]
    end




    itr = 1
    Triple_ij = zeros(N*N,3)

    for i in 1:size(dmx[1:end,1])[1]
        for j in 1:size(dmx[1:end,1])[1]
            Triple_ij[itr,:] = [i, j, dmx[i,j]]
            itr = itr+1
        end
    end

    Tij = initTradeoff(p_set, dmx, N)   # 1



    while(size(E_T[:,1])[1]<N-1)

        minT_argument = argmin(Tij[:,3])
        minT = Tij[minT_argument,:]

        minT[1] = convert(Int64, minT[1])
        minT[2] = convert(Int64, minT[2])
        candidateU = convert(Int64, minT[1])
        candidateV = convert(Int64, minT[2])

        E_T = push!(E_T,[candidateU, candidateV])
        W_T = push!(W_T,[minT[3]]) # this is not used in program since values are manipulated directlt in triple Tij[:,3] corresponding weights tij for node i,j
        V_T = push!(V_T, candidateV)



        p_set = updateP(heur, V_T[end], p_set, C, V_T, E_T)


        dmx = setUVinfinite(dmx, candidateU, candidateV)

        Tij, dmx = updateTradeoff(p_set, dmx, N) ### remove dmx as output argument
        C =  updateC(C, E_T)

    end
    display(E_T)
end



    ###########################################
    #Functions
    ###########################################







function initTradeoff(p_set_initTradeOff, dmx_initTradeoff, N)

    itr = 1
    Triple_ij_initTradeoff = zeros(N*N,3)

    for i in 1:size(dmx_initTradeoff[1:end,1])[1]
        for j in 1:size(dmx_initTradeoff[1:end,1])[1]
            Triple_ij_initTradeoff[itr,:] = [i, j, dmx_initTradeoff[i,j]]
            itr = itr+1
        end
    end
    itr = 1

    for i in 1:size(Triple_ij_initTradeoff[1:end,1])[1]
        Triple_ij_initTradeoff[itr,3] = Triple_ij_initTradeoff[itr, 3] - p_set_initTradeOff[convert(Int,Triple_ij_initTradeoff[itr,1])]#p_set_initTradeOff[convert(Int,Triple_ij_initTradeoff[itr,1])]
        itr = itr+1
    end
    return Triple_ij_initTradeoff
end

function updateTradeoff(p_set_updateTradeoff, dmx_updateTradeoff, N)
    itr = 1
    Triple_ij_updateTradeoff = zeros(N*N,3)

############################
    itr = 1
    #dmx
    for i in 1:size(dmx_updateTradeoff[1:end,1])[1]
        for j in 1:size(dmx_updateTradeoff[1:end,1])[1]
            Triple_ij_updateTradeoff[itr,:] = [i, j, dmx_updateTradeoff[i,j]]
            itr = itr+1
            #if i == 2.0 && j == 5.0
            #end

        end
    end
    itr = 1

    for i in 1:size(Triple_ij_updateTradeoff[1:end,1])[1]
        Triple_ij_updateTradeoff[itr,3] = Triple_ij_updateTradeoff[itr, 3] - p_set_updateTradeoff[convert(Int,Triple_ij_updateTradeoff[itr,1])]
        itr = itr+1
    end

    return Triple_ij_updateTradeoff, dmx_updateTradeoff
end

##################################
##################################

function initializeP(heur, root_node, p_set_empty, dmx_initializeP)
    if heur == 1
        p_set_init = P_initialize_Prim(root_node, p_set_empty)

    elseif heur == 2
        p_set_init = P_initialize_Kruskal(root_node, p_set_empty)
    elseif heur == 3
        p_set_init = P_initialize_EW(root_node, p_set_empty, dmx_initializeP)
    end
    return p_set_init
end

function P_initialize_Prim(selected_Node_initialize_Prim, p_set_initialize_Prim)


    p_set_initialize_Prim[selected_Node_initialize_Prim[1]] = 0
    for p in 1:size(p_set_initialize_Prim[1:end,1])[1]
        if p != selected_Node_initialize_Prim[1]
            p_set_initialize_Prim[p] = - 2000000000
        end
    end
    return p_set_initialize_Prim
end



function P_initialize_Kruskal(selected_Node_initialize_Kruskal, p_set_initialize_Kruskal)
    for p in 1:size(p_set_initialize_Kruskal[1:end,1])[1]
        p_set_initialize_Kruskal[p] = 0
    end
    return p_set_initialize_Kruskal
end

function P_initialize_EW(selected_Node_initialize_EW, p_set_initialize_EW, dmx_initialize_EW)
    for p in 1:size(p_set_initialize_EW[1:end,1])[1]
        p_set_initialize_EW[p] = dmx_initialize_EW[p,selected_Node_initialize_EW][1]
end
    return p_set_initialize_EW
end

function updateP(heur_updateP, selected_Node_updateP, p_set_updateP, C, V_T, E_T)
    if heur_updateP == 1
        p_set_upd = P_update_Prim(selected_Node_updateP, p_set_updateP)
    elseif heur_updateP == 2
        p_set_upd = P_update_Kruskal(selected_Node_updateP, p_set_updateP)
    elseif heur_updateP == 3
        p_set_upd = P_update_EW(selected_Node_updateP, p_set_updateP, C, E_T)
    end
    return p_set_upd
end

function P_update_Prim(selected_Node_update_Prim, p_set_update_Prim)
    p_set_update_Prim[selected_Node_update_Prim] = 0
    return p_set_update_Prim
end

function P_update_Kruskal(selected_Node_update_Kruskal, p_set_update_Kruskal)
    return p_set_update_Kruskal
end

function P_update_EW(selected_Node_updateP, p_set_updateP, C, E_T)

    node_i = E_T[end,1][1]
    node_i = convert(Int64, node_i)
    node_j = E_T[end,1][2]
    node_j = convert(Int64, node_j)
    for v in C[node_i]
        v = convert(Int,v)
        p_set_updateP[v] = p_set_updateP[selected_Node_updateP]
    end
    return p_set_updateP
end

function updateC(C, E_T)
    o = convert(Int64,E_T[end][1]) #convereting to Int64 for indexing in C[i] columns
    oo = convert(Int64,E_T[end][2])
    push!(C[o],E_T[end][2])
    push!(C[oo],E_T[end][1])
    return C
end

function setUVinfinite(dmx_setUVinfinite, candidateU, candidateV)

    dmx_setUVinfinite[candidateU, candidateV] = 2000000000
    dmx_setUVinfinite[candidateV, candidateU] = 2000000000
    return dmx_setUVinfinite
end
