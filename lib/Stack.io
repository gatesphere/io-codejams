// Stack (FILO)
// Jacob Peck
// 20111024

// just a glorified wrapper around the list functionality

Stack := Object clone do(
  // state
  contents ::= list();
  
  // constructor
  init := method(
    contents = list()
  );
  
  // methods
  push := method(n,
    self contents prepend(n);
    self
  );
  
  top := method(
    self contents first
  );
  
  pop := method(
    val := self contents first;
    self setContents(self contents rest);
    val
  );
  
  size := method(
    self contents size
  )
)