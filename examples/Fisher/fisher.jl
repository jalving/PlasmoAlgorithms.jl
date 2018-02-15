using JuMP
using Gurobi
using Plasmo

## Model from Fisher,1985. An Applications Oriented Guide to Lagrangian Relaxation
# Max 16x[1] + 10x[2] + 4y[2]
# s.t. x[1] + x[2] <= 1
#      y[1] + y[2] <= 1
#      8x[1] + 2x[2] + y[2] + 4y[2] <= 10
#      x, y ∈ {0,1}

## Model on x
# Min 16x[1] + 10x[2]
# s.t. x[1] + x[2] <= 1OutputFlag=0
#      x ∈ {0,1}
m1 = Model(solver=GurobiSolver())

@variable(m1, x[i in 1:2],Bin)
@constraint(m1, x[1] + x[2] <= 1)
@objective(m1, Max, 16x[1] + 10x[2])

## Model on y`
# Max  4y[2]
# s.t. y[1] + y[2] <= 1
#      8x[1] + 2x[2] + y[2] + 4y[2] <= 10
#      x, y ∈ {0,1}

m2 = Model(solver=GurobiSolver())

@variable(m2, x[i in 1:2],Bin)
@variable(m2, y[i in 1:2], Bin)
@constraint(m2, y[1] + y[2] <= 1)
@constraint(m2, 8x[1] + 2x[2] + y[2] + 4y[2] <= 10)
@objective(m2, Max, 4y[2])

## Plasmo Graph
g = PlasmoGraph()
g.solver = GurobiSolver()
n1 = add_node(g)
setmodel(n1,m1)
n2 = add_node(g)
setmodel(n2,m2)


## Linking
# m1[x] = m2[x]  ∀i ∈ {1,2}
@linkconstraint(g, [i in 1:2], n1[:x][i] == n2[:x][i])
