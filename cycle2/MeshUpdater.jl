"""
  MeshGenerator

Module that update the mesh

Dependencies:
- 

Since:
- 09/2024

Authors:
- Pedro Calligaris Delbem <pedrodelbem@usp.br>
"""
module MeshUpdater
    export InitializeMesh

    function UpdateMesh(mesh::Array{Float64, 2},side::Int,minimum_interations::Int,list_of_points::Array{Array{Int,1},1})    

        # create the mesh
        mesh = mesh

        # define the control factor
        control_fator = 1
        
        # update the mesh until the control factor is less than 1e-3
        while control_fator > 1e-3

            for interation in 1:minimum_interations

                # save the previous mesh
                previous_mesh = mesh

                # update the mesh
                for i in 2:side-1
                    for j in 2:side-1

                        # compute the intermitate value
                        r = 1/4*(mesh[i+1,j]+mesh[i-1,j]+mesh[i,j+1]+mesh[i,j-1]) - mesh[i,j]
                        # update the value of the mesh if the point is not in the list of points (the charges)
                        if !(i in list_of_points[:,1] && j in list_of_points[:,2])
                            mesh[i,j] += r
                        end

                    end
                end

                # update the control factor
                control_fator = maximum([abs(mesh[i, j] - previous_mesh[i, j]) for i in 1:side-1 for j in 1:side-1])

            
            end
        end

        # return the mesh
        return mesh

    end

end