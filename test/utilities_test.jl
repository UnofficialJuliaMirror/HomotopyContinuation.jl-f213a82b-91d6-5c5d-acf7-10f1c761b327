@testset "Utilities" begin
    @polyvar x y z

    @test Utilities.totaldegree([x^2+3, y^2*x^2-2]) == [x^2-1, y^4-1]
    @test Utilities.totaldegree([x^2+3z^2, y^2*x^2-2z^4]) == [y^2-x^2, z^4-x^4]

    @test Utilities.ishomogenous(x^2+y^2+x*y)
    @test Utilities.ishomogenous([x^2+y^2+x*y, x^5])
    @test Utilities.ishomogenous([x^2+y^2+x*y, x^4+1]) == false

    @test Utilities.ishomogenous(Utilities.homogenize([x^2+y^2+x*y, x^4+1]))
    @test Utilities.nvariables(Utilities.homogenize([x^2+y^2+x*y, x^4+1])) == 3

    A = rand(Complex{Float64}, 12, 12)
    b = rand(Complex{Float64}, 12)
    C = zero(A)
    d = zero(b)

    C .= A
    d .= b
    @test norm(Utilities.ldiv_lu!(C, d) - A \ b) < 1e-12
end
