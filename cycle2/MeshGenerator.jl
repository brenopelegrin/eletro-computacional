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

    function InitializeMesh(side::Int,list_of_points::Vector{Tuple{Int, Int}})

        # create the mesh
        mesh = zeros(Float64, side, side)

        # inversione the list of points
        for i in 1:length(list_of_points)
            list_of_points[i] = (list_of_points[i][1], list_of_points[i][2]+125)
        end
        
        # define the positions of the eletrical chargess
        for i in 1:side
            for j in 1:side
                if (i,j) in list_of_points
                    mesh[i, j] = 1.5e2
                end
            end
        end

        # return the mesh
        return mesh
        
    end

end