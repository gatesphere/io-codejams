Die roller
==========
Io Codejam - 20120519


This is a simple die-rolling program, command-line style.

It accepts strings of the following grammar:

    s        -> expr
    expr     -> die | constant | die '+' expr | constant '+' expr
    die      -> number 'd' number | number 'd' 'f' | number 'd' 'F'
    constant -> number
    number   -> [0-9]+
    
So, for example, it will accept the following strings:

    3d6
    14d20
    1d20+3
    6d6+3+4d3
    4dF
    4df+2
    1d2
    36d114
    
Nothing too special.  Of note is the die type "f" or "F" (which are the same).  
This is a "fudge die", which is a 6 sided die with sides consisting of +,+,0,0,-,-,
or as interpreted by this program, 1,1,0,0,-1,-1.  Rolling 4dF for example, gives you
a number between -4 and +4, weighted towards 0.  They're really neat dice.

Here's an example, showing the statistical breakdown that this program provides:

    $ ./roll.io 12d6
    rolled: 2 6 3 6 3 5 1 5 6 1 5 4
    sum: 47
    median: 4.5
    mean: 3.9166666666666665
    mode: 5
    min: 1
    max: 6
    
Enjoy!
