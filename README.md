# Comments
When I first looked at the source codes, I thought this code must be slow. I planned to do some modification myself to see if I can rewrite the code with much faster speed and clearer code structure. I failed at the first time using class objects, because I never realized that the handle objects are such slow, especially in nested loops. Of course I could tune the code and improve it, but I finally decided to use the simpler but similar struct type to deal with the problem.

# Lesson from failure

1. Why is my first OOP version so slow? Checking the restriction of class properties takes time; accessing and overwrite properties takes significant time.
2. Using handle classes may not be a good idea if you want performance. I tried because it seems to be a clever way of mimicking pointers to pass arguments, but it turns out to be extremely inefficient.
3. So, let's forget about OOP in MATLAB simulations...which is sad.
4. I thought it should be easy to convert this to a GPU-enabled code, but obviously I was wrong. Because the functions like update velocity loop over all the particles one by one, making the velocities and positions into gpuArray doesn't help much. It would only benefit if I am doing matrix operations!

# Improvements

1. Remove all the global variables, replace by structs;
2. Put all the function into the private directory;
3. Improved parameter reading function, with textscan instead of textread and strread, and str2double, strtrim;
4. Clearer comment style;
5. Rename almost all the variables and functions following naming standards;
6. Replace the old GUI designed by GUIDE with a new one by AppDesigner.
7. Rewrite the kernel of velocity update and current calculation: replace the for loop with matrix operations. For the velocity update, the results are exactly the same; for the current calculation, I use Matlab built-in function accumarray, which give slightly different results for current down to machine precision for each timestep. I don't know the exact reason behind this, but I think it is due to the multithread usage of the built-in function, such that the sequence of reduction changes. Both of the new functions have about 5 to 10 times speedup.

# Side notes

1. JIT is smart enough to handle ^2 as simple multiplication.
2. rotate3d should be set only at the beginning, otherwise it will significantly affect the performance.

# Copyrights

The original KEMPO1 version can be downloaded from [here](http://space.rish.kyoto-u.ac.jp/software/). 