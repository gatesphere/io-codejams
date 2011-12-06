// Conway's GoL

Conway := Object clone do(
  cells ::= list
  age ::= 0
  
  init := method(
    cells = list
    age = 0
  )
  
  with := method(x,y,
    n := self clone
    n setCells(self initcells(x,y))
    toset := (x * y) / 8
    toset repeat(
      n cells at(Random value(y-1) round) atPut(Random value(x-1) round, true)
    )
    n
  )

  initcells := method(x,y,
    l := list
    y repeat(j, 
      l append(list setSize(x));
      x repeat(i,l at(j) atPut(i, false))
    )
    l
  )

  display := method(
    self cells foreach(j, y,
      y foreach(i, x,
        if(x, write("X"), write("_"))
      );
      writeln
    )
  )
  
  neighborcount := method(l,x,y,
    count := 0
    for(j,-1,1,
      for(i,-1,1,
        if(i == 0 and j == 0, 
          continue,
          if(self getneighbor(l, x + i, y + j), count = count + 1)
        )
      )
    )
    count
  )
  
  getneighbor := method(l,x,y,
    //write(x .. " " .. y .. " --> ")
    ymax := l size - 1
    xmax := l at(0) size - 1
    if(x > xmax, x = 0)
    if(y > ymax, y = 0)
    if(x < 0, x = xmax)
    if(y < 0, y = ymax)
    //writeln(x .. " " .. y)
    l at(y) at(x)
  )
      
  iterate := method(
    self setAge(self age + 1)
    oldworld := self cells clone
    oldworld foreach(i, y,
      y foreach(x, cell,
        //writeln("    " .. x .. " " .. i)
        nc := neighborcount(oldworld, x, i)
        if(cell,
          if(nc == 2 or nc == 3,
            self cells at(i) atPut(x, true),
            self cells at(i) atPut(x, false)
          ),
          if(nc == 3,
            self cells at(i) atPut(x, true),
            self cells at(i) atPut(x, false)
          )
        )
      )
    )    
    self
  )
)
