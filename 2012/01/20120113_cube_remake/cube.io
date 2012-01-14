#!/usr/bin/env io

// Cube remake
// Original: http://www.atariarchives.org/basicgames/showpage.php?page=53

Cube := Object clone do(
  mines := list
  pos := list(1,1,1)
  money := 500
  bet := 0
  
  generateVertex := method(
    x := Random value(1,3) round
    y := Random value(1,3) round
    z := Random value(1,3) round
    list(x,y,z)
  )
  
  randomizeMines := method(
    self mines = list
    while(self mines size < 5,
      vertex := self generateVertex
      while(vertex == list(1,1,1) or vertex == list(3,3,3),
        vertex = self generateVertex
      )
      self mines appendIfAbsent(vertex)
    )
    self
  )
  
  reset := method(
    self pos = list(1,1,1)
    self randomizeMines
    self bet = 0
    self
  )
  
  canMove := method(move,
    if(move == self pos, return false)
    move foreach(i,
      if(i < 1 or i > 3, return false)
    )
    delta := list
    self pos foreach(i, x,
      delta append((x - move at(i)) abs)
    )
    if(delta sum == 1, return true, return false)
  )
  
  move := method(move,
    self pos = move
  )
  
  intro := method(
    writeln("                    CUBE")
    writeln("CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY")
    writeln
  )
  
  instructions := method(
    writeln("   DO YOU WANT TO SEE THE INSTRUCTIONS? (YES--1,NO--0)")
    write("   ? ")
    in := File standardInput readLine asNumber
    if(in == 0, return)
    writeln("   THIS IS A GAME IN WHICH YOU WILL BE PLAYING AGAINST THE")
    writeln("   RANDOM DECISION OF THE COMPUTER. THE FIELD OF PLAY IS A")
    writeln("   CUBE OF SIDE 3. ANY OF THE 27 LOCATIONS CAN BE DESIGNATED")
    writeln("   BY INPUTING THREE NUMBERS SUCH AS 2,3,1.  AT THE START,")
    writeln("   YOU ARE AUTOMATICALLY AT LOCATION 1,1,1.  THE OBJECT OF")
    writeln("   THE GAME IS TO GET TO LOCATION 3,3,3. ONE MINOR DETAIL,")
    writeln("   THE COMPUTER WILL PICK, AT RANDOM, 5 LOCATIONS AT WHICH")
    writeln("   IT WILL PLANT LAND MINES.  IF YOU HIT ONE OF  THESE LOCATIONS")
    writeln("   YOU LOSE.  ONE OTHER DETAIL, YOU MAY MOVE ONLY ONE SPACE")
    writeln("   IN ONE DIRECTION EACH MOVE.  FOR EXAMPLE, FROM 1,1,2 YOU")
    writeln("   MAY  MOVE TO 2,1,2 OR 1,1,3.  YOU MAY NOT CHANGE")
    writeln("   TWO OF THE NUMBERS ON THE SAME MOVE.  IF YOU MAKE  AN ILLEGAL")
    writeln("   MOVE, YOU LOSE AND THE COMPUTER TAKES THE MONEY YOU MAY")
    writeln("   HAVE BET ON THAT ROUND.")
    writeln
    writeln
    writeln("   ALL YES OR NO QUESTIONS WILL BE ANSWERED BY A 1 FOR YES")
    writeln("   OR A 0 (ZERO) FOR NO.")
    writeln
    writeln("   WHEN STATING THE AMOUNT OF A WAGER, PRINT ONLY THE NUMBER")
    writeln("   OF DOLLARS (EXAMPLE: 250)  YOU ARE AUTOMATICALLY STARTED WITH")
    writeln("   500  DOLLAR AMOUNT.")
  )
  
  greeting := method(
    writeln
    writeln("   GOOD LUCK")
  )
  
  wager := method(
    writeln("   WANT TO MAKE A WAGER?")
    write("   ? ")
    in := File standardInput readLine asNumber
    if(in == 0, self bet = 0; writeln;return)
    writeln("   HOW MUCH?")
    write("   ? ")
    self bet = (File standardInput readLine asNumber round) abs
    writeln
  )
  
  play := method(
    writeln("   IT'S YOUR MOVE")
    move := self promptForMove
    loop(
      if(self canMove(move),
        self move(move),
        break
      )
      if(self pos == list(3,3,3), break)
      if(self mines contains(self pos), break)
      writeln("   NEXT MOVE")
      move = self promptForMove
    )
    if(self pos == list(3,3,3), 
      self win,
      self lose
    )
  )
  
  promptForMove := method(
    write("   ? ")
    in := File standardInput readLine
    x := in exSlice(0,2) asNumber
    y := in exSlice(2,4) asNumber
    z := in exSlice(4,6) asNumber
    list(x,y,z)
  )
  
  win := method(
    writeln("   CONGRATULATIONS")
    self money = self money + self bet
    writeln("   YOU NOW HAVE " .. self money .. " DOLLARS")
  )
  
  lose := method(
    writeln("   ******BANG******")
    writeln("   YOU LOSE")
    self money = self money - self bet
    writeln("    YOU NOW HAVE " .. self money .. " DOLLARS")
  )
  
  again := method(
    writeln("   DO YOU WANT TO TRY AGAIN?")
    write("   ? ")
    in := File standardInput readLine asNumber
    in == 1
  )
  
  bye := method(
    writeln("   TOUGH LUCK")
    writeln
    writeln("    GOODBYE")
  )
  
  game := method(
    self intro
    self instructions
    self greeting
    loop := true
    while(loop,
      self reset
      self wager
      self play
      loop = self again
    )
    self bye
  )
)

Cube game
