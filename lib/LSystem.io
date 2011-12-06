// Strict one-to-one L-systems, using single character symbols
// Jacob Peck
// 20111025

LSystem := Object clone do(
  // state
  data ::= "";
  rules ::= list();
  generation ::= 0;
  
  // constructor
  init := method(
    data = "";
    rules = list();
    generation = 0;
  );
  
  // methods
  age := method(self generation);
  addRule := method(symbol, rule,
    newRule := list(symbol, rule);
    newRulesList := list();
    self rules foreach(i,
      if(i first != symbol,
        newRulesList append(i)
      )
    );
    newRulesList append(newRule);
    self setRules(newRulesList);
  );
  iterate := method(
    newdata := "";
    if(self data size == 0,
      Exception raise("LSystem: no initial data")
    );
    if(self rules size == 0,
      Exception raise("LSystem: no rewrite rules defined")
    );
    self data foreach(i,
      ichar := i asCharacter;
      if (ichar != " ",
        rule := nil;
        self rules foreach(i,
          if(i first == ichar,
            rule = i second
          )
        );
        if (rule == nil, // no rule found, raise exception
          Exception raise("LSystem: no rewrite rule for character \"" .. ichar .. "\"")
        );
        newdata = newdata .. " " .. rule;
      )
    );
    self setData(newdata asMutable strip)
    self setGeneration(self generation + 1);
  )
)