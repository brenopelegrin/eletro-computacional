module cycle1
  include("./ivputils.jl")
  using Printf
  import .IVPutils

  function main()

    type = Float64

    function func(t, y)
      return t * y
    end

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

    t_euler, y_euler = IVPutils.IVP_solver(euler_params)
    t_rk4, y_rk4 = IVPutils.IVP_solver(rk4_params)

    println("Table of solutions:")
    print("----------------------------------------------------------\n")
    print("|t\t\t\t|y(euler)\t\t|y(rk4)\n")
    print("----------------------------------------------------------\n")

    for (i, val) in enumerate(t_euler)
      @printf("|%.6f\t\t|%.6f\t\t|%.6f\n", t_euler[i], y_euler[i], y_rk4[i])
    end

  end

  if abspath(PROGRAM_FILE) == @__FILE__
    main()
  end

end