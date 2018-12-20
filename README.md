# install_blender_as_a_package
script for installing blender as a Python package

After installation you can simply `import bpy` to interact with blender using your usual python interpreter.
-Works with GPU!

Modification you may want to change in the script:  
- update the location of install_deps.diff  
- set the number of cpu cores to match the amount you have on your computer  

if you get the following error: No rule to make target `'/usr/lib/x86_64-linux-gnu/libGL.so', needed by 'lib/libosdGPU.so.3.0.0'.`, 
follow the instructions [here](https://github.com/RobotLocomotion/drake/issues/2087)
