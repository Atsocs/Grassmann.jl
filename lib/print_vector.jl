function print_vector(io::IO, data::Dict{K,V}, basis::Vector{Tuple{K,String}}) where {K,V}
    terms = []
    for (key, display) in basis
        coefficient = get(data, key, zero(V))
        if !iszero(coefficient)
            if isempty(display)
                if isone(coefficient)
                    push!(terms, "1")
                elseif isone(-coefficient)
                    push!(terms, "-1")
                else
                    push!(terms, "$(coefficient)")
                end
            else
                if isone(coefficient)
                    push!(terms, display)
                elseif isone(-coefficient)
                    push!(terms, "-$display")
                elseif coefficient > 0
                    push!(terms, "$(coefficient) * $display")
                else
                    push!(terms, "-$(abs(coefficient)) * $display")
                end
            end
        end
    end
    if !isempty(terms)
        # join with " + " or " - " depending on the sign of each term
        result = strip(terms[1])
        for term in terms[2:end]
            if term[1] == '-'
                result *= " - $(strip(term[2:end]))"
            else
                result *= " + $(strip(term))"
            end
        end
        print(io, result)
    else
        print(io, "0")
    end
end
