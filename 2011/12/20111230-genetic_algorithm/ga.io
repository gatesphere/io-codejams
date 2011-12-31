#!/usr/local/bin/io

// Genetic algorithm in Io

doFile("../../../lib/ioutils.io")

Genome := list("R", "G", "B")

WorldState := "R" // start with a red world

Copy := .6
Cross := .4
Mutate := .5
Selection := .1

IdGenerator := Object clone do(
  pop ::= 0
  ind ::= 0
  
  clone := method( self ) // singleton
  
  nextPop := method( self setPop(self pop + 1); self pop )
  nextInd := method( self setInd(self ind + 1); self ind )
)


Individual := Object clone do(
  dna ::= ""
  id ::= 0
  
  init := method(
    dna = ""
    id = 0
  )
  
  create := method(
    r := self clone
    r randDna
    r setId(IdGenerator nextInd)
    r
  )
  
  newId := method(
    self setId(IdGenerator nextInd)
    self
  )
  
  randDna := method(
    25 repeat(
      self setDna(self dna asMutable appendSeq(Genome anyOne))
    )
    self
  )

  fitness := method(
    self dna occurancesOfSeq(WorldState) / 25.0
  )

  display := method(
    writeln("  Individual " .. self id .. ": " .. self dna .. " (fitness: " .. self fitness .. ")")
    self
  )
  
  mutate := method(
    self newId
    pos := Random value(0,24) round
    self setDna(self dna asMutable removeSlice(pos,pos) atInsertSeq(pos,Genome anyOne))
    self
  )
  
  cross := method(dad,
    // left half from mom, right half from dad
    child := Individual create
    pos := Random value(0, 24) round
    l := self dna exSlice(0, pos)
    r := dad dna exSlice(pos, 25)
    child setDna(l .. r)
    child
  )
)
  
Population := Object clone do(
  members ::= list
  id ::= 0
  
  init := method(
    members = list
    id = 0
  )
  
  create := method(inds,
    if(inds == nil, inds = list)
    r := self clone
    r setMembers(inds)
    r setId(IdGenerator nextPop)
    r
  )
  
  randMembers := method(num,
    num repeat(self members append(Individual create))
    self
  )
  
  display := method(full,
    if(full,
      writeln("Population " .. self id .. ":")
      self members foreach(ind, 
        ind display
      ),
      write("Population " .. self id .. "--> ")
    )
    writeln("Average fitness: " .. self avgFitness)
    self
  )
  
  avgFitness := method(
    total := 0
    self members foreach(ind,
      total = total + ind fitness
    )
    total / self members size
  )
  
  nextPop := method(
    r := Population create
    r copy(self members)
    r cross(self members)
    r mutate
    r
  )
  
  selection := method(inds,
    candidates := list
    num := inds size * Selection
    num repeat(
      newind := inds anyOne
      while(candidates contains(newind),
        newind := inds anyOne
      )
      candidates append(newind)
    )
    sel := candidates at(0)
    candidates foreach(i,
      if(i fitness > sel fitness,
        sel = i
      )
    )
    sel
  )
  
  copy := method(inds, 
    num := inds size * Copy
    num repeat(
      newind := self selection(inds)
      while(self members contains(newind),
        newind = self selection(inds)
      )
      self members append(newind)
    )
    self
  )
  
  cross := method(inds,
    num := inds size * Cross
    num repeat(
      mom := self selection(inds)
      dad := self selection(inds)
      while(mom == dad, 
        dad = self selection(inds)
      )
      self members append(mom cross(dad))
    )
    self
  )
  
  mutate := method(
    num := self members size * Mutate
    mutants := list
    num repeat(
      candidate := self selection(self members)
      while(mutants contains(candidate),
        candidate = self selection(self members)
      )
      mutants append(candidate)
    )
    mutants foreach(i,
      i mutate
    )
    self
  )
)


  
// run it
writeln("[===RED WORLD===]")
pop := Population create randMembers(50) display(true)
20 repeat(
  pop = pop nextPop display
)
pop display(true)

writeln("[===GREEN WORLD===]")
WorldState = "G"
pop display(true)
30 repeat(
  pop = pop nextPop display
)
pop display(true)

writeln("[===BLUE WORLD===]")
WorldState = "B"
pop display(true)
30 repeat(
  pop = pop nextPop display
)
pop display(true)
