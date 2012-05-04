#!/usr/bin/env/ io

// HQ9F++ interpreter
// Jacob Peck
// HQ9F++ is an extension of HQ9++, which is an extension of HQ9+

VM := Object clone do(
  clone := method(self)
  accumulator := 0
  
  h := method(
    writeln("Hello World.")
    self
  )
  
  q := method(in,
    writeln(in)
    self
  )
  
  nine := method(
    100 repeat(i,
      num := 100 - i
      bottles := "bottles"
      if(num == 1, bottles := "bottle")
      nextnum := num - 1
      bottles2 := "bottles"
      if(nextnum == 1, bottles2 = "bottle")
      if(nextnum == 0, nextnum = "No more")
      writeln("#{num} #{bottles} of beer on the wall,\n#{num} #{bottles} of beer" interpolate)
      writeln("take one down, pass it around,")
      writeln("#{nextnum} #{bottles2} of beer on the wall.\n" interpolate)
    )
    self
  )
  
  f := method(
    for(i, 1, 100,
      out := i
      if(i % 3 == 0, out = "Fizz")
      if(i % 5 == 0, out = "Buzz")
      if(i % 15 == 0, out = "FizzBuzz")
      writeln(out)
    )
    self
  )
  
  plus := method(
    self accumulator = self accumulator + 1
    self
  )
  
  plusplus := method(
    self extend plus plus
    self
  )
  
  extend := method(
    name := ""
    8 repeat(
      r := Random value(65, 116) round
      if(r > 90, r = r + 6)
      name asMutable appendSeq(r asCharacter)
    )
    name asMessage := Object clone
    self
  )
  
  initialize := method(
    self accumulator = 0
  )
)
    
REPL := Object clone do(
  rl := ReadLine
  hist_file := ".hq9fplusplus_history"
  version := "May 2012"
  
  initialize := method(
    VM initialize
    self rl prompt = "HQ9F++> "
    self read_history
    self welcome
    self
  )
  
  read_history := method(
    try(
      self rl loadHistory(self hist_file)
    )
  )
  
  save_history := method(
    try(
      self rl saveHistory(self hist_file)
    )
  )
  
  welcome := method(
    writeln("Welcome to HQ9F++, version #{version}.  To exit, enter \"!!exit\"" interpolate)
    self
  )
  
  goodbye := method(
    writeln("Goodbye.")
  )
  
  run := method(file,
    if(file != nil,
      try(
        f := File with(file) openForReading
        self interpret(f contents)
      )
      ,
      self initialize
      loop(
        in := self rl readLine(self rl prompt)
        if(in asUppercase asMutable strip == "!!EXIT", break)
        self interpret(in)
        self rl addHistory(in)
      )
      self save_history
      self goodbye
    )
  )
  
  interpret := method(in,
    pc := 0
    while(pc < in size,
      x := in at(pc)
      if(x asCharacter asUppercase == "H", VM h)
      if(x asCharacter asUppercase == "Q", VM q(in))
      if(x asCharacter asUppercase == "9", VM nine)
      if(x asCharacter asUppercase == "F", VM f)
      if(x asCharacter asUppercase == "+",
        if(in at(pc + 1) != nil and in at(pc + 1) asCharacter asUppercase == "+",
          VM plusplus
          pc = pc + 1
          ,
          VM plus
        )
      )
      pc = pc + 1
    )
  )
)

REPL run(System args at(1))
