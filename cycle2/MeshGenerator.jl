"""
  MeshGenerator

Module that generates a mesh of curent problem.

Dependencies:
- 

Since:
- 09/2024

Authors:
- Pedro Calligaris Delbem <pedrodelbem@usp.br>
"""
module MeshGenerator
    export InitializeMesh

    # imports the necessary modules
    #include("./V-AtThePoints.jl")
    #using .V-AtThePoints

    function InitializeMesh(side::Int,list_of_points::Vector{Tuple{Int, Int}})

        # create the mesh
        mesh = zeros(Float64, side, side)
        
        # define the positions of the eletrical chargess
        for i in 1:side
            for j in 1:side
                if (i,j) in list_of_points
                    mesh[i, j] = 1
                end
            end
        end

        # return the mesh
        return mesh
        
    end

end