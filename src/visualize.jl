function visualize!(env::Pickle)
    object_positions = env.o 
    obstacle_radii = env.r*2
    goal_position = env.g
    fig = Figure()
    ax = Axis(fig[1,1], aspect=DataAspect(), limits=(-5.,5.,-1.,5.)) 
    obstacle_observables = []
    for (i, ob) in enumerate(object_positions)  
        ox =  Observable(SVector{2,Float64}(ob...))
        if env.show_obstacle scatter!(ax, ox; marker=:circle, 
            markersize=obstacle_radii[i], markerspace=SceneSpace, 
            color=:black) end
        push!(obstacle_observables, ox)
        if env.show_contacts
            keypoints = get_keypoints(collect(ox.val), 0.5*obstacle_radii[i],N=8) 
            scatter!(ax, [k[1] for k in keypoints], [k[2] for k in keypoints]; 
            marker=:circle, markerspace=SceneSpace, markersize=0.25, color=:red) 
        end
    end 

    θ = env.θ 
    chains = link_poses(θ, env)
    chain1 = Observable([SVector(a[1], a[2]) for a in chains[1]])
    chain2 = Observable([SVector(a[1], a[2]) for a in chains[2]])
    chain3 = Observable([SVector(a[1], a[2]) for a in chains[3]])
    chain4 = Observable([SVector(a[1], a[2]) for a in chains[4]])
    chain5 = Observable([SVector(a[1], a[2]) for a in chains[5]])
    head = Observable([SVector(chains[3][3][1], chains[3][3][2])])

    lines!(ax, chain1; linewidth=5, color=:purple)
    lines!(ax, chain2; linewidth=5, color=:purple)
    lines!(ax, chain3; linewidth=5, color=:purple)
    lines!(ax, chain4; linewidth=5, color=:purple)
    lines!(ax, chain5; linewidth=5, color=:purple)

    scatter!(ax, chain1; marker=:circle, color=:black, markersize=0.2, markerspace=SceneSpace)
    scatter!(ax, chain2; marker=:circle, color=:black, markersize=0.2, markerspace=SceneSpace)
    scatter!(ax, chain3; marker=:circle, color=:black, markersize=0.2, markerspace=SceneSpace)
    scatter!(ax, chain4; marker=:circle, color=:black, markersize=0.2, markerspace=SceneSpace)
    scatter!(ax, chain5; marker=:circle, color=:black, markersize=0.2, markerspace=SceneSpace)
    scatter!(ax, head; marker=:circle, color=:black, markersize=0.6, markerspace=SceneSpace)
     
    ocom = nothing
    if env.show_com
        com = compute_COM(θ, env)
        ocom = Observable(SVector{2, Float64}(com...))
        # proj = Observable([SVector{2, Float64}(com...), SVector{2, Float64}(com[1], 0.0)])
        # lines!(ax, proj; linewidth=5, color=:black)
        scatter!(ax, ocom; marker=:circle, markersize=0.5, markerspace=SceneSpace, color=:red)
    end

    if env.show_support_polygon
        c = to_color(:grey)
        col = RGBA(c.r, c.g, c.b, 0.5) 
        lines!(ax, [-env.w, env.w], [0, 0]; linewidth=5, color=col)
    end

    if env.show_goal 
        scatter!(ax, [goal_position[1]], [goal_position[2]]; marker=:circle, markersize=0.5, markerspace=SceneSpace, color=:green)
    end

    env.body_observables = [chain1, chain2, chain3, chain4, chain5, head]
    env.obstacle_observables = obstacle_observables 
    env.com_observable = ocom
    hidedecorations!(ax)
    display(fig)
    return ax, fig
end