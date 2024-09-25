"""
  cycle2

Module that 

To run the main() function, call `julia main.jl` on the terminal.

Dependencies:
- Uses the MeshGenerator module to generate the mesh, uses MeshUpdater to update the mesh
and uses Gradient module to calculate the gradient of que potencial (Field)

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
    using .MeshGenerator 
    using .MeshUpdater
    using .Gradient
    using Plots
    using LaTeXStrings

    function main()

        # define de mesh length
        side::Int = 11
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

        current_list = two_charges
        
        # create the mesh
        mesh = MeshGenerator.InitializeMesh(side, current_list)
        
        # atualize the mesh
        final_mesh = MeshUpdater.UpdateMesh(mesh, side, minimum_iterations, current_list)

        # compute the gradient of the potential
        Ex, Ey = Gradient.compute_gradient(final_mesh, side)
        # Normalize the field vectors
        magnitude = sqrt.(Ex.^2 .+ Ey.^2) .+ 1e-9  # Add a small number to avoid division by zero
        Ex_norm = Ex*2 ./ magnitude
        Ey_norm = Ey*2 ./ magnitude

        plot()
        quiver!(1:side, 1:side, quiver=(Ex_norm, Ey_norm), color=:black, label="Linhas de Campo", arrow=:true)
        Plots.savefig("field.png")

        # create the plot
        plot()

        # defines the plot charge distribution
        scatter!(current_list, marker=:circle, color=:red, markersize=1)

        # defines the plot equipotencial line
        contour!(final_mesh, levels=20, color=:grays, alpha=0.5, label="Linhas Equipotenciais")

        # defines the field lines
        quiver!(1:side, 1:side, quiver=(Ex_norm, Ey_norm), color=:black, label="Linhas de Campo", arrow=:true)

        # defines the plot
        title!("Distribuição de Cargas, Equipotenciais e Linhas de Campo")
        xlabel!("x")
        ylabel!("y")
        plot!()

        # saves the plot
        Plots.savefig("plot.png")

    end

end