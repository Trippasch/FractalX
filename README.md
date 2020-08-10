# FractalX
A fractal simulation game project made with Unity.

Check it out here: https://trippinhoppin.itch.io/fractalx

FractalX is a basic fractal simulator game, with many custom features that lets the player explore, interact and customize the fractal on the screen. The player’s role is rather simple. All the player has to do, is to simply relax and explore the beautiful worlds of mathematics and geometry in a fun-laidback way. Also, with the added customizable features on the fractals, the player can create his-her own art by tweaking some of the variables inside the game. The player can either take screenshots by activating immersion mode(pressing F12),  or just zone out and let the game run its course.

Now regarding to the more technical stuff:

The game, currently, is implementing only the mandelbrot fractal and all of julia sets. In order to access the julia sets you have to check the Julia Mode box and tweak seedX-seedY to your liking in order to form all kinds of julia sets. All the other stuff in-game are pretty self-explanatory so i won't bother. 

Last but not least, you can only zoom in the fractal a finite amount , so around scale = 2.0E-05 you will start seeing pixels. This is happening because the shaders i used for making this game can only take ,at best, float-precision variables. You could use double variables in a compute shader and zoom in double the amount of that, but you will lose performance. So i decided to keep floats because, either way, in these types of fractals you have to zoom in way more to start seeing a significant difference.
