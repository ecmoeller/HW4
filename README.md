# HW4 [Memory Tiles Shader]
CSCI 8980 - Real-time Game Engine Design, Assignment 4

- Emily Moeller, [ecmoeller](https://github.com/ecmoeller)

## Building and Running Instructions
```
# build Makefile using cmake (need to do this for every additional C++ files added)
$ cd build
$ cmake ..

# build engine
$ cd GEFS
$ make -C <location of build/>

# to run a scene
$ cd GEFS
$ ./engine <folder containing main.lua> <optional config string>
```

Optional config strings are shown in `settings.cfg` as `[config string name]`. An option includes `[Debug]` which would then be run as follows:
```
$ ./engine <folder containing main.lua> Debug
```

## Resources
- Low poly tree obj package: [TurboSquid link](https://www.turbosquid.com/3d-models/blender-carrot-crystal-oak-tree-3d-model-1189852)

- Pirate Kit (1.1): Created/distributed by Kenney [(www.kenney.nl)](www.kenney.nl)

- Farm Animals Pack by Quaternius [https://www.patreon.com/quaternius](https://www.patreon.com/quaternius)

- Pirate Pack

- Potion Pack

- Farm Animals Pack by Quaternius [https://www.patreon.com/quaternius](https://www.patreon.com/quaternius)

- Nebula Skybox: Created by 'amethyst7' aka Chris Matz. WEB site: [http://amethyst7.gotdoofed.com](http://amethyst7.gotdoofed.com)


## Project Report

### Final Submission Video

1. What features did you implement? Why did you choose these particular features?

	Building off the game I made for the last project, I decided to use the same objects as before. However, instead of the objects being covered by tiles, the tiles have been removed so the objects are simply positioned in a 4 by 4 grid. As for the shader code, the intent was to do a simple fog shader. I choose this feature because it was straight forward to implement and could have added a more challenging aspect to the game. I also intended to add a feature that when an object was clicked on it would look like the object had been highlighted, but unfortunately I ran out of time. I wanted to choose this feature because I thought this was something that could have been incorporated into the game, to indicate that a tile had been selected. 
   
2. Algorithmically, how does your rendering implementation work. What formulas, algorithms, and techniques did you use? How scalable is your approach? What are the key bottlenecks?

	On the rendering side, I choose to use the keyboard to indictate when to use the fog shader. This was enabled by editing an if statement in the event loop in main.cpp. Inside this if statement, I simply call a method called updateFinalCompositeShader which creates a new composite shader by using the shader files specified, which is essentially the same as the initFinalCompositeShader but using my new fragment shader file. My idea behind the rendering implementation was to use as much of the already implemented and functional Shader code as possible, since I was having some trouble activating the shader code in my original implementation. Part of the challenge with this was that I was trying to implement the feature that would highlight individual objects when they were clicked, which involved activating shader code from main.lua which I trouble getting working. As a result of essentially calling the initialization function again, there is a fair amount of redundancy in this implementation. For example, I only wrote code for the fragment shader so the vertex shader stays unchanged, but in the process of recreating a Shader object it reloads the vertex shader. This could be improved by creating a separate method within Shader.cpp to only recreate the fragment shader. 
	In terms of scalability, passing in the new shader file is hard coded into updateFinalCompositeShader, so to have different shader files activated by different triggers there would have to be some restructing. Also since there is a fair amount of repeated code, I imagine that the efficiency could be improved by only reexcuting the necessary code for the specified shader. Particularly if there were many Shaders involved, new Shader objects would have to be recreated each time, even if you were switching back and forth between two shaders. It could be beneifical to save the Shader information so new objects would not have to be recreated. 
	
    
3. From	a systems design perspective, how did you integrate your new rendering techniques with the rest of the code? How and when do you trigger a change in rendering? In what data structures is the information associated with rendering stored?

	The new rendering method to use a new shader was added to Rendering.cpp, which then goes to Shader.cpp to create the vertex and fragment shaders. The new shader is activated when pressing d on the keyboard. As stated above, I attempted to have the shader become activated when a object was clicked, but I had some issues integrating the rendering code with main.lua to get that to work. Since the rendering code seeks to reuse as much Shader code as possible, the main data structure used is simply the Shader object. If more shaders were involved, I think it would be important to have some sort list of Shaders so that you could simply switch back and forth between shaders without having to recreate a Shader objects each time.
