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

    function InitializeMesh(side::Int)

        # create the mesh
        mesh = zeros(Float64, side, side)
        
        # define the position of the eletrical charge
        center = div(side,2)
        mesh[center, center] = 1

        # return the mesh
        return mesh
        
    end

end