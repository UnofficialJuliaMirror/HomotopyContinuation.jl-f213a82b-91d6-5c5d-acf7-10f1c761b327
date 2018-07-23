export Newton

"""
    Newton()

A classical simple Newton operator for square linear systems using the LU factorization
to solve the linear systems.
"""
struct Newton <: AbstractCorrector end

struct NewtonCache{T} <: AbstractCorrectorCache
    A::Matrix{T}
    b::Vector{T}
end

function cache(::Newton, H::HomotopyWithCache, x, t)
    A = jacobian(H, x, t)
    b = evaluate(H, x, t)
    NewtonCache(A, b)
end

function correct!(xnext, ::Newton, cache::NewtonCache, H::HomotopyWithCache, x, t, tol, maxiters)
    A, b = cache.A, cache.b
    M, N = size(H)
    Homotopies.update!(H, x, t) # we have to update local affine patches
    evaluate_and_jacobian!(b, A, H, x, t)
    solve!(A, b)
    @inbounds for i = 1:N
        xnext[i] -= b[i]
    end

    k = 1
    while true
        Homotopies.update!(H, xnext, t) # we have to update local affine patches
        evaluate!(b, H, xnext, t)
        res = infinity_norm(b)
        if res < tol
            return Result(true, res, k)
        elseif k ≥ maxiters
            return Result(false, res, k)
        end

        k += 1
        # put jacobian in A
        jacobian!(A, H, xnext, t)

        solve!(A, b)
        @inbounds for i = 1:N
            xnext[i] -= b[i]
        end
    end
end
