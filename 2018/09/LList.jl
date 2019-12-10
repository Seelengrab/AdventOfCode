mutable struct LList{T}
    value::T
    next::Union{LList{T}, Nothing}

    LList{T}(i::T) where {T} = LList{T}(i, nothing)
    LList{T}(i::T, n::Union{LList{T}, Nothing})  where {T} = new(i, n)
end

Base.IndexStyle(l::LList) = IndexLinear()

# Base.show(io::IO, l::LList) = begin
#     write(io, "[ ")

#     head = l
#     while head !== nothing
#         write(io, head.value, ", ")
#         head = head.next
#     end

#     write(io, "]")
# end

Base.size(l::LList) = begin
    head = l
    count = 0

    while head !== nothing
        count += 1
        head = head.next
    end

    return (count,)
end

Base.length(l::LList) = size(l)[1]

Base.getindex(l::LList, i::Int) = begin
    if i == 1
        return l.value
    end

    head = l
    pos = 1
    while pos != i
        head = head.next
        if head === nothing
            throw(BoundsError(l, i))
        end

        pos += 1
    end

    return head.value
end

Base.lastindex(l::LList) = size(l)[1]

Base.insert!(l::LList{T}, index::Int, item::T) where {T} = begin
    if index < 1
        throw(BoundsError(l, index))
    end

    if index == 1 # insertion at the head
        return LList{T}(item, l)
    else
        n = l
        pos = 1
        while pos + 1 != index
            if n.next === nothing
                throw(BoundsError(l, index))
            end
            n = n.next
            pos += 1
        end

        n.next = LList{T}(item, n.next)
        return l
    end
end

Base.deleteat!(l::LList, index::Int) = begin
    if index == 1
        return l.next
    end

    head = l
    pos = 1

    while pos+1 != index
        if head.next === nothing
            throw(BoundsError(l, index))
        end

        head = head.next
        pos += 1
    end

    head.next = head.next.next

    return l
end