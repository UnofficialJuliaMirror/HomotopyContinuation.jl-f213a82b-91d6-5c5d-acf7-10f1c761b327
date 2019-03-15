using Test, LinearAlgebra, Random
using DynamicPolynomials, HomotopyContinuation, StaticArrays
import TreeViews, ProjectiveVectors, PolynomialTestSystems

import PolynomialTestSystems: cyclic, katsura, equations, ipp2, heart
const HC = HomotopyContinuation

function test_treeviews(x)
    @test TreeViews.hastreeview(x)
    @test_nowarn TreeViews.treelabel(devnull, x, MIME"application/prs.juno.inline"())
    for i=1:TreeViews.numberofnodes(x)
        @test_nowarn TreeViews.nodelabel(devnull, x, i, MIME"application/prs.juno.inline"())
        @test_nowarn TreeViews.treenode(x, i)
    end
end

# We order the tests such that isolated things are tested first
@testset "HomotopyContinuation" begin
    include("utilities_test.jl")
    include("affine_patches_test.jl")
    include("problem_test.jl")
    include("systems_test.jl")
    include("homotopies_test.jl")
    include("predictors_test.jl")
    include("correctors_test.jl")
    include("path_tracking_test.jl")
    include("solve_test.jl")
    include("result_test.jl")
    include("integration_tests.jl")
    include("monodromy_test.jl")
    include("guides_tests.jl")
end
