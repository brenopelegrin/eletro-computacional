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
        
        # create the mesh
        mesh = MeshGenerator.InitializeMesh(side)
        
        # atualize the mesh
        final_mesh = MeshUpdater.UpdateMeh(mesh, side, minimum_interations)

        # plot the mesh
        Plots.heatmap(final_mesh)
        Plots.savefig("mesh.png")

    end

end