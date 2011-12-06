// Queue (FIFO)
// Jacob Peck
// 20111024

// just a glorified wrapper around the list functionality

Queue := Object clone do(
  // state
  contents ::= list();
  
  // constructor
  init := method(
    contents = list()
  );
  
  // methods
  push := method(n,
    self contents append(n);
    self
  );
  
  front := method(
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