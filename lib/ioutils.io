// Collection of useful utilities and enhancements to Io
// Jacob Peck, with much help from others

// C-like compound calculate/assignment operators
// Thanks to Jeremy Tregunna
OperatorTable addAssignOperator("+=","addAndSet")

Object addAndSet := method(var, val, 
  self setSlot(var, self getSlot(var) + val)
)

OperatorTable addAssignOperator("-=","subtractAndSet")

Object subtractAndSet := method(var, val, 
  self setSlot(var, self getSlot(var) - val)
)

OperatorTable addAssignOperator("/=","divideAndSet")

Object divideAndSet := method(var, val, 
  self setSlot(var, self getSlot(var) / val)
)

OperatorTable addAssignOperator("*=","multiplyAndSet")

Object multiplyAndSet := method(var, val, 
  self setSlot(var, self getSlot(var) * val)
)

OperatorTable addAssignOperator("%=","moduloAndSet")

Object moduloAndSet := method(var, val,
  self setSlot(var, self getSlot(var) % val)
)

// square brackets for list creation
// ex. alist := [1,2,3] ==> list(1, 2, 3)
Object squareBrackets := method(
  l := list()
  call message arguments foreach(arg,
    l append(l doMessage(arg))
  )
  l
)

// square brackets for list indexing
// ex list(1,2,3)[1] ==> 2
// Thanks to Hans Nowak
List squareBrackets := method(index,
  self at(call evalArgAt(0))
)

// curly brackets and colons for map creation
// ex. {"key":"value", "key2":"value2"} ==> Map
// Thanks to Jeremy Tregunna, Bruce Tate, and Chris Kappler
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

// square brackets for map indexing
// ex. {"key":"value"}["key"] ==> value
Map squareBrackets := method(
  self at(call evalArgAt(0))
)

// xor boolean operator
// Thanks to Bruce Tate
OperatorTable addOperator("xor",11)

true xor := method(bool, if(bool, false, true))
false xor := method(bool, if(bool, true, false))


// retrieve a random element from a list
// ex. list(1,3,4,6,8) anyOne ==> 3
// Thanks to Jeremy Tregunna
List anyOne := method(
  sortBy(
    block(x, y, 
      x uniqueId asNumber * Random value < y uniqueId asNumber * Random value
    )
  ) at(0)
)

