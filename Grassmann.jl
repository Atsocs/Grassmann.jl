struct GrassmannVector{S,T}
    data::Dict{Set{S},T}
end

function simplify!(vector_data)
    for (basis_element, coefficient) in vector_data
        if coefficient == zero(coefficient)
            delete!(vector_data, basis_element)
        end
    end
end

function Base.zero(::Type{GrassmannVector{S,T}}) where {S,T}
    GrassmannVector{S,T}(Dict{Set{S},T}())
end

function Base.one(::Type{GrassmannVector{S,T}}) where {S,T}
    data = Dict{Set{S},T}(Set{S}() => one(T))
    return GrassmannVector{S,T}(data)
end

function Base.:+(vector1::GrassmannVector{S,T}, vector2::GrassmannVector{S,T}) where {S,T}
    result_data = copy(vector1.data)

    for (basis_element, coefficient) in vector2.data
        result_data[basis_element] = get(result_data, basis_element, zero(coefficient)) + coefficient
    end

    simplify!(result_data)

    return GrassmannVector{S,T}(result_data)
end

get_sign(a1::Set{S}, a2::Set{S}) where {S} = get_sign(sort!(collect(a1)), sort!(collect(a2)))
function get_sign(a1::Vector{S}, a2::Vector{S}) where {S}
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


function Base.:*(vector1::GrassmannVector{S,T}, vector2::GrassmannVector{S,T}) where {S,T}
    result_data = Dict{Set{S},T}()

    for (basis_element1, coefficient1) in vector1.data
        for (basis_element2, coefficient2) in vector2.data
            if (!isempty(intersect(basis_element1, basis_element2)))
                continue
            end

            basis_element = union(basis_element1, basis_element2)
            s = get_sign(basis_element1, basis_element2)
            coefficient = s * coefficient1 * coefficient2

            result_data[basis_element] = get(result_data, basis_element, zero(coefficient)) + coefficient
        end
    end

    simplify!(result_data)

    return GrassmannVector{S,T}(result_data)
end

function basis(n::Int)
    @assert n ≥ 0 || error("n should be ≥ 0")
    return [GrassmannVector{Int,Float64}(Dict(Set([i]) => 1.0)) for i = 1:n]
end