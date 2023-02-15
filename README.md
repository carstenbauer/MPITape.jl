# MPITape

```julia
using MPI
using MPITape

function your_mpi_code()
    # Your MPI Code...
end

@record your_mpi_code()
MPITape.print_tape()
```

See `example/` for an actual example which leads to an output like this:

```
With n = 100000 trapezoids, our estimate of the integral from 0.000000 to 1.000000 is 3.333333333500e-01 (exact: 0.333333)
With n = 100000 trapezoids, our estimate of the integral from 0.000000 to 1.000000 is 3.333333333500e-01 (exact: 0.333333)
Rank: 0
	Func: Init  Time: 3.930000000096356e-6
	Func: Send  Time: 2.2599999999428633e-5
	Func: Send  Time: 2.3899999998633348e-5
	Func: Send  Time: 2.3979999999923507e-5
	Func: Send  Time: 2.49299999985908e-5
	Func: Send  Time: 2.4999999999053557e-5
	Func: Send  Time: 2.5149999999030115e-5
	Func: Send  Time: 2.5299999999006673e-5
	Func: Send  Time: 2.544999999898323e-5
	Func: Send  Time: 2.558999999990874e-5
	Func: Send  Time: 2.57399999998853e-5
	Func: Send  Time: 2.5859999999156003e-5
	Func: Send  Time: 2.5939999998669805e-5
	Func: Recv  Time: 8.31609999991656e-5
	Func: Recv  Time: 9.624099999960833e-5
	Func: Recv  Time: 9.677099999905181e-5
	Func: Recv  Time: 0.00010024100000016745

Rank: 1
	Func: Init  Time: 1.0639999999284555e-5
	Func: Recv  Time: 1.494999999884783e-5
	Func: Recv  Time: 2.8079999999874872e-5
	Func: Recv  Time: 3.1749999999775014e-5
	Func: Send  Time: 9.466100000032895e-5

Rank: 2
	Func: Init  Time: 1.0640000001060912e-5
	Func: Recv  Time: 1.5280000001283156e-5
	Func: Recv  Time: 2.818000000104348e-5
	Func: Recv  Time: 3.0770000000401865e-5
	Func: Send  Time: 9.454100000105825e-5

Rank: 3
	Func: Init  Time: 1.0140000000546934e-5
	Func: Recv  Time: 1.5109999999651791e-5
	Func: Recv  Time: 3.013999999978978e-5
	Func: Recv  Time: 3.2969999999465927e-5
	Func: Send  Time: 9.881100000086462e-5

Rank: 4
	Func: Init  Time: 1.0120000000668483e-5
	Func: Recv  Time: 1.4730000000184873e-5
	Func: Recv  Time: 2.8920000000098867e-5
	Func: Recv  Time: 3.209000000126139e-5
	Func: Send  Time: 9.605099999987488e-5
```
