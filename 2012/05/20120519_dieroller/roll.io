#!/usr/bin/env io

// Die roller
// Jacob Peck
// 20120519

Number iota := method(
  l := list
  self repeat(i, l append(i+1))
  l
)

List asString := method(self join(" "))
List count := method(element,
  i := 0
  self foreach(x, if(x == element, i = i + 1))
  i
)
List median := method(
  pos := 0
  if(self size isOdd,
    pos = self size / 2 floor
    return self sort at(pos)
    ,
    pos = self size / 2 - 1
    return (self sort at(pos) + self sort at(pos+1)) / 2
  )
)
List mean := method(self sum / self size)
List mode := method(
  highestcount := 0
  mode := 0
  self foreach(x, if(self count(x) >= highestcount, highestcount = self count(x); mode = x))
  mode
)

Die := Object clone do(
  sides ::= nil
  faces ::= nil
  
  with := method(sides, faces,
    d := self clone
    d setSides(sides)
    if(faces == nil, d setFaces(sides iota), d setFaces(faces))
    d
  )
  
  roll := method(
    self faces at(Random value(0, self sides) floor)
  )
)

// dF
FudgeDie := Die with(6, list(1,1,0,0,-1,-1))

// parse method
parse := method(string, returns,
  if(string containsSeq("d"),
    // die
    toks := string split("d")
    num := toks at(0)
    sides := toks at(1)
    if(num == nil or sides == nil or num asNumber asString != num,
      writeln("Improperly formatted string, ignoring: #{string}" interpolate)
      return
    )
    num = num asNumber
    die := nil
    if(sides == "f" or sides == "F",
      die = FudgeDie
      ,
      die = Die with(sides asNumber)
    )
    num repeat(returns append(die roll))
    return
    ,
    if(string asNumber asString == string,
      // constant
      returns append(string asNumber)
      return
      ,
      // error
      writeln("Improperly formatted string, ignoring: #{string}" interpolate)
      return
    )
  )
)

// analyze method
analyze := method(returns,
  // list them
  writeln("rolled: " .. returns)
  
  // sum
  writeln("sum: " .. returns sum)
  
  // median
  writeln("median: " .. returns median)
  
  // average
  writeln("mean: " .. returns mean)
  
  // mode
  writeln("mode: " .. returns mode)
  
  // min
  writeln("min: " .. returns min)
  
  // max
  writeln("max: " .. returns max)
)

// parse args
args := System args last
args2 := args split("+")

retvals := list

args2 foreach(s, parse(s, retvals))
analyze(retvals)

