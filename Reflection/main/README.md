# Reflection

![graphic.wow](https://github.com/jlehett/ProcessingSketches/blob/master/Reflection/main/output/output.png)

### Overview

This sketch aimed to reproduce the aesthetic of a rising and setting sun against a mountainous terrain with water reflections at
the bottom.

The scene parameter constants at the top of <i>main.pde</i> can change various settings about the sketch. The variables should be
fairly self-explanatory.

Multiple GLSL fragment shaders are used to give depth to the scene. All shader effects can be found in the "./data/"
directory.

The sky shader includes code that linearly interpolates between the two sky colors specified in the scene parameters based on 
current distance from the sun in the scene.

The sun bloom shader is very similar to the sky shader in that it linearly interpolates based on the fragment's current
distance from the sun. However, instead of linearly interpolating between the two sky colors, it linearly interpolates a white
layer's opacity to place over top of the scene to give off the appearence of "bloom."

The sun illuminate shader places on opaque brightening/darkening layer on the scene dependent on the current y-position of the
sun. If the sun is higher in the air, the shader will place a white layer of increasing opacity to brighten the scene. If the sun
is lower in the air, the shader will place a varying dark layer of increasing opacity to darken the scene. If the sun is at about
the midpoint of the scene, the brightening/darkening layer will have an opacity close to 0, thus not affecting the scene.

Each terrain fragment shader takes in the terrain color as uniforms, as well as a few other settings, and willl linearly
interpolate between white and the terrain color based on the y-position of the fragment. This gives off the illusion of fog as the
terrain near the bottom of the screen will have its colors muted and more pale.

Finally, the water fragment shader is perhaps the most difficult to understand. In order to give off the reflection effect, the
scene is first rendered to a PGraphics object (without the water). This is then sent as a 2D texture to the water fragment shader.
The water fragment shader renders the scene to the screen as normal, but where the water is supposed to be, it maps the fragment's
y-position reflected about the equator line. 

In addition to this, the y-position is slightly scaled upward, such that it gives off the illusion of an elongated reflection in 
the water. In order to give off the wavey appearance of water, the reflected coordinates are translated slightly with 3D Perlin 
noise based on the time elapsed in the scene, and the x and y coordinates of each fragment. Once the reflection is finalized, the
fragment color is mixed with a defined water color so that it is not a perfect color match, and instead has the tint of water.

### [Back to Home](https://github.com/jlehett/ProcessingSketches)
