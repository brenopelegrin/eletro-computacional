"""
  cycle2

Module that 

To run the main() function, call `julia main.jl` on the terminal.

Dependencies:
- Uses the MeshGenerator module generate the mesh and uses MeshUpdater to update the mesh

Since:
- 09/2024

Authors:
- Pedro Calligaris Delbem <pedrodelbem@usp.br>
"""
module cycle2

    # Imports necessary modules
    include("./MeshGenerator.jl")
    include("./MeshUpdater.jl")
    using .MeshGenerator 
    using .MeshUpdater
    using Plots

    function main()

        # define de mesh length
        side::Int = 101
        minimum_interations::Int = 1000

        # list of the poins with charge
        list_of_points = [[48,43],[49,43],[50,43],[51,43],[52,43],#I
                        [49,47],[50,47],[51,47],[52,47],[53,47],
                        [48,49],[49,49],
                        [48,51],[49,51],#F
                        [49,53],[50,53],[51,53],[51,55],[53,55],
                        [47,54],[47,55],
                        [51,54],[51,55],
                        [53,54],[53,55],#S
                        [47,59],[48,59],[49,59],[50,59],[51,59],[52,59],
                        [47,60],[47,61],
                        [53,60],[53,61]]
        
        # create the mesh
        mesh = MeshGenerator.InitializeMesh(side, list_of_points)
        
        # atualize the mesh
        final_mesh = MeshUpdater.UpdateMesh(mesh, side, minimum_interations, list_of_points)

        # plot the mesh
        Plots.heatmap(mesh)
        Plots.savefig("initial_mesh.png")
        Plots.heatmap(final_mesh)
        Plots.savefig("mesh.png")

    end

end