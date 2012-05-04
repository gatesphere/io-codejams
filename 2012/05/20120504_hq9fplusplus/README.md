HQ9F++ Interpreter
==================
Io Codejam - 20120504


Today's codejam is a bit of a special double-feature, in that I both define an
extension to a programming language and provide a complete implementation of it!

So, the language is HQ9F++, which is an extension of HQ9++, which itself is an
extension of HQ9+.  HQ9F++ is identical in every way to HQ9++, except for the 
addition of a new command: `F`.

`F` is defined as follows:

    Command    Function
    ==========================================================
      F          Do the FizzBuzz problem for the range 1 - 100
      

So, the HQ9F++ interpreter works in two modes: REPL and scripted.

To invoke the REPL, do the following:

    ./hq9fplusplus.io
    
To run as a scripting engine, do this:

    ./hq9fplusplus.io test.hq9fpp
    
Demo Time!
==========

REPL:

    $ ./hqf9plusplus.io
    Welcome to HQ9F++, version May 2012.  To exit, enter "!!exit"
    HQ9F++> h
    Hello World.
    HQ9F++> q
    q
    HQ9F++> qq
    qq
    qq
    HQ9F++> hqh
    Hello World.
    hqh
    Hello World.
    HQ9F++> +
    HQ9F++> ++
    HQ9F++> +++
    HQ9F++> qq++q+h
    qq++q+h
    qq++q+h
    qq++q+h
    Hello World.
    HQ9F++> 9
    100 bottles of beer on the wall,
    100 bottles of beer
    take one down, pass it around,
    99 bottles of beer on the wall.

    99 bottles of beer on the wall,
    99 bottles of beer
    take one down, pass it around,
    98 bottles of beer on the wall.

    <...snip...>

    2 bottles of beer on the wall,
    2 bottles of beer
    take one down, pass it around,
    1 bottle of beer on the wall.

    1 bottle of beer on the wall,
    1 bottle of beer
    take one down, pass it around,
    No more bottles of beer on the wall.

    HQ9F++> f
    1
    2
    Fizz
    4
    Buzz
    Fizz
    7
    8
    Fizz
    Buzz
    11
    Fizz
    13
    14
    FizzBuzz
    <...snip...>
    97
    98
    Fizz
    Buzz
    HQ9F++> !!exit
    Goodbye.

You will notice that the REPL has ReadLine capability, and saves a history file.

Scripting engine:

    $ cat test.hq9fpp
    9f+++hhqq
    
    $ ./hqf9plusplus.io test.hq9fpp
    100 bottles of beer on the wall,
    <...snip...>
    No more bottles of beer on the wall.

    1
    <...snip...>
    Buzz
    Hello World.
    Hello World.
    9f+++hhqq
    9f+++hhqq
    
Enjoy!