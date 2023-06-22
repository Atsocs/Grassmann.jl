include("../Grassmann.jl")

e1, e2, e3, e4 = Grassmann.basis(4)
v = e1 * e2 + e2 * e3 + e3 * e4 - e1 * e4

# verify that v * v == 0
println("v = ", v)
println("v * v = ", v * v)