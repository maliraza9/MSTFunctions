using PowerModels, LightGraphs, InfrastructureModels, Ipopt, JuMP, SimpleWeightedGraphs, SimpleTraits, DataStructures, SimpleGraphs, GraphPlot, TikzPictures, LazySets, GeometryTypes
i=3

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



    C = zeros(Int,N)

    for i in 1:size(C)[1]
        #convert(Int,i)
        C[i] = i
    end

    C

    itr = 1
    Triple_ij = zeros(N*N,3)

    for i in 1:size(dmx[1:end,1])[1]
        for j in 1:size(dmx[1:end,1])[1]
            Triple_ij[itr,:] = [i, j, dmx[i,j]]
            itr = itr+1
        end
    end

    Triple_ij




    Tij_original = Triple_ij

    Tij = initTradeoff(p_set, dmx, N)   # 1

###################################################################
    for i in 1:10

        i
        #display(i+1)

        minT_argument = argmin(Tij[:,3])
        Tij[10,:]

        Tij

        minT = Tij[minT_argument,:]

        E_T = push!(E_T,[minT[1], minT[2]])
        W_T = push!(W_T,[minT[3]])
        V_T = push!(V_T, minT[2])
        #display(V_T')

        p_set = updateP(heur, V_T[end], p_set, C, V_T)
        Tij = updateTradeoff(p_set, dmx, N)
        if heur == 3
            C =  updateC(C, V_T)
        end

        #display("------------")
        #display(dmx[V_T[end-1], V_T[end]])
        dmx[V_T[end-1], V_T[end]]
        dmx[V_T[end], V_T[end-1]]
        dmx[V_T[end-1], V_T[end]] = 2000000000
        dmx[V_T[end], V_T[end-1]] = 2000000000
        #display("------------")

        dmx
    end
    display(E_T)


    #display(E_T)
    #display(W_T)
    #display(V_T)
    #display(Tij)
    ###########################################

    """
    minT_argument = argmin(Tij_2[:,3])
    minT = Tij_2[minT_argument,:]

    #display("2")
    #display(minT)


    #display(p_set)
    #display(Tij_2)
    #nodeJ = 3
    E_T = push!(E_T,[minT[1], minT[2]])
    W_T = push!(W_T,[minT[3]])
    V_T = push!(V_T, minT[2])
    display("2")
    display(E_T)
    display(W_T)
    display(V_T)
    p_set = updateP(heur, V_T[end], p_set, C, V_T)
    Tij_3 = updateTradeoff(p_set, dmx, N)
    if heur == 3
        C =  updateC(C, V_T)
    end

    minT_argument = argmin(Tij_3[:,3])
    minT = Tij_3[minT_argument,:]
    display("------------")
    display(dmx[V_T[end-1], V_T[end]])
    dmx[V_T[end-1], V_T[end]] = 2000000000
    dmx[V_T[end], V_T[end-1]] = 2000000000
    display("------------")


    E_T = push!(E_T,[minT[1], minT[2]])
    W_T = push!(W_T,[minT[3]])
    V_T = push!(V_T, minT[2])
    display("3")
    display(E_T)
    display(W_T)
    display(V_T)


    nodeJ = 3
    E_T = push!(E_T,[minT[1], minT[2]])
    W_T = push!(W_T,[minT[3]])
    V_T = push!(V_T, minT[2])


    display("4")
    display(E_T)
    display(W_T)
    display(V_T)
    p_set = updateP(heur, V_T[end], p_set, C, V_T)
    Tij_4 = updateTradeoff(p_set, dmx, N)
    if heur == 3
        C =  updateC(C, V_T)
    end

    minT_argument = argmin(Tij_4[:,3])
    minT = Tij_4[minT_argument,:]
    display("------------")
    display(dmx[V_T[end-1], V_T[end]])
    dmx[V_T[end-1], V_T[end]] = 2000000000
    dmx[V_T[end], V_T[end-1]] = 2000000000
    display("------------")


    E_T = push!(E_T,[minT[1], minT[2]])
    W_T = push!(W_T,[minT[3]])
    V_T = push!(V_T, minT[2])
    display("4")
    display(E_T)
    display(W_T)
    display(V_T)

    #display("3")
    #display(minT)



    #display(p_set)
    #display(Tij_3)
    """



end

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

dmx_updateTradeoff = dmx
i = 1
j = 1
function updateTradeoff(p_set_updateTradeoff, dmx_updateTradeoff, N)
    itr = 1
    Triple_ij_updateTradeoff = zeros(N*N,3)
    #display(dmx_updateTradeoff)

############################
    itr = 1
    dmx
    for i in 1:size(dmx_updateTradeoff[1:end,1])[1]
        for j in 1:size(dmx_updateTradeoff[1:end,1])[1]
            Triple_ij_updateTradeoff[itr,:] = [i, j, dmx_updateTradeoff[i,j]]
            itr = itr+1
            if i == 2.0 && j == 5.0
                display(dmx_updateTradeoff[i,j])
            end

        end
    end
    #display(Triple_ij_updateTradeoff)
    itr = 1

    for i in 1:size(Triple_ij_updateTradeoff[1:end,1])[1]
        Triple_ij_updateTradeoff[itr,3] = Triple_ij_updateTradeoff[itr, 3] - p_set_updateTradeoff[convert(Int,Triple_ij_updateTradeoff[itr,1])]
        itr = itr+1
    end
    return Triple_ij_updateTradeoff
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

function updateP(heur_updateP, selected_Node_updateP, p_set_updateP, C, V_T)
    if heur_updateP == 1
        p_set_upd = P_update_Prim(selected_Node_updateP, p_set_updateP)
    elseif heur_updateP == 2
        p_set_upd = P_update_Kruskal(selected_Node_updateP, p_set_updateP)
    elseif heur_updateP == 3
        p_set_upd = P_update_EW(selected_Node_updateP, p_set_updateP, C, V_T)
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

function P_update_EW(selected_Node_updateP, p_set_updateP, C, V_T)
    for v in C[V_T[end-1]]
        v = convert(Int,v)
        p_set_updateP[v] = p_set_updateP[selected_Node_updateP]
    end
    return p_set_updateP
end

function updateC(C, V_T)
    push!([C[2]],1)
    push!([C[1]],2)
    #push!([C[V_T[end-1]]],V_T[end])
    #push!([C[V_T[end]]],V_T[end-1])
    return C
end
