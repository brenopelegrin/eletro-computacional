import numpy as np
import svgpathtools as spt
import svg_head_reader as shr

def realize(z):
    return (np.real(z),np.imag(z))

def svg_contour(path,distance):
    
    with open(path) as arq:
        File=spt.svg2paths(arq) 
    dic_dims=shr.svg_dims(path)
    xdim,ydim=dic_dims['width'],dic_dims['height']
    diag=np.sqrt(xdim**2 + ydim**2)
    dis=distance*diag/300
    Paths=File[0]
    dt=1e-4
    points=[]

    for segment in Paths:
        t=0
        Dist=0
        points.append(realize(segment.point(0)))
        while t<=1-dt/2:
            if np.isclose(t,1):
                t=1
            S_i=segment.point(t)
            S_ii=segment.point(t+dt)
            Dist+=abs(S_ii-S_i)
            if Dist>=dis:
                Dist=0
                points.append(realize(S_i))
            t+=dt

    return points




