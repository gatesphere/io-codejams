#!/usr/local/bin/io
// Empire game

//doFile("../lib/ioutils.io")

Object squareBrackets := method(
  l := list()
  call message arguments foreach(arg,
    l append(l doMessage(arg))
  )
  l
)

List squareBrackets := method(index,
  self at(call evalArgAt(0))
)

OperatorTable addAssignOperator(":" , "atPutValue" )

Map atPutValue := method(
  self atPut(
    call evalArgAt(0) asMutable removePrefix("\"") removeSuffix("\"" ),
    call evalArgAt(1)
  )
)

curlyBrackets := method(
  r := Map clone
  call message arguments foreach(arg,
    r doMessage(arg)
  )
  r
)

Map squareBrackets := method(
  self at(call evalArgAt(0))
)


Game := Object clone do(
  players ::= list
  
  play := method(
    20 repeat(
      w := self weather
      self players foreach(player,
        player turn(w)
      )
    )
  )
  
  addPlayer := method(player,
    self players append(player)
    self
  )
  
  weather := method(
    Random value(1,6) round
  )
)

Player := Object clone do(
  stats := nil
  
  init := method(
    stats = Map clone
    stats atPut("grain",2000)
    stats atPut("land",10000)
    stats atPut("cash",5000)
    stats atPut("peasants",500)
    stats atPut("army",20)
    stats atPut("farms",1)
    stats atPut("cities",1)
    stats atPut("palace",5)
    stats atPut("tax",2)
  )
  
  // this doesn't work for some reason, probably scoping
  /*
  init := method(
    stats = {
      "grain" : 2000,
      "land" : 10000,
      "cash" : 5000,
      "peasants" : 500,
      "army" : 20,
      "farms" : 1,
      "cities" : 1,
      "palace" : 5,
      "tax" : 2
    }
  )
  */ 
  
  turn := method(weather,
    self weatherreport(weather)
    self generategrain(weather)
    self feed
    self generateincome(weather)
    self purchase
    self war(weather)
    self displaystats
  )
  
  weatherreport := method(weather,
    writeln("Weather report for this year:")
    if(weather == 1, writeln("Good year."))
    if(weather == 2, writeln("Heavy rains."))
    if(weather == 3, writeln("Drought."))
    if(weather == 4, writeln("Flooding."))
    if(weather == 5, writeln("Great year!"))
    if(weather == 6, writeln("Bitter cold year."))
  )
  
  generategrain := method(weather,
    old := self stats["grain"]
    curr := self stats["grain"]
    curr = curr * 1.1
    curr = curr + (self stats["farms"] * 200)
    if(weather == 2 or weather == 3 or weather == 4 or weather == 5,
      curr = curr * 0.8
    )
    curr = curr round
    self stats atPut("grain",curr)
    delta := curr - old
    if(delta < 0, 
      writeln("Lost " .. -delta .. " grain this year.  Total grain: " .. curr),
      writeln("Produced " .. delta .. " grain this year.  Total grain: " .. curr)
    )
  )
  
  feed := method()
  generateincome := method(weather, nil)
  purchase := method()
  war := method(weather, nil)
  displaystats := method()
)



g := Game clone addPlayer(Player clone) addPlayer(Player clone)
g play

