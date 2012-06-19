#!/usr/bin/env io

// Enigma machine approximation
// Jacob Peck
// 20120618

List opp := method(x,
  self reverse at(self indexOf(x))
)

Rotor := Object clone do(
  wiring := nil // list
  notches := nil // list
  position := 0  // number
  next ::= nil  // rotor
  prev ::= nil // rotor
  
  initialWiring := nil
  initialNotches := nil
  initialPosition := nil
  
  setWiring := method(val,
    self wiring = val
    self initialWiring = val clone
    self
  )
  
  setNotches := method(val,
    self notches = val
    self initialNotches = val clone
    self
  )
  
  setPosition := method(val,
    self position = val
    self initialPosition = val clone
    self
  )
  
  reset := method(
    self position = self initialPosition
    self notches = self initialNotches
    self wiring = self initialWiring
    self reorder(self position)
    writeln(self)
    self
  )
  
  init := method(
    self wiring = nil
    self notches = nil
    self position = 0
    self next = nil
    self prev = nil
    initialWiring = nil
    initialNotches = nil
    initialPosition = nil
  )
  
  with := method(w, n, p,
    self clone setWiring(w) setNotches(n) setPosition(p) reorder(p)
  )
  
  turn := method(
    writeln(" Turning.  New position: " .. self position + 1)
    self position = (self position + 1) % 26
    self reorder
    if(self notches contains(self position), next turn)
    self
  )

  reorder := method(p,
    a := self wiring removeFirst
    self wiring push(a)
    if(p != nil and p != 0, self reorder(p-1))
    self
  )

  map := method(in,
    writeln("  map: " .. in .. "->" .. self wiring opp(in))
    self next map(self wiring opp(in))
  )
  
  mapback := method(in,
    writeln("  mapback: " .. in .. "->" .. self wiring reverse opp(in))
    self prev mapback(self wiring reverse opp(in))
  )
  
  asString := method(
    "<ROTOR " .. self position .. " " .. self wiring .. ">"
  )
)

Reflector := Rotor clone do(
  turn := method(self)
  
  // wiring of the "C" model
  wiring = list(5,21,15,9,8,0,14,24,4,3,17,25,23,22,6,2,19,10,20,16,18,1,13,12,7,11)
  
  turn := nil
  
  position = 0
  
  map := method(in,
    writeln(" reflecting: " .. in .. "->" .. self wiring opp(in))
    self prev mapback(self wiring opp(in))
  )
  
)
 
Input := Object clone do(
  next ::= nil
  turn := method( next turn; self )
  map := method(in,
    next map(in)
  )
)

Output := Object clone do(
  mapback := method(in, 
    (in + 65) asCharacter
  )
)

Plugboard := Object clone do(
  wiring := Map clone
  next := nil
  prev := nil
  
  turn := method(next turn)
  
  map := method(in,
    writeln("plugging")
    if(self wiring at(in asString) != nil,
      self next map(self wiring at(in asString))
      ,
      self next map(in)
    )
  )
  
  mapback := method(in, 
    if(self wiring at(in asString) != nil,
      self prev mapback(self wiring at(in asString))
      ,
      self prev mapback(in)
    )
  )
  
  addPlug := method(a, b,
    self wiring atPut(a asString, b)
    self wiring atPut(b asString, a)
    self
  )
)
      
rotor1 := Rotor with(list(4,10,12,5,11,6,3,16,21,25,13,19,14,22,24,7,23,20,18,15,0,8,1,17,2,9), list(12), 10)
rotor2 := Rotor with(list(0,9,3,10,18,8,17,20,23,1,11,7,22,19,12,2,16,6,25,13,15,24,5,21,14,4), list(5), 0)
rotor3 := Rotor with(list(1,3,5,7,9,11,2,15,17,19,23,21,25,13,24,4,8,22,6,0,10,12,20,18,16,14), list(2), 0)

// set up the circuit
Input next = Plugboard
Plugboard next = rotor1
rotor1 next = rotor2
rotor2 next = rotor3
rotor3 next = Reflector
Reflector prev = rotor3
rotor3 prev = rotor2
rotor2 prev = rotor1
rotor1 prev = Plugboard
Plugboard prev = Output

Plugboard addPlug(0,10) addPlug(3,13) addPlug(20, 23) addPlug(12, 16)

// encode a message
encode := method(s,
  out := ""
  s foreach(i,
    x := i - 65
    b := Input turn map(x)
    out = out asMutable appendSeq(b)
    writeln(i asCharacter .. "->" .. b)
    c := Input map(b at(0) - 65)
    writeln(b .. "->" .. c .. "\n")
  )
  out
)

a := encode("HELLOXWORLD")

//writeln(a)

rotor1 reset
rotor2 reset
rotor3 reset

b := encode(a)

writeln("encrypted: " .. a)
writeln("decrypted: " .. b)
writeln("Do they match? ", "HELLOXWORLD" == b) 
