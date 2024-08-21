#=
Implements the Runge Kutta method for solving 2nd order ODEs.

Since:
    2024/08

Authors:
    - Caio Cesar Fernandes Marques (caicofer) <caicofer@usp.br>
=#
using Plots
freq=5
damp=5

function deriv(t,x)
    global freq,damp
    y=x[1]
    y_1=x[2]

    # This variable declares the ODE to be solved
    fun=-y*freq^2 -y_1*damp + sin(t) + cos(t)

    vec=[x[2],fun]
    return vec 
end

v=[1.0,0.0]

dt=0.1
t=0
T=[]
X=[]

while t<100
    global v,t

    push!(X,v[1])
    push!(T,t)
    
    k1=deriv(t,      v)
    k2=deriv(t+dt/2, v + ((dt/2).*k1))
    k3=deriv(t+dt/2, v + ((dt/2).*k2))
    k4=deriv(t+dt  , v + (dt.*k3))
   
    v[1]+=(dt/6)*(k1[1]+2*k2[1]+2*k3[1]+k4[1])
    v[2]+=(dt/6)*(k1[2]+2*k2[2]+2*k3[2]+k4[2])

    t+=dt
end

plot(T,X)