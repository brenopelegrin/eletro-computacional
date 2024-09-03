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

  export square_wave, WaveParams, RLCParams, dx1_dt, dx2_dt

  struct InstantWaveInfo
    wave::Float64
    derivative::Float64
  end

  struct WaveParams
    amplitude::Float64
    angular_frequency::Float64
    step_size::Float64
  end

  struct RLCParams
    w0::Float64
    gamma::Float64
    wave_params::WaveParams
  end

  function square_wave_derivative(wave_params::WaveParams, t)
    if t % (1 / wave_params.angular_frequency) < (wave_params.step_size / 2)
      return 1e+4
    else
      return 0
    end
  end

  function square_wave(wave_params::WaveParams, t)
    return wave_params.amplitude * sign(sin(wave_params.angular_frequency * t))
  end

  function dx1_dt(t, x1, x2, rlc_params::RLCParams)
    return x2
  end

  function dx2_dt(t, x1, x2, rlc_params::RLCParams)
    return square_wave(rlc_params.wave_params, t) - rlc_params.gamma*x2 - (rlc_params.w0^2)*x1
  end

end