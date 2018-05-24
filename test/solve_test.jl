@testset "solve" begin
    @polyvar x
    @test nfinite(solve([x - 1])) == 1
    F = equations(katsura(5))
    @test nfinite(solve(F, threading=false)) == 32
    @test nfinite(solve(F, system=Systems.SPSystem, threading=false)) == 32
    @test nfinite(solve(F, system=Systems.FPSystem, threading=false)) == 32

    @test nfinite(solve(F, homotopy=Homotopies.StraightLineHomotopy)) == 32
    result = solve(F, predictor=Predictors.Euler(), homotopy=Homotopies.StraightLineHomotopy)
    @test nresults(result) == 32
    @test nfinite(solve(F, tol=1e-5)) == 32

    result = solve(F)
    @test nfinite(result) == 32
    @test string(result) isa String

    @test nfinite(solve(F, patch=AffinePatches.RandomPatch())) == 32
    @test nfinite(solve(F, patch=AffinePatches.EmbeddingPatch())) ≤ 32
    @test nfinite(solve(F, patch=AffinePatches.OrthogonalPatch())) == 32
end

@testset "solve - no endgame" begin
    F = equations(katsura(5))
    # no endgame
    @test nfinite(solve(F, endgame_start=0.0)) == 32

    @test nfinite(solve(F, endgame_start=0.0, threading=false)) == 32
end

@testset "Path Crossing" begin
    srand(123)
    n = 10_000
    x = [rand(Complex128, 8) for _=1:n]
    for y in x[1:20]
        push!(x, y + (rand(Complex128, 8) .* 1e-9))
    end
    @test sort(Solving.check_crossed_paths(x, 1e-8)) == [collect(1:20); collect(n+1:n+20)]

    F = equations(katsura(5))
    # this will have two crossed paths
    srand(120)
    @test nfinite(solve(F, tol=1e-1, threading=true)) == 32
    srand(120)
    @test nfinite(solve(F, tol=1e-1, threading=false)) == 32
end
