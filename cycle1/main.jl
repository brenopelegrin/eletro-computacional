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
  include("./rlcutils.jl")
  using Printf
  using Plots
  import .IVPutils
  import .RLCUtils

  function main()

    # Defines the float type to use as Float64, for better precision
    type = Float64
    step::type = 1e-4

    wave_params = RLCUtils.WaveParams{type}(
      1.0,          # amplitude
      2*pi*5,       # freq angular
      step          # step
    )

    rlc_params = RLCUtils.RLCParams{type}(
      1.0,      # R
      1.0,      # L
      1.0,      # C
      wave_params
    )

    rk4_params = IVPutils.IVPSolverSystemParams{type}(
      RLCUtils.rlc_ode_x2_f,            # f
      0.0,                              # t0
      10.0,                             # tf
      0.0,                              # x1_0
      0.0,                              # x2_0
      step,                             # h
      type,                             # type
      IVPutils.rk4_system_of_2_odes     # method
    )

    t, x1, x2 = IVPutils.IVP_solver_2ode_system(rk4_params, rlc_params)
    plot!(t, x1, title="Comportamento da corrente", label="x1(t)", linewidth=3, show=true)
    savefig("corrente.png")

  end

  # Only runs main() if the script is run directly by calling `julia main.jl` in terminal.
  if abspath(PROGRAM_FILE) == @__FILE__
    main()
  end

end