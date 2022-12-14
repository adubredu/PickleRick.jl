using Revise 
using PickleRick

obstacle_positions = [[-4.0, 3.5]] 
goal_position = [-3.0, 4.5]
init_joint_positions = zeros(10)
obstacle_radii = 1.0 * ones(length(obstacle_positions))

env = Pickle(obstacle_positions,
                0.5 .* obstacle_radii,
              init_joint_positions,
              zero(init_joint_positions),
              goal_position)

# simulation and visualization settings
env.trail = false
env.show_contacts = false
env.show_goal = false 
env.show_obstacle = false
env.show_com = false 
env.show_support_polygon = true
env.dynamic = false
env.Δt = 1e-3

# create visualization
ax, fig = visualize!(env)

# initial joint positions and velocities
θ = init_joint_positions
θ̇ = zero(init_joint_positions)

# Time Horizon 
T = 1500 # in milliseconds

# PD gains
Kp = 10.0
Kd = 5.0 

# Reference posture
θref = [π/2, 2π/3, π/6, 2π/3, π/6, π/2, π/3, 7π/12, 2π/3, 5π/12]

for i=1:T
    global θ, θ̇
    # PD controller
    θ̈ = Kp*(θref - θ) - Kd*θ̇
    step!(θ̈, env)
    θ = env.θ 
    θ̇ = env.θ̇
    sleep(env.Δt) 
end