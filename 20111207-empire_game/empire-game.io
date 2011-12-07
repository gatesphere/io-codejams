// Empire game

// to do:
// war
// displaystats
// end conditions
// clean up output


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
  name ::= nil
  
  init := method(
    stats = {
      "grain" : 2000,
      "peasants" : 500,
      "land" : 10000,
      "cash" : 5000,
      "army" : 20,
      "farms" : 1,
      "cities" : 1,
      "palace" : 5,
      "tax" : 2
    }
  )
  
  
  turn := method(weather,
    self check
    self weatherreport(weather)
    self check
    self generategrain(weather)
    self check
    self feed
    self check
    self generateincome(weather)
    self check
    self purchase
    self check
    self war(weather)
    self check
    self displaystats
    self check
  )
  
  check := method() // check for end conditions
  
  weatherreport := method(weather,
    writeln(self name .. " --> Phase 1: Weather report for this year:")
    if(weather == 1, writeln("    Good year."))
    if(weather == 2, writeln("    Heavy rains."))
    if(weather == 3, writeln("    Drought."))
    if(weather == 4, writeln("    Flooding."))
    if(weather == 5, writeln("    Great year!"))
    if(weather == 6, writeln("    Bitter cold year."))
  )
  
  generategrain := method(weather,
    writeln(self name .. " --> Phase 2: Generate grain:")
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
      writeln("    Lost " .. -delta .. " grain this year.  Total grain: " .. curr),
      writeln("    Produced " .. delta .. " grain this year.  Total grain: " .. curr)
    )
  )
  
  feed := method(
    writeln(self name .. " --> Phase 3: Feed peasants:")
    writeln("    You must feed your people.")
    req := self stats["peasants"] * 5
    writeln("    Your people need " .. req .. " grain to not starve.")
    write("    How much grain will you give them (you have " .. self stats["grain"] .. ")?  ")
    togive := File standardInput readLine asNumber
    if (togive > self stats["grain"], 
      writeln("      You don't have that much grain!"); 
      self feed;
      break,
      if (togive < 0, 
        writeln("      You can't take grain from your people!");
        self feed;
        break,
        self stats atPut("grain", self stats["grain"] - togive)
      )
    )
    percentage := togive / req
    old := self stats["peasants"]
    curr := old
    curr = curr * percentage
    curr = curr + (curr * ((20 - self stats["tax"])/100)) // tax penalty
    curr = curr round
    self stats atPut("peasants", curr)
    delta := curr - old
    if(delta < 0,
      writeln("    " .. -delta .. " people died of malnutrition and strenuous labor.  Total peasants: " .. curr), 
      writeln("    " .. delta .. " new babies were born!  Total peasants: " .. curr)
    )
  )
  
  generateincome := method(weather,
    writeln(self name .. " --> Phase 4: Generate income:")
    curr := self stats["cash"]
    old := curr
    curr = curr + (curr * (.5 * (self stats["peasants"] / (self stats["cities"]  * 100))))
    if(weather == 2 or weather == 4 or weather == 6,
      curr = curr * .8
    )
    curr = curr + (curr * (self stats["tax"] / 100))
    curr = curr round
    if (curr < old, curr = old)
    self stats atPut("cash",curr)
    delta := curr - old
    writeln("    Your cities have generated " .. delta .. " income this year.  Total income: " .. curr)
    write("    Please set the tax rate for next year (as a whole number):  ")
    tax := File standardInput readLine asNumber
    if(tax < 0,
      writeln("      Setting tax to 0%."); tax = 0,
      if(tax > 100,
        writeln("      Setting tax to 100%."); tax = 100,
        writeln("      Setting tax to " .. tax .. "%.")
      )
    )
    self stats atPut("tax",tax)
  )
  
  purchase := method(
    writeln(self name .. " --> Phase 5: Purchase:")
    writeln("\tItem\t\tCost\t\t\tYou Possess")
    writeln("\t---------------------------------------------------")
    writeln("\tArmy\t\t20 gold\t\t\t" .. self stats["army"])
    writeln("\tCity\t\t2000 gold\t\t" .. self stats["cities"])
    writeln("\tFarm\t\t500 gold\t\t" .. self stats["farms"])
    writeln("\tPalace\t\t5000 gold per 5%\t" .. self stats["palace"] .. "% complete")
    
    write("    Purchase how many Armies (at 20 each, can afford " .. (self stats["cash"]/20) floor .. ")?  ")
    army := File standardInput readLine asNumber
    if (army < 0, army = 0)
    if (army * 20 > self stats["cash"], 
      writeln("      Can't afford that many!  You are punished for fraud.");
      army = 0
    )
    self stats atPut("army", self stats["army"] + army)
    self stats atPut("cash", self stats["cash"] - (army * 20))
    writeln("      Purchased " .. army .. " armies at a cost of " .. army * 20 .. " gold.")
    
    write("    Purchase how many Cities (at 2000 each, can afford " .. (self stats["cash"]/2000) floor .. ")?  ")
    city := File standardInput readLine asNumber
    if (city < 0, city = 0)
    if (city * 2000 > self stats["cash"], 
      writeln("      Can't afford that many!  You are punished for fraud."); 
      city = 0
    )
    self stats atPut("cities", self stats["cities"] + city)
    self stats atPut("cash", self stats["cash"] - (city * 2000))
    writeln("      Purchased " .. city .. " cities at a cost of " .. city * 2000 .. " gold.")
    
    write("    Purchase how many Farms (at 500 each, can afford " .. (self stats["cash"]/500) floor .. ")?  ")
    farm := File standardInput readLine asNumber
    if (farm < 0, farm = 0)
    if (farm * 500 > self stats["cash"], 
      writeln("      Can't afford that many!  You are punished for fraud."); 
      farm = 0
    )
    self stats atPut("farms", self stats["farms"] + farm)
    self stats atPut("cash", self stats["cash"] - (farm * 500))
    writeln("      Purchased " .. farm .. " farms at a cost of " .. farm * 500 .. " gold.")
    
    write("    Purchase how many Palace upgrades (at 5000 each, can afford " .. (self stats["cash"]/5000) floor .. ")?  ")
    palace := File standardInput readLine asNumber
    if (palace < 0, palace = 0)
    if (palace * 5000 > self stats["cash"], 
      writeln("      Can't afford that many!  You are punished for fraud."); 
      palace = 0
    )
    self stats atPut("palace", self stats["palace"] + (palace * 5))
    self stats atPut("cash", self stats["cash"] - (palace * 5000))
    writeln("      Purchased " .. palace .. " palace upgrades at a cost of " .. palace * 5000 .. " gold.")
  )
  
  war := method(weather,
    writeln(self name .. " --> Phase 6: War:")
    writeln("    You have 3 attacks left.  Please select a target (0 to end war phase):")
    // display stats
    // get input
    // attack
    // results
    writeln("    You have 2 attacks left.  Please select a target (0 to end war phase):")
    // display stats
    // get input
    // attack
    // results
    writeln("    You have 1 attack left.  Please select a target (0 to end war phase):")  
    // display stats
    // get input
    // attack
    // results
  )
  
  attack := method(weather, nil)
  
  displaystats := method(
    writeln(self name .. " --> Phase 7: End of turn:")
  )
)



g := Game clone addPlayer(Player clone setName("Player 1")) addPlayer(Player clone setName("Player 2"))
g play

