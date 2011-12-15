#!/usr/local/bin/io

// Tiny web server,
// hosts the current directory as a webroot on port 8000
// (a la python -m SimpleHTTPServer)

// based heavily on the sample MinimalWebServer.io

Logic := Object clone do(
  
  process := method(aSocket, aServer,
    aSocket streamReadNextChunk
    req := aSocket readBuffer betweenSeq("GET ", " HTTP")
    if(req == nil, self fourohfour(aSocket);aSocket close; return)
    if(req endsWithSeq("/"),
      req appendSeq("index.html")
    )
    f := File with(req exSlice(1))
    if(f exists,
      aSocket streamWrite(f contents),
      self fourohfour(aSocket)
    )
    writeln("requested ", req)
    aSocket close
  )
  
  fourohfour := method(aSocket,
    aSocket streamWrite(
    "<html><head><title>404 NOT FOUND</title></head><body><H1>404 NOT FOUND</H1></body></html>")
  )
)

writeln("SERVER: Listening on port 8000")

server := Server clone setPort(8000)
server handleSocket := method(aSocket,
  Logic clone @process(aSocket, self)
)

server start
