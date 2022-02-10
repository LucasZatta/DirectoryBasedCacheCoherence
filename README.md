# DirectoryBasedCacheCoherence

College project. Subject: Computer Architecture and Organization II

This project contains the implementation of a multi-thread directory-based cache coherence protocol.

The project specifications were:

Implement a top level design containing:

- One chip.
- Two Processor(P0,0 and P0,1) each containing a L1 cache.
- One shared L2 cache.
- One main memory.

The top level design is the archive directory.v


## Considerations:
The Chip component specified is merely a module that wraps the processors and their shared memory. In more advanced designs, there are multiple chips with multiple processors each. In this particular case, there is only one chip so the wrapper module isnt really necessary for the implementation of our design.

You could also use the libraries modules for the caches to "simulate" a processor, but in this practice I decided to do it properly and tried do be more organized with my designs. In this implementation, there are separate L1 Cache modules, one for each processor, as there was the need to initialize each with different values. I also implemented a L2 Cache that is the shared cache between the two Processor, which also have their own modules, Processor00 and Processor01. Ive created two different modules for each processor because, once again, I needed to initialize different lines of instruction in each one.

