#!/usr/local/bin/io

// Tiny web server,
// hosts the current directory as a webroot on port 8000
// (a la python -m SimpleHTTPServer)

// based heavily on the sample MinimalWebServer.io

// does not send any proper headers.

Logic := Object clone do(
  rootdir := Directory with(System launchPath beforeSeq(System launchScript pathComponent))
  
  process := method(aSocket, aServer,
    aSocket streamReadNextChunk
    req := aSocket readBuffer betweenSeq("GET ", " HTTP")
    if(req == nil,
      self fourohfour(aSocket);
      aSocket close;
      self log(aSocket host .. ": nil request");
      return
    )
    if(req endsWithSeq("/"),
      req appendSeq("index.html");
    )
    f := File with(req exSlice(1))
    if(f exists,
      if(f isDirectory,
        self index(aSocket, req .. "/"),
        aSocket streamWrite(f contents)
      ),
      if(req endsWithSeq("index.html"),
        self index(aSocket, req beforeSeq("index.html")),
        self fourohfour(aSocket)
      )
    )
    self log(aSocket host .. ": requested " .. req)
    aSocket close
  )
  
  log := method(string,  writeln(string))
  
  index := method(aSocket, req,
    dir := Directory with(self rootdir path .. req exSlice(1))
    writeln(dir path)
    source := "<html><head><title>Index of " .. req .. "</title></head><body><h1>Index of " .. req .. "</h1><hr><ul>"
    source = source .. "<li><a href=\"..\">/../</a></li>"
    dir directories foreach(element,
      source = source .. "<li><a href=\"" .. element name .. "/\">/" .. element name .. "/</a></li>"
    )
    dir fileNames foreach(element,
      source = source .. "<li><a href=\"" .. element .. "\">" .. element .. "</a></li>"
    )
    source = source .. "</ul><hr></body></html>"
    
    length := source sizeInBytes
    source = "\nHTTP/1.1 200 OK\nContent-Length: " .. length .. "\n\n" .. source
    
    aSocket streamWrite(source)
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
