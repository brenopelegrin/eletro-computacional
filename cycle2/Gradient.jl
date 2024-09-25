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
    
    function compute_gradient(mesh::Matrix{Float64},side::Int)

        # initialize the gradient
        Ex = zeros(Float64, size(mesh))
        Ey = zeros(Float64, size(mesh))
        
        # compute the gradient
        for i in 1:side
            for j in 1:side

                #at the ends
                if i == 1
                    Ex[i, j] = (mesh[i+1, j] - mesh[i, j])
                elseif i == side
                    Ex[i, j] = (mesh[i, j] - mesh[i-1, j])

                #other points
                else
                    Ex[i, j] = (mesh[i+1, j] - mesh[i-1, j])/2
                end

                #at the ends
                if j == 1
                    Ey[i, j] = (mesh[i, j+1] - mesh[i, j])/2
                elseif j == side
                    Ey[i, j] = (mesh[i, j] - mesh[i, j-1])/2
                #other points
                else
                    Ey[i, j] = (mesh[i, j+1] - mesh[i, j-1]) / 2
                end
                
            end
        end
        
        return Ex, Ey

    end
end
