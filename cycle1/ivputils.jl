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

  export FunctionParams, MethodParams, IVPSolverParams, rk4_method, IVP_solver

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

end;