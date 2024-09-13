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
  using LaTeXStrings
  import .IVPutils
  import .RLCUtils

  function main()
    # Defines the float type to use as Float64, for better precision
    type = Float64
    step::type = 1e-5 # (s)
    
    # Declares parameters for the simulation
    wave_params = RLCUtils.WaveParams(
      20,           # amplitude (V)
      10,           # angular freq (rad/s)
      step          # step (s)
    )

    rlc_params = RLCUtils.RLCParams(
      10,          # w0 = 200 (rad/s)
      60,           # gamma = 60 (Np/s) 
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

    # Computes the amplitudes of the interessing values
    wave_amp = wave_params.amplitude
    x1_amp = max(maximum(x1_arr), abs(minimum(x1_arr)))
    x2_amp = max(maximum(x2_arr), abs(minimum(x2_arr)))

    # Computes the caracteristics time
    t_char = 2/rlc_params.gamma
    
    #print(length(t_arr), length(x1_arr), length(x2_arr))

    """Plots.plot(t_arr/t_char, [x1_arr/x1_amp, source_arr/wave_amp], title="Comportamento de Q(t)", label=[L"\frac{Q(t)}{Q_{max}}" L"\frac{V(t)}{V_{0}}"], xlabel=L"\frac{t}{\tau}",linewidth=1)
    Plots.savefig("sup-x1.png")
    Plots.plot(t_arr/t_char, [x2_arr/x2_amp, source_arr/wave_amp], title="Comportamento de I(t)", label=[L"\frac{I(t)}{I_{max}}" L"\frac{V(t)}{V_{0}}"], xlabel=L"\frac{t}{\tau}", linewidth=1)
    Plots.savefig("sup-x2.png")
    Plots.plot(t_arr/t_char, source_arr/wave_amp, title=L"Comportamento de V(t)", ylabel=L"\frac{V(t)}{V_{0}}", xlabel=L"\frac{t}{\tau}", linewidth=1)
    Plots.savefig("sup-source.png")"""
    Plots.plot(t_arr/t_char, [x1_arr/x1_amp, x2_arr/x2_amp, source_arr/wave_amp], title="Comportamento de Q(t) e I(t)", label=[L"\frac{Q(t)}{Q_{max}}" L"\frac{I(t)}{I_{max}}" L"\frac{V(t)}{V_{0}}"], xlabel=L"\frac{t}{\tau}", linewidth=1)
    Plots.savefig("geral.png")

  end

  # Only runs main() if the script is run directly by calling `julia main.jl` in terminal.
  if abspath(PROGRAM_FILE) == @__FILE__
    main()
  end

end