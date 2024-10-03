"""
  PlotAll

Module that defines the plots of the problem

Dependencies:
- Plots and LaTeXStrings

Since:
- 09/2024

Authors:
- Pedro Calligaris Delbem <pedrodelbem@usp.br>
"""
module PlotAll
    export create_plot

    # imports the necessary modules
    using Plots
    using LaTeXStrings

    function CreatePlot(final_mesh::Matrix{Float64}, side::Int, current_list::Vector{Tuple{Int, Int}}, Ex::Matrix{Float64}, Ey::Matrix{Float64})

                # create the plot
                plot(title="Charge, Equipotentials and Field ")

                # defines the plot charge distribution
                scatter!(current_list, marker=:circle, color=:red, markersize=5)

                # defines the plot equipotencial line
                contour!(final_mesh, levels=20, color=:blue, alpha=0.5)

                # Normalize the field vectors
"""                magnitude = sqrt.(Ex.^2 .+ Ey.^2) .+ 1e-9  # Add a small number to avoid division by zero
                Ex_norm = Ex ./ magnitude
                Ey_norm = Ey ./ magnitude"""
        
                # defines the field lines
                # for each point in the mesh
                for i in 1:7:side
                  for j in 1:7:side
        
                      # if the point is not in the list of points
                      if !((i,j) in current_list)
        
                        #ninitial point of the vector
                        x = i
                        y = j
                        # final point of the vector
                        dx = Ex[i,j]
                        dy = Ey[i,j]
                        
                        # plot a line from initial point to initial point + vector(field)
                        plot!([x, x + dx], [y, y + dy], lw=2, arrow=:arrow, arrowsize=0.25, color=:grey, legend=false)
                      end
                  end
                end
                
        plot!()
        # saves the plot
        Plots.savefig("ampere.png")
        
    end
end