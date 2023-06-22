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
