#!/usr/local/bin/io

c := CellularAutomata with(71,90) // rule 90

for (i, 0, 70, c cells atPut(i,false))
c cells atPut(35,i)

c display
500 repeat(c iterate display)
