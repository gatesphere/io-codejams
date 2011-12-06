// Deque (double ended queue/head-tail linked list)
// Jacob Peck
// 20111024

// just a glorified wrapper around the list functionality

Deque := Object clone do(
  // state
  contents ::= list();
  
  // constructor
  init := method(
    contents = list()
  );
  
  // methods
  push_back := method(n,
    self contents append(n);
    self
  );

  push_front := method(n,
    self contents prepend(n);
    self
  );
  
  front := method(
    self contents first
  );
  
  back := method(
    self contents last
  );
  
  pop_front := method(
    val := self contents first;
    self setContents(self contents rest);
    val
  );
  
  pop_back := method(
    val := self contents last;
    self setContents(self contents reverse rest reverse);
    val
  );
  
  size := method(
    self contents size
  )
)