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

                # inversione the list of points
                for i in 1:length(current_list)
                  current_list[i] = (current_list[i][2], current_list[i][1])
                end

                # defines the plot charge distribution
                scatter!(current_list, marker=:circle, color=:red, markersize=2, legend=false)

                # defines the plot equipotencial line
                contour!(final_mesh, levels=20, color=:green, alpha=0.5)
        
                # defines the field lines
                # for each point in the mesh
                for i in 1:18:side
                  for j in 1:18:side
        
                      # if the point is not in the list of points
                      if !((i,j) in current_list)
        
                        #ninitial point of the vector
                        x = i
                        y = j
                        # final point of the vector
                        dx = Ex[i,j]
                        dy = Ey[i,j]
                        
                        # plot a line from initial point to initial point + vector(field)
                        plot!([y, y + dy], [x, x + dx], lw=2, arrow=:arrow, arrowsize=0.25, color=:blue, legend=false)
                      end
                  end
                end
                
        plot!()

        # saves the plot
        Plots.savefig("gaussB.png")
        
    end
end