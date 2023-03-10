using Plots
using Kroki

function _plot_edges(edges::Array{Tuple{MPIEvent, MPIEvent}})
    for (src, dst) in edges
        plot!([src.t_end, dst.t_end], [src.rank, dst.rank], arrow = true, color = :black,
              label = "")
    end
end

function _event_to_rect(ev::MPIEvent; color = :blue)
    plot!(Shape([ev.t_start, ev.t_end, ev.t_end, ev.t_start],
                [ev.rank - 0.25, ev.rank - 0.25, ev.rank + 0.25, ev.rank + 0.25]),
          color = color,
          label = "")
end

"""
$(SIGNATURES)
Plots a gantt chart of the recorded MPI API calls and store it to a file.
Additionally draws arrows between communicating `MPIEvent`s.


"""
function plot_merged(tape::Array{MPIEvent}; palette = palette(:Accent_8),
                     fname = "gantt.png")
    plot()
    unique_calls = unique([ev.f for ev in tape])
    for mpievent in tape
        _event_to_rect(mpievent,
                       color = palette[findall(x -> x == mpievent.f, unique_calls)[1]])
    end
    for (col, call) in zip(palette[1:length(unique_calls)], unique_calls)
        plot!(Shape([0], [0]), color = col, label = string(call))
    end
    edges = get_edges(tape)
    _plot_edges(edges)
    Plots.xlabel!("Execution time [s]")
    Plots.ylabel!("MPI Rank")
    Plots.savefig(fname)
    nothing
end

function _generate_plantuml(edges)
    str_edge = ""
    sorted_edges = sort(edges; by = e -> max(e[1].t_end, e[2].t_end))
    for (s, d) in sorted_edges
        str_edge *= "Rank_$(s.rank) -> Rank_$(d.rank) : $(string(s.f))\n"
    end
    return str_edge
end

"""
$(SIGNATURES)
Plot a sequence diagram of the communication between ranks using the communication graph created by `get_edges`.

Creates a plot of the following form using Kroki.jl:

┌──────┐          ┌──────┐          ┌──────┐          ┌──────┐          ┌──────┐
│Rank_0│          │Rank_1│          │Rank_2│          │Rank_3│          │Rank_4│
└──┬───┘          └──┬───┘          └──┬───┘          └──┬───┘          └──┬───┘
   │     MPI_Send    │                 │                 │                 │    
   │ ────────────────>                 │                 │                 │    
   │                 │                 │                 │                 │      
   │              MPI_Send             │                 │                 │    
   │ ──────────────────────────────────>                 │                 │    
   │                 │                 │                 │                 │    
   │                 │     MPI_Send    │                 │                 │    
   │ ────────────────────────────────────────────────────>                 │                
   │                 │                 │                 │                 │    
   │                 │              MPI_Send             │                 │    
   │ ──────────────────────────────────────────────────────────────────────>       
   │                 │                 │                 │                 │    
   │     MPI_Send    │                 │                 │                 │    
   │ <────────────────                 │                 │                 │    
   │                 │                 │                 │                 │    
   │              MPI_Send             │                 │                 │    
   │ <──────────────────────────────────                 │                 │    
   │                 │                 │                 │                 │    
   │                 │     MPI_Send    │                 │                 │    
   │ <────────────────────────────────────────────────────                 │    
   │                 │                 │                 │                 │    
   │                 │              MPI_Send             │                 │    
   │ <──────────────────────────────────────────────────────────────────────    
┌──┴───┐          ┌──┴───┐          ┌──┴───┐          ┌──┴───┐          ┌──┴───┐
│Rank_0│          │Rank_1│          │Rank_2│          │Rank_3│          │Rank_4│
└──────┘          └──────┘          └──────┘          └──────┘          └──────┘
"""
function plot_sequence_merged(tape)
    edges = get_edges(tape)
    return plantuml"$(_generate_plantuml(edges))"
end
