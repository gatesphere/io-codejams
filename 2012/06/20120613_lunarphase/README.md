Lunar Phase Calculator
======================
Io Codejam - 20120613


This is a simple little lunar phase calculator.  You provide it a date (or none
for the current date) and it will give you a textual description of the moon phase
for that date, accurate to within 1 segment for any date in the range of 1Jan1969 
and 31Dec2199.

Here's an example printing today's moonphase:

    $ ./lunarphase.io
    Moon phase for 2012 - 6 - 13:
    Last quarter.
    
And here's the known new moon on 11Aug1999:

    $ ./lunarphase.io 1999 8 11
    Moon phase for 1999 - 8 - 11:
    New moon.
    
That's it.  Enjoy!
