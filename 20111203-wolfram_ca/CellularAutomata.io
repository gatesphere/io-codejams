// 1-dimensional Wolfram-style cellular automata
// Jacob Peck
// 20111204

CellularAutomata := Object clone do(
  // state
  cells ::= list()
  generation ::= 0
  rule ::= nil
  
  // constructor
  init := method(
    cells = list()
    generation = 0
    rule = nil
  )
  
  with := method(n, rule,
    ret := self clone
    ret cells = ret setupCells(n)
    if(rule < 0, rule = 0)
    if(rule > 255, rule = 255)
    ret rule = rule
    ret
  )
  
  // methods
  age := method(self generation)
  
  setupCells := method(n,
    l := list()
    n repeat(
      l append(Random flip)
    )
    l
  )
  
  println := method(
    writeln("[" .. self cells join(", ") .. "]")
  )
  
  display := method(
    write("[")
    self cells foreach(x,
      if(x, write("X"), write("_"))
    )
    writeln("]")
  )
  
  iterate := method(
    self generation = self generation + 1
    oldworld := self cells clone
    rules := list(
      (self rule & 128) == 128,
      (self rule & 64) == 64,
      (self rule & 32) == 32,
      (self rule & 16) == 16,
      (self rule & 8) == 8,
      (self rule & 4) == 4,
      (self rule & 2) == 2,
      (self rule & 1) == 1
    )
    oldworld foreach(x, cell,
      ln := nil
      rn := nil
      if(x == 0, ln = oldworld at(oldworld size - 1), ln = oldworld at(x - 1))
      if(x == oldworld size - 1, rn = oldworld at(0), rn = oldworld at(x + 1))
      //writeln(ln .. " " .. cell .. " " .. rn) // debug
      if(ln,
        if(cell,
          if(rn,
            self cells atPut(x, rules at(0)), // 111
            self cells atPut(x, rules at(1))  // 110
          ),
          if(rn,
            self cells atPut(x, rules at(2)), // 101
            self cells atPut(x, rules at(3))  // 100
          )
        ),
        if(cell,
          if(rn,
            self cells atPut(x, rules at(4)), // 011
            self cells atPut(x, rules at(5))  // 010
          ),
          if(rn,
            self cells atPut(x, rules at(6)), // 001
            self cells atPut(x, rules at(7))  // 000
          )
        )
      )
    )
    self
  )
  
  
)