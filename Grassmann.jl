module Grassmann
export GrassmannVector, basis

import Base: zero, one, -, +, *, eltype, ==
include("./lib/print_vector.jl")

struct GrassmannVector{T}
    data::Dict{Set{Int},T}
    function GrassmannVector{T}(data::Dict{Set{Int},T}) where {T}
        new{T}(data)
    end
    GrassmannVector{T}() where {T} = new(Dict{Set{Int},T}())
    GrassmannVector{T}(number::T) where {T} = new(Dict(Set{Int}() => number))
end

function simplify!(vector_data)
    for (basis_element, coefficient) in vector_data
        if coefficient == zero(coefficient)
            delete!(vector_data, basis_element)
        end
    end
end

function Base.zero(::Type{GrassmannVector{T}}) where {T}
    return GrassmannVector{T}()
end

function Base.one(::Type{GrassmannVector{T}}) where {T}
    return GrassmannVector{T}(one(T))
end

function Base.:-(vector::GrassmannVector{T}) where {T}
    result_data = Dict{Set{Int},T}()

    for (basis_element, coefficient) in vector.data
        result_data[basis_element] = -coefficient
    end

    return GrassmannVector{T}(result_data)
end

function Base.:-(vector1::GrassmannVector{T}, vector2::GrassmannVector{T}) where {T}
    return vector1 + (-vector2)
end

function Base.:+(vector1::GrassmannVector{T}, vector2::GrassmannVector{T}) where {T}
    result_data = copy(vector1.data)

    for (basis_element, coefficient) in vector2.data
        result_data[basis_element] = get(result_data, basis_element, zero(coefficient)) + coefficient
    end

    simplify!(result_data)

    return GrassmannVector{T}(result_data)
end

sign(a1::Set, a2::Set) = sign(sort!(collect(a1)), sort!(collect(a2)))
function sign(a1::Vector, a2::Vector)
    exchanges = 0
    i = 1
    j = 1

    n1 = length(a1)
    n2 = length(a2)

    while i <= n1 && j <= n2
        if a1[i] <= a2[j]
            i += 1
        else
            exchanges += n1 - i + 1
            j += 1
        end
    end

    return exchanges % 2 == 0 ? 1 : -1
end

Base.:*(number::T, vector::GrassmannVector{T}) where {T} = vector * number
function Base.:*(vector::GrassmannVector{T}, number::T) where {T}
    if iszero(number)
        return GrassmannVector{T}()
    end

    result_data = Dict{Set{Int},T}()

    for (basis_element, coefficient) in vector.data
        result_data[basis_element] = coefficient * number
    end

    return GrassmannVector{T}(result_data)
end

function Base.:*(vector1::GrassmannVector{T}, vector2::GrassmannVector{T}) where {T}
    result = GrassmannVector{T}()

    for (basis_element1, coefficient1) in vector1.data
        for (basis_element2, coefficient2) in vector2.data
            if (!isempty(intersect(basis_element1, basis_element2)))
                continue
            end

            basis_element = union(basis_element1, basis_element2)
            s = sign(basis_element1, basis_element2)
            coefficient = s * coefficient1 * coefficient2

            result.data[basis_element] = get(result.data, basis_element, zero(coefficient)) + coefficient
        end
    end

    simplify!(result.data)

    return result
end

Base.eltype(::Type{GrassmannVector{T}}) where {T} = T

function e(n::Int, T=Float64)
    return GrassmannVector{T}(Dict(Set([n]) => one(T)))
end

function basis(n::Int, T=Float64)
    @assert n ≥ 0 || error("n should be ≥ 0")
    return [GrassmannVector{T}(Dict(Set([i]) => one(T))) for i = 1:n]
end

function basis(n::Int, ::Type{String})
    @assert n ≥ 0 || error("n should be ≥ 0")
    function element_string(i)
        indices = Int[]
        for j = 0:n-1
            if i & (1 << j) != 0
                push!(indices, j + 1)
            end
        end
        string = join(["e$i" for i in indices], "")
        return (Set(indices), string)
    end
    return [element_string(i) for i = 0:2^n-1]
end

function maximum_index(vector::GrassmannVector{T}) where {T}
    n = 0
    for (basis_element, coefficient) in vector.data
        n = max(n, maximum(basis_element))
    end
    return n
end

function Base.:(==)(vector1::GrassmannVector{T}, vector2::GrassmannVector{T}) where {T}
    return vector1.data == vector2.data
end

function Base.show(io::IO, vector::GrassmannVector{T}) where {T}
    print_vector(io, vector.data, basis(maximum_index(vector), String))
end
end