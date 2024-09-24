"""
  Gradient

Module that calculate the gradient of the mesh

Dependencies:
- 

Since:
- 09/2024

Authors:
- Pedro Calligaris Delbem <pedrodelbem@usp.br>
"""
module Gradient
    export compute_gradient
    
    function compute_gradient(mesh::Array{Float64, 2})

        # initialize the gradient
        Ex = zeros(Float64, size(mesh))
        Ey = zeros(Float64, size(mesh))
        
        # difines the rows and columns
        rows, cols = size(mesh)
        
        # compute the gradient
        for i in 2:rows-1
            for j in 2:cols-1
                Ex[i, j] = (mesh[i+1, j] - mesh[i-1, j]) / 2
                Ey[i, j] = (mesh[i, j+1] - mesh[i, j-1]) / 2
            end
        end
        
        return Ex, Ey

    end
end
