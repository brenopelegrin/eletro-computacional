"""
  IVPutils

A module that provides utilities (solver and numerical methods)
to solve initial value problems (IVP).

Since:
- 08/2024

Authors:
- Breno H. Pelegrin da S. <breno.pelegrin@usp.br>
"""
module IVPutils
  export FunctionParams, MethodParams, IVPSolverParams, IVPSystemSolverParams, IVP_solver, IVP_RLC_solver, rk4_system_of_2_odes, rk4_method, euler_method

  """
    MethodParams{FloatType}

  Parameters for a generic numeric method for an IVP in the form:
  - y' = f(t,y), with initial condition y(t0) = y0.

  You can pass any float type (Float16, Float32, Float64)
  in ``FloatType`` and ``type``, to achieve the desired precision.

  # Parameters:
  - f (Function): the function
  - tn (FloatType): time in the n-step
  - yn (FloatType): y in the n-step
  - h (FloatType): step size
  - type (DataType): type of the float to be used.
  """
  struct MethodParams{FloatType}
    f::Function
    tn::FloatType
    yn::FloatType
    h::FloatType
    type::DataType
  end

  """
    IVPSolverParams{FloatType}

  Parameters for a IVP solver that solves IVPs in the form:
  - y' = f(t,y), with initial condition y(t0) = y0.

  You can pass any float type (Float16, Float32, Float64)
  in ``FloatType`` and ``type``, to achieve the desired precision.

  # Parameters:
  - f (Function): the function f(x,y)
  - t0 (FloatType): time in which y(t0) = y0
  - y0 (FloatType): initial condition
  - tf (FloatType): final time (time to stop)
  - h (FloatType): step size
  - type (DataType): type of the float to be used
  - method (Function): the method to be used
  """
  struct IVPSolverParams{FloatType}
    f::Function
    t0::FloatType
    tf::FloatType
    y0::FloatType
    h::FloatType
    type::DataType
    method::Function
  end
  
  function rk4_method(params::MethodParams)
    k1::params.type = params.f(params.tn, params.yn)
    k2::params.type = params.f(params.tn + 0.5*params.h, params.yn + params.h*0.5*k1)
    k3::params.type = params.f(params.tn + 0.5*params.h, params.yn + params.h*0.5*k2)
    k4::params.type = params.f(params.tn + params.h, params.yn + params.h*k3)
    yn1::params.type = params.yn + (params.h/6) * (k1 + 2*k2 + 2*k3 + k4)
    return yn1
  end
  
  function euler_method(params::MethodParams)
    yn1::params.type = params.yn + params.h * params.f(params.tn, params.yn)
    return yn1
  end

  function IVP_solver(ivp_params::IVPSolverParams)

  end

  """
    IVP_solver(ivp_params)

  Solves an initial value problem (IVP) given the
  ivp_params (of type IVPSolverParams).

  The IVP is of the form:
  - y' = f(t,y), with initial condition y(t0) = y0.

  This solver allows to use any type of float to get
  the desired precision. When creating IVPSolverParams,
  you can use Float64, Float32 or Float16 and pass the
  ``type`` parameter accordingly.

  # Parameters inside IVPSolverParams
  - f (Function): the function f(x,y)
  - t0 (FloatType): time in which y(t0) = y0
  - y0 (FloatType): initial condition
  - tf (FloatType): final time (time to stop)
  - h (FloatType): step size
  - type (DataType): type of the float to be used
  - method (Function): the method to be used
  """
  function IVP_solver(ivp_params::IVPSolverParams)
    # Generates the time array from t0 to tf, with step h
    t = range(ivp_params.t0, ivp_params.tf, step=ivp_params.h)
    # Generates an empty array with same size of t for storing the y values
    y = zeros(length(t) + 1)

    # Sets up y(i=1) = y0
    y[1] = ivp_params.y0

    # For each time step in t, computes the numeric method for the i+1 step.
    for (i, val) in enumerate(t)
      method_params = MethodParams{ivp_params.type}(
        ivp_params.f, 
        t[i],
        y[i],
        ivp_params.h,
        ivp_params.type
      )
      # y_(i+1) = method(params in step n)
      y[i+1] = ivp_params.method(method_params)
    end 

    # Returns the filled t and y arrays
    return t, y

  end

  """
    struct IVPSystemSolverParams{FloatType}
  
  Defines the parameters of an IVP system solver.

  # Parameters
  - f1 (Function): the function f1(t,x1,x2)
  - f2 (Function): the function f2(t,x1,x2)
  - t0 (FloatType): time in which x1(t0) = x1_0 and x2(t0) = x2_0
  - tf (FloatType): final time (time to stop)
  - x1_0 (FloatType): initial condition for x1
  - x2_0 (FloatType): initial condition for x2
  - h (FloatType): step size
  - type (DataType): type of the float to be used
  - method (Function): the method to be used
  """
  struct IVPSystemSolverParams{FloatType}
    f1::Function
    f2::Function
    t0::FloatType
    tf::FloatType
    x1_0::FloatType
    x2_0::FloatType
    h::FloatType
    type::DataType
    method::Function
  end

  """
    struct SystemMethodParams{FloatType}
  
  Defines the parameters received by a numerical method step.

  # Parameters
  - f1 (Function): the function f1(t,x1,x2)
  - f2 (Function): the function f2(t,x1,x2)
  - tn (FloatType): previous time value
  - x1n (FloatType): previous x1 value
  - x2n (FloatType): previous x2 value
  - h (FloatType): step size
  - type (DataType): type of the float to be used
  """
  struct SystemMethodParams{FloatType}
    f1::Function
    f2::Function
    tn::FloatType
    x1n::FloatType
    x2n::FloatType
    h::FloatType
    type::DataType
  end

  """
    rk4_system_of_2_odes(params::SystemMethodParams)
  
  Computes the RK4 solution for an IVP system of 2 ODEs:
  - dx1/dt = f1(t,x1,x2)
  - dx2/dt = f2(t,x1,x2)

  Returns:
  - x1 for the next step
  - x2 for the next step
  """
  function rk4_system_of_2_odes(params::SystemMethodParams, other_params)
    dx1_dt = params.f1
    dx2_dt = params.f2
    x1 = params.x1n
    x2 = params.x2n
    t = params.tn
    h = params.h

    k1 = h*dx1_dt(t, x1, x2, other_params)
    h1 = h*dx2_dt(t, x1, x2, other_params)

    k2 = h*dx1_dt(t+h/2, x1+k1/2, x2+h1/2, other_params)
    h2 = h*dx2_dt(t+h/2, x1+k1/2, x2+h1/2, other_params)
    k3 = h*dx1_dt(t+h/2, x1+k2/2, x2+h2/2, other_params)
    h3 = h*dx2_dt(t+h/2, x1+k2/2, x2+h2/2, other_params)

    k4 = h*dx1_dt(t+h, x1+k3, x2+h3, other_params)
    h4 = h*dx2_dt(t+h, x1+k3, x2+h3, other_params)

    x1 = x1 + (k1+2*k2+2*k3+k4)/6.0
    x2 = x2 + (h1+2*h2+2*h3+h4)/6.0

    return x1, x2
  end

  """
    IVP_RLC_solver(ivp_params::IVPSystemSolverParams, rlc_params, source_wave)

  This function computes the solution of the RLC circuit
  using the IVPSystemSolverParams and RLCParams structs.

  The source_wave param is used to generate the source signal in time.

  This solver uses the RK4 method to solve an IVP system of 2 ODEs:
  - dx1/dt = x2(t)
  - dx2/dt = 1/L (E - Rx2 - x1/C)

  Returns:
    - time array
    - x1 array
    - x2 array
    - source array with the source_wave computed at each time
  """
  function IVP_RLC_solver(ivp_params::IVPSystemSolverParams, rlc_params, source_wave)
      # Initialize values and arrays
      x1::Float64 = ivp_params.x1_0
      x2::Float64 = ivp_params.x2_0
      t::Float64 = ivp_params.t0
      source::Float64 = source_wave(rlc_params.wave_params, t)

      x1_arr = [x1]
      x2_arr = [x2]
      t_arr = [t]
      source_arr = [source]
      tf = ivp_params.tf
      h = ivp_params.h

      # Loops until it reaches the final time
      while t <= tf
        method_params = SystemMethodParams{ivp_params.type}(
          ivp_params.f1,
          ivp_params.f2,
          t,
          x1,
          x2,
          ivp_params.h,
          ivp_params.type
        )
        x1, x2 = rk4_system_of_2_odes(method_params, rlc_params)
        source = source_wave(rlc_params.wave_params, t)
        # Give a step of size h
        t = t + h
        
        # Populate arrays
        push!(t_arr, t)
        push!(x1_arr, x1)
        push!(x2_arr, x2)
        push!(source_arr, source)
      end

      return t_arr, x1_arr, x2_arr, source_arr
  end

end