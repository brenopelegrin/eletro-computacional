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

    function InitializeMesh(side::Int,list_of_points::Vector{Tuple{Int, Int}})

        # create the mesh
        mesh = zeros(Float64, side, side)
        
        # define the positions of the eletrical chargess
        for point in list_of_points
            x, y = point
            mesh[x, y] = 1.0
        end

        # return the mesh
        return mesh
        
    end

end