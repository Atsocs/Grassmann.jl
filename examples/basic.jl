include("../Grassmann.jl")

e = e1, e2, e3, e4 = Grassmann.basis(4)
v = e1 * e2 + e2 * e3 + e3 * e4 - e1 * e4

# verify that v * v == 0
println("v = ", v)
println("v * v = ", v * v)

a = rand(4)
b = rand(4)

a = sum(a .* e)
b = sum(b .* e)

c = a * b

a12 = c.data[Set([1, 2])]
a13 = c.data[Set([1, 3])]
a14 = c.data[Set([1, 4])]
a23 = c.data[Set([2, 3])]
a24 = c.data[Set([2, 4])]
a34 = c.data[Set([3, 4])]

z = a12 * a34 - a13 * a24 + a14 * a23

v = (e1 - e2) * (e3 - e4)

function get_random_vector(d)
    e = Grassmann.basis(d)
    return sum(rand(d) .* e)
end

function get_random_k_vector(k, d)
    return prod(get_random_vector(d) for i in 1:k)
end