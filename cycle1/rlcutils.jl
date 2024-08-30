"""
  RLCUtils

Module that implements utilities that models
the RLC circuit mathematically.

This module is used by the main.jl module to
simulate the circuit using the IVPUtils module,
that computes the initial value problem.

Since:
- 08/2024

Authors:
- Breno H. Pelegrin da S. <breno.pelegrin@usp.br>
"""
module RLCUtils

  struct InstantWaveInfo{FloatType}
    wave::FloatType
    derivative::FloatType
  end

  struct WaveParams{FloatType}
    amplitude::FloatType
    angular_frequency::FloatType
    step_size::FloatType
  end

  struct RLCParams{FloatType}
    R::FloatType
    L::FloatType
    C::FloatType
    wave_params::WaveParams
  end

  function square_wave_derivative(wave_params::WaveParams, t)
    if mod(t, (1 / wave_params.angular_frequency)) < (wave_params.step_size / 2)
        return 1e+3
    else
        return 0
    end
  end

  function square_wave(wave_params::WaveParams, t)
    info = InstantWaveInfo{Float64}(
      wave_params.amplitude * sign(sin(wave_params.angular_frequency * t)),
      square_wave_derivative(wave_params, t)
    )
    return info
  end

  """
    rlc_ode_x2_f(t, x1, x2, rlc_params::RLCParams)

  Function that defines the following system of 2 ODEs for RK4:
  - x2' = rlc_ode_x2(t,x1,x2)
  - x1' = x2

  # Parameters
  - t (number): time
  - x1
  - x2
  - rlc_params (RLCParams): parameters of the RLC circuit

  # Returns
  - tuple (x2, x1)
  """
  function rlc_ode_x2_f(t, x1, x2, rlc_params::RLCParams)
    wave_info = square_wave(rlc_params.wave_params, t)
    return [x2, (wave_info.derivative - rlc_params.R * x2 - x1 / rlc_params.C) / rlc_params.L]
  end

end