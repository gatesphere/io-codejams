#!/usr/bin/env io


// usage string
usage := method(
  writeln("usage (encoding):  ./steg.io encode <cover_file> <secret_file> <output_file>")
  writeln("usage (decoding):  ./steg.io decode <input_file> <secret_output_file>")
  System exit
)



// encoder
Encoder := Object clone do(
  cover_file := nil
  secret_file := nil
  out_file := nil
  
  cover_length := method(
    h1 := cover_file contents at(22)
    h2 := cover_file contents at(23)
    h3 := cover_file contents at(24)
    h4 := cover_file contents at(25)
    
    w1 := cover_file contents at(18)
    w2 := cover_file contents at(19)
    w3 := cover_file contents at(20)
    w4 := cover_file contents at(21)
    
    h := h4 << 24 | h3 << 16 | h2 << 8 | h1
    w := w4 << 24 | w3 << 16 | w2 << 8 | w1
    
    //writeln("H: " .. h .. " W: " .. w)
    h * w;
  )
  
  modify_byte := method(original, newdata, bits,
    //writeln("original: " .. original asBinary)
    higher := original >> bits;
    //writeln("higher: " .. higher asBinary)
    //writeln("newdata: " .. newdata asBinary)
    //writeln("writing: " .. ((higher << bits) | newdata) asBinary)
    (higher << bits) | newdata
  )
    
  
  run := method(
    if(System args size != 5, usage)
    writeln("Encoding...")
    cover_file = File with(System args at(2)) openForReading
    secret_file = File with(System args at(3)) openForReading
    out_file = File with(System args at(4)) remove openForAppending
    
    secret_length := secret_file contents size
    if(secret_length + 4 > self cover_length,
      writeln("Secret file too large to hide in cover file.")
      System exit
    )
    
    in_data := secret_file contents
    
    out_data := cover_file contents
    offset := 54
    
    out_len_b4 := (secret_length >> 24) & 255
    out_len_b3 := (secret_length >> 16) & 255
    out_len_b2 := (secret_length >> 8) & 255
    out_len_b1 := secret_length & 255
    writeln(secret_length)
    
    // add length
    list(out_len_b1, out_len_b2, out_len_b3, out_len_b4) foreach(byte,
      writeln(byte asBinary)
      out_blue := (byte >> 5) & 7
      out_green := (byte >> 3) & 3
      out_red := byte & 7
      out_data atPut(offset, self modify_byte(out_data at(offset), out_blue, 3))
      offset = offset + 1
      out_data atPut(offset, self modify_byte(out_data at(offset), out_green, 2))
      offset = offset + 1
      out_data atPut(offset, self modify_byte(out_data at(offset), out_red, 3))
      offset = offset + 1
      //writeln
    )
    
    // modify data => one pixel per byte
    in_data foreach(byte,
      out_blue := (byte >> 5) & 7
      out_green := (byte >> 3) & 3
      out_red := byte & 7
      out_data atPut(offset, self modify_byte(out_data at(offset), out_blue, 3))
      offset = offset + 1
      out_data atPut(offset, self modify_byte(out_data at(offset), out_green, 2))
      offset = offset + 1
      out_data atPut(offset, self modify_byte(out_data at(offset), out_red, 3))
      offset = offset + 1
    )
    
    out_file write(out_data)
    out_file flush close
    cover_file close
    secret_file close
    
    writeln("Done.  Data written to file " .. out_file name .. ".")
  )
)



// decoder
Decoder := Object clone do(
  in_file := nil
  out_file := nil
  
  extract_data := method(byte, bits,
    //writeln(byte asBinary)
    if(bits == 3,
      //writeln((byte & 7) asBinary)
      return byte & 7
      ,
      if(bits == 2,
        //writeln((byte & 3) asBinary)
        return byte & 3
        ,
        return nil
      )
    )
  )
  
  getLength := method(
    len_bytes := list
    offset := 54
    4 repeat(
      blue := self extract_data(in_file contents at(offset), 3)
      offset = offset + 1
      green := self extract_data(in_file contents at(offset), 2)
      offset = offset + 1
      red := self extract_data(in_file contents at(offset), 3)
      offset = offset + 1
      byte := blue << 5 | green << 3 | red
      //writeln(byte asBinary)
      len_bytes append(byte)
    )
    len_bytes at(3) << 24 | len_bytes at(2) << 16 | len_bytes at(1) << 8 | len_bytes at(0)
  )
  
  run := method(
    if(System args size != 4, usage)
    writeln("Decoding...")
    
    in_file = File with(System args at(2)) openForReading
    out_file = File with(System args at(3)) remove openForAppending
    
    out_data := list
    
    offset := 66
    
    length := self getLength
    
    //writeln(length)
    
    
    length repeat(
      blue := self extract_data(in_file contents at(offset), 3)
      offset = offset + 1
      green := self extract_data(in_file contents at(offset), 2)
      offset = offset + 1
      red := self extract_data(in_file contents at(offset), 3)
      offset = offset + 1
      byte := blue << 5 | green << 3 | red
      //writeln(byte)
      out_data append(byte)
    )
    
    
    out_data foreach(i, x,
      out_file atPut(i, x)
    )
    out_file flush close
    in_file close
    
    writeln("Finished.  Decoded secret written to file " .. out_file name .. ".")
  )
)



// main body
if(System args size != 4 and System args size != 5, usage)

mode := System args at(1)

if(mode == "encode",
  Encoder run
  ,
  if(mode == "decode",
    Decoder run
    ,
    usage
  )
)



