using JuMP
using Gurobi
using Plasmo
using PlasmoAlgorithms

mp = Model(solver = GurobiSolver())
sp1 = Model(solver = GurobiSolver())
sp2 = Model(solver = GurobiSolver())
sp3 = Model(solver = GurobiSolver())

@variable(mp,x[1:2]>=0)
@constraint(mp,x[1]+x[2]>=50)
@objective(mp,Min,x[1]+2x[2])

@variable(sp1,x[1:2]>=0)
@variable(sp1,y[1:2]>=0)
@constraint(sp1, x[1]+y[1]>=60)
@constraint(sp1, x[2]+y[2]>=70)
@objective(sp1, Min, 3y[1]+4y[2])

@variable(sp2,y[1:2]>=0)
@variable(sp2, z[1:2]>=0)
@constraint(sp2, y[1]+z[1]>=80)
@constraint(sp2, y[2]+z[2]>=90)
@objective(sp2, Min, 5z[1]+6z[2])

@variable(sp3,x[1:2]>=0)
@variable(sp3,t[1:2]>=0)
@constraint(sp3,x[1]+t[2]>=43)
@constraint(sp3,x[2]+t[1]>=75)
@objective(sp3,Min,.5t[1]+5t[2])

g = ModelGraph()
setsolver(g, GurobiSolver())
n1 = add_node(g)
n2 = add_node(g)
n3 = add_node(g)
n4 = add_node(g)

setmodel(n1, mp)
setmodel(n2, sp1)
setmodel(n3, sp2)
setmodel(n4, sp3)

edge1 = Plasmo.add_edge(g,n1,n2)
edge2 = Plasmo.add_edge(g,n2,n3)
edge2 = Plasmo.add_edge(g,n1,n4)



@linkconstraint(g,[i in 1:2], n1[:x][i] == n2[:x][i])
@linkconstraint(g,[i in 1:2], n1[:x][i] == n4[:x][i])
@linkconstraint(g,[i in 1:2], n2[:y][i] == n3[:y][i])

bendersolve(g,max_iterations =10)
