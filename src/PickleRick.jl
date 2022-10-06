module PickleRick

using WGLMakie 
using DataStructures: CircularBuffer 
using LinearAlgebra
using StaticArrays
using Colors 

include("types.jl")
include("visualize.jl") 
include("kinematics.jl")
include("dynamics.jl")
include("simulate.jl")

export Pickle

export compute_COM,
        link_poses,
        step!,
        visualize!

end
