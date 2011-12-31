Genetic Algorithm in Io ("RGB world")
=====================================
Io Codejam - 20111230 (Happy New Year, tomorrow!)


This is a simple application of a genetic algorithm in Io.  It's a simulation of a world wherein worms take their coloring from three different genes: R, G, or B (red, green, or blue, respectively).  The world is predominantly a single color, and the worms who contain the most of that particular color live on into the next generation.

The fitness function is simple: count the number of matching characters in the DNA string, and divide by the length of the string.  The DNA strings are hard-coded to be 25 characters long.

There are three operators at work here: Copy (enters the next generation unchanged, 60%), Crossover (two worms breed, crossing over their DNA, 40%), and Mutate (a random gene in a worm in the new population is changed, 50%).

The world changes between the three colors, and you can see that the average fitness grows rapidly (due to the prevalence of the Mutate and Crossover operators).

To run it, just do a:
  
    ./ga.io

or, if that fails:

    io ga.io

Enjoy!
