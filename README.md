# Grassmann.jl 

Grassmann.jl is a Computer Algebra System designed to handle Grasmann Algebras. This package provides functionalities for working with Grassmann numbers and performing algebraic operations on them.

## Example Usage
```julia
using Grassmann

e1, e2, e3, e4 = Grassmann.basis(4)
v = e1 * e2 + e2 * e3 + e3 * e4 - e1 * e4

# Verify that v * v == 0
println("v = ", v)
println("v * v = ", v * v)
```

## Expected Output
```output
v = e1e2 + e2e3 - e1e4 + e3e4
v * v = 0
```
