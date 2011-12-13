RPN Calc Serv
=============
Io Codejam 20111213

This is a reverse Polish notation stack-based calculator, implemented as a remote server service.  To use it, simply telnet into port 1234.

Commands are as you would expect.

To exit, send the message "quit".  To print the stack, send an empty line.

Demo: 
-----


*server side*
    $ ./server.io 
    SERVER: Listening on port 1234
    SERVER: Received connection from 127.0.0.1
    127.0.0.1: 1 2 +
    127.0.0.1: 3
    127.0.0.1: 14 -
    127.0.0.1: /
    127.0.0.1: 42
    127.0.0.1: *
    127.0.0.1: 18 14
    127.0.0.1: **
    127.0.0.1: sqrt
    127.0.0.1: +
    127.0.0.1: 
    SERVER: Closing connection from 127.0.0.1
    SERVER: Connection from 127.0.0.1 closed

*client side*
    $ telnet localhost 1234
    Trying 127.0.0.1...
    Connected to localhost.
    Escape character is '^]'.
    Welcome to RPN Calc serv!
    ?>  1 2 +
    --> Currently on stack:
        3

    ?>  3
    --> Currently on stack:
        3
        3

    ?>  14 -
    --> Currently on stack:
        -11
        3

    ?>  /
    --> Currently on stack:
        -0.2727272727272727

    ?>  42
    --> Currently on stack:
        42
        -0.2727272727272727

    ?>  *
    --> Currently on stack:
        -11.4545454545454533

    ?>  18 14
    --> Currently on stack:
        14
        18
        -11.4545454545454533

    ?>  **
    --> Currently on stack:
        3.748134e+17
        -11.4545454545454533

    ?>  sqrt
    --> Currently on stack:
        612220058.4757086038589478
        -11.4545454545454533

    ?>  +
    --> Currently on stack:
        612220047.0211631059646606

    ?>  
    --> Currently on stack:
        612220047.0211631059646606

    ?>  quit
    Connection closed by foreign host.
