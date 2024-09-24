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

    function InitializeMesh(side::Int,list_of_points::Array{Array{Int,1},1})

        # create the mesh
        mesh = zeros(Float64, side, side)
        
        # define the positions of the eletrical chargess
        for i in list_of_points
            mesh[i[1],i[2]] = 1
        end

        # return the mesh
        return mesh
        
    end

end