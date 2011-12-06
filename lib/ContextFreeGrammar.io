// Leftmost CFG in Io
// Jacob Peck

// reimplement List anyOne
List anyOne := method(
  sortBy(
    block(x, y, 
      x uniqueId asNumber * Random value < y uniqueId asNumber * Random value
    )
  ) at(0)
);


ContextFreeGrammar := Object clone do(
  // state
  rules ::= Map clone; // of the form rules atPut("non-terminal", list(all,the,rules))
  axiom ::= "s";
  
  // constructor
  //init := method(self rules = Map clone; self axiom = "s");

  // methods
  addRule := method(symbol, rule, // add a rule to a symbol
    curr := self getRules(symbol);
    if (curr == nil, curr = list());
    self rules atPut(symbol, curr append(rule));
    self
  );

  getRandomRule := method(symbol, // get a random rule associated with a non-terminal
    self rules at(symbol) anyOne
  );

  getRules := method(symbol, // get all the rules associated with a non-terminal
    self rules at(symbol)
  );

  generateSentence := method( // generate a random sentence, iteratively (could have used recursion)
    sentence := list(self axiom);
    loop( // loop until break
      firstHalf := list();
      secondHalf := sentence clone;
      
      // replace leftmost non-terminal
      sentence foreach(x,
        val := secondHalf removeFirst;
        if(self getRules(x) != nil, // non-terminal
          newx := self getRandomRule(x); // get a random rule
          firstHalf = firstHalf append(newx) flatten;
          sentence = firstHalf append(secondHalf) flatten; 
          break;
        );
        firstHalf = firstHalf append(val);
      );

      // test if done
      end := true;
      sentence foreach(x,
        if (self getRules(x) != nil, end = false)
      );
      if(end, break, continue) // if finished, exit loop, else continue
    );
    sentence join(" ") asMutable unescape
  );
  
  addRulesFromFile := method(filename, // load a rulebase from a text file
    rulefile := File openForReading(filename);
    rulefile foreachLine(line,
      if((line beginsWithSeq("//") or line beginsWithSeq(" ") or line isEmpty) not, // ignore malformed lines and comments
        tokenlist := line splitNoEmpties;
        self addRule(tokenlist first, tokenlist rest rest)
      );
    );
    rulefile close;
    self
  );
  
  assignDictionaryToRule := method(filename, symbol, // load a comma separated file of words, store in a rule
    rulefile := File openForReading(filename);
    tokenlist := rulefile contents splitNoEmpties;
    tokenlist foreach(x,
      self addRule(symbol, list(x))
    );
    rulefile close;
    self
  );
  
  printRules := method( // print all rules for entire CFG
    self rules keys sort foreach(kk, self printRulesForSymbol(kk));
    self
  );
  
  printRulesForSymbol := method(symbol, // print all rules for symbol
    v := self rules at(symbol);
    v foreach(vv,
      writeln(symbol, " -> ", vv join(" "))
    );
    self
  );
  
  saveSymbolDictionaryToFile := method(symbol, filename,
    file := File openForAppending(filename);
    contents := self getRules(symbol) flatten join(" ");
    file write(contents);
    file close;
    self
  );
  
  saveRulesToFile := method(filename,
    file := File openForAppending(filename);
    self rules keys sort foreach(kk,
      v := self rules at(kk);
      v foreach(vv,
        file write(kk, " -> ", vv join(" "), "\n")
      )
    );
    file close;
    self
  )
  
) //end ContextFreeGrammar