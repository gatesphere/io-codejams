#!/usr/local/bin/io

// RPN calculator server...
// telnet into port 1234, and send commands
// quit exits
// send an empty line to print the stack

doFile("../../../lib/Stack.io")

Logic := Object clone do(
  operators := list("+","-","*","/","**","sqrt")
  stack := Stack clone
  
  init := method(
    stack = Stack clone
  )
  
  process := method(aSocket, aServer,
    writeln("SERVER: Received connection from ", aSocket host)
    if(aSocket isOpen, aSocket write("Welcome to RPN Calc serv!\n?>  "))
    while(aSocket isOpen,
      if(aSocket read,
        if(aSocket readBuffer asString asMutable strip == "quit",
          aSocket close;
          writeln("SERVER: Closing connection from ", aSocket host),
          write(aSocket host, ": ", aSocket readBuffer asString);
          retval := self parse(aSocket readBuffer asString asMutable strip);
          aSocket write("--> " .. retval .. "\n?>  ")
          aSocket readBuffer empty
        )
      )
    )
    writeln("SERVER: Connection from ", aSocket host, " closed")
  )
  
  parse := method(input,
    input splitNoEmpties foreach(element,
      stack push(element)
      if(self calculate(stack) not,
        retval := "error"; return retval
      )
    )
    retval := "Currently on stack:\n"
    stack contents foreach(element,
      retval = retval .. "    " .. element .. "\n"
    )
    retval
  )
  
  calculate := method(stack,
    // calculate from the stack
    top := stack top
    //writeln(stack contents);
    if(top asNumber isNan, 
      if(self operators contains(top),	
        stack pop;
        if(top == "sqrt",
          if(stack size < 1, return false);
          b := stack pop asNumber;
          if(b isNan, return false);
          stack push(self doString(b .. " " .. top)),
          if(stack size < 2, return false);
          b := stack pop asNumber;
          a := stack pop asNumber;
          if(a isNan or b isNan, return false);
          stack push(self doString(a .. " " .. top .. " " .. b))
        ),
        stack pop;
        return false
      )
    )
    //writeln("SERVER:  Top -> " .. top)
    true
  )    
    
        
)

writeln("SERVER: Listening on port 1234")

server := Server clone setPort(1234)
server handleSocket := method(aSocket,
  Logic clone @process(aSocket, self)
)

server start
