"""
  cycle1

Module that simulates and analyzes the behaviour of a RLC
circuit with a square-wave source.

To run the main() function, call `julia main.jl` on the terminal.

Dependencies:
- Uses the IVPUtils module to solve the initial value problem (IVP)

Since:
- 08/2024

Authors:
- Breno H. Pelegrin da S. <breno.pelegrin@usp.br>
"""
module cycle1
  include("./ivputils.jl")
  using Printf
  import .IVPutils

  function main()

    # Defines the float type to use as Float64, for better precision
    type = Float64

    # Defines the IVP function, of the form y' = f(x,y), with y(t0) = y0
    # This is a function used only for testing. It isn't the RLC circuit function.
    function func(t, y)
      return t * y
    end

    # Defines the initial parameters for each numerical method
    euler_params = IVPutils.IVPSolverParams{type}(
      func,                   # f
      0.0,                    # t0
      1.0,                    # tf
      1.0,                    # y0
      0.2,                    # h
      type,                   # type
      IVPutils.euler_method   # method
    )
    rk4_params = IVPutils.IVPSolverParams{type}(
      func,                   # f
      0.0,                    # t0
      1.0,                    # tf
      1.0,                    # y0
      0.2,                    # h
      type,                   # type
      IVPutils.rk4_method     # method
    )

    # Uses the IVP_solver from IVPUtils to solve the initial value problem.
    t_euler, y_euler = IVPutils.IVP_solver(euler_params)
    t_rk4, y_rk4 = IVPutils.IVP_solver(rk4_params)

    # Prints the results for each method.
    println("Table of solutions:")
    print("----------------------------------------------------------\n")
    print("|t\t\t\t|y(euler)\t\t|y(rk4)\n")
    print("----------------------------------------------------------\n")

    for (i, val) in enumerate(t_euler)
      @printf("|%.6f\t\t|%.6f\t\t|%.6f\n", t_euler[i], y_euler[i], y_rk4[i])
    end

  end

  # Only runs main() if the script is run directly by calling `julia main.jl` in terminal.
  if abspath(PROGRAM_FILE) == @__FILE__
    main()
  end

end