"""
  cycle2

Module that 

To run the main() function, call `julia main.jl` on the terminal.

Dependencies:
- Uses the MeshGenerator module to generate the mesh, MeshUpdater to update the mesh,
Gradient module to calculate the gradient of que potencial (Field) and Plots to plot the results.

Since:
- 09/2024

Authors:
- Pedro Calligaris Delbem <pedrodelbem@usp.br>
"""
module cycle2

    # Imports necessary modules
    include("./MeshGenerator.jl")
    include("./MeshUpdater.jl")
    include("./Gradient.jl")
    include("PlotAll.jl")
    using .MeshGenerator 
    using .MeshUpdater
    using .Gradient
    using .PlotAll

    function main()

        # define de mesh length
        side::Int = 101
        minimum_iterations::Int = 10000

        # list of the poins with charge
        list_of_points::Vector{Tuple{Int, Int}} = [(48, 43),(49, 43),(50, 43),(51, 43),(52, 43),#I
                        (49, 47),(50, 47),(51, 47),(52, 47),(53, 47),
                        (48, 49),(49, 49),
                        (48, 51),(49, 51),#F
                        (49, 53),(50, 53),(51, 53),(51, 55),(53, 55),
                        (47, 54),(47, 55),
                        (51, 54),(51, 55),
                        (53, 54),(53, 55),#S
                        (47, 59),(48, 59),(49, 59),(50, 59),(51, 59),(52, 59),
                        (47, 60),(47, 61),
                        (53, 60),(53, 61)]

        two_charges::Vector{Tuple{Int, Int}}  = [(3,3), (9,9)]

        four_charges::Vector{Tuple{Int, Int}} = [(25,25), (25,75), (75,25), (75,75)]

        current_list::Vector{Tuple{Int, Int}} = four_charges
        
        # create the mesh
        mesh::Matrix{Float64} = MeshGenerator.InitializeMesh(side, current_list)
        
        # atualize the mesh
        final_mesh::Matrix{Float64} = MeshUpdater.UpdateMesh(mesh, side, minimum_iterations, current_list)

        # compute the gradient of the potential
        Ex::Matrix{Float64}, Ey::Matrix{Float64} = Gradient.compute_gradient(final_mesh, side)

        # create the plot
        PlotAll.CreatePlot(final_mesh, side, current_list, Ex, Ey)


    end

end