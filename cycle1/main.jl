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
  # Imports necessary modules
  include("./rlcutils.jl")
  include("./ivputils.jl")
  using Printf
  using Plots
  import .IVPutils
  import .RLCUtils

  function main()
    # Defines the float type to use as Float64, for better precision
    type = Float64
    step::type = 1e-5 # (s)
    
    # Declares parameters for the simulation
    wave_params = RLCUtils.WaveParams(
      20,           # amplitude (V)
      25,           # angular freq (rad/s)
      step          # step (s)
    )

    rlc_params = RLCUtils.RLCParams(
      3,            # R = 3 Ohm
      50e-3,        # L = 50mH
      5e-4,         # C = 500 uF
      wave_params
    )

    rk4_params = IVPutils.IVPSystemSolverParams(
      RLCUtils.dx1_dt,                  # func1
      RLCUtils.dx2_dt,                  # func2
      0.0,                              # t0 (s)
      1.0,                              # tf (s)
      0.0,                              # x1_0
      0.0,                              # x2_0
      step,                             # h (s)
      type,                             # type
      IVPutils.rk4_system_of_2_odes     # method
    )

    # Computes the RK4 solution for the problem using RLCUtils functions and IVPUtils methods.
    source_wave = RLCUtils.square_wave
    t_arr, x1_arr, x2_arr, source_arr = IVPutils.IVP_RLC_solver(rk4_params, rlc_params, source_wave)
    
    print(length(t_arr), length(x1_arr), length(x2_arr))

    Plots.plot(t_arr, x1_arr, title="Comportamento de Q(t)", label="x1(t)", linewidth=1)
    Plots.savefig("x1.png")
    Plots.plot(t_arr, [x2_arr, source_arr*0.25], title="Comportamento de I(t)", label=["x2(t)" "V0(t) 0.25x"], linewidth=1)
    Plots.savefig("x2.png")
    Plots.plot(t_arr, source_arr, title="Comportamento de V(t)", label="V(t)", linewidth=1)
    Plots.savefig("source.png")

  end

  # Only runs main() if the script is run directly by calling `julia main.jl` in terminal.
  if abspath(PROGRAM_FILE) == @__FILE__
    main()
  end

end