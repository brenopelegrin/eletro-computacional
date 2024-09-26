using PyCall
using Plots

#O caminho pro arquivo SVG
svg_path="string"

#O Caminho pros arquivos svg_head_reader.py e svg_path_reader.py
diretorio_pys=""


#A linha 15 serve pra incluir o diretório dos arquivos Py falados acima no path do sistema. No meu caso,
#além de incluir o "diretorio_pys", tive que incluir esse segundo direório, pq meu Python é estranho e
#está instalado que nem o meu rabo. Talvez pra vcs n precise desse segundo termo!

pushfirst!(pyimport("sys")."path", diretorio_pys,"C:/Users/caico/AppData/Local/Programs/Python/Python310/Lib/site-packages");

size_extract=pyimport("svg_head_reader")
pts_extract=pyimport("svg_path_reader")

mat=pts_extract.svg_contour(svg_path,45)

x,y=[],[]

for point in mat
    push!(x,point[1])
    push!(y,point[2])
end

println(size_extract.svg_dims(svg_path))

plot((x,y),seriestype=:scatter)