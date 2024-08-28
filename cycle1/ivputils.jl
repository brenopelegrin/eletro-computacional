module IVPutils

  export FunctionParams, MethodParams, IVPSolverParams, rk4_method, IVP_solver

  struct MethodParams{FloatType}
    f::Function
    tn::FloatType
    yn::FloatType
    h::FloatType
    type::DataType
  end

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
    t = range(ivp_params.t0, ivp_params.tf, step=ivp_params.h)
    y = zeros(length(t) + 1)
    y[1] = ivp_params.y0

    for (i,val) in enumerate(t)
      method_params = MethodParams{ivp_params.type}(
        ivp_params.f, 
        t[i],
        y[i],
        ivp_params.h,
        ivp_params.type
      )
      y[i+1] = ivp_params.method(method_params)
    end 

    return t, y

  end

end;