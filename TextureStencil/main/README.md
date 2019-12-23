# Texture Stencil

![graphic.wow](https://github.com/jlehett/ProcessingSketches/blob/master/TextureStencil/main/output/output.png)

### Overview

In this sketch, textures are rendered through stencil-like operations using Processing and GLSL fragment shader code. Texture
images are stored in the "./data/textures/" directory, and shader code can be found in the "./data/shaders/" directory.

The sketch makes use of the PGraphics objects in Processing. First, textures are loaded as PGraphics for use in the fragment
shader code later. Then, a set of PGraphics objects are created which we will draw to in order to create the stencils.

The PGraphics stencils should all have a solid black background. On top of them, we can draw whatever shapes we want in a solid
white color. These PGraphics stencils can then be sent as uniform 2D textures to the GLSL shader code.

The shader code can then ask which stencils have a value of (1.0, 1.0, 1.0) at each fragment's location. If a stencil does have a
value of (1.0, 1.0, 1.0), or white, at that location, that location is considered "in" the stencil. From there, we can say that
if a fragment is in stencil 1, grab the color value found in the associated texture using the texture2D GLSL function, and set 
the fragment color to that value.

In the example shown in the image above, concentric arcs are being drawn via regular Processing code to separate PGraphics 
stencils. These arcs are being rotated to certain angles using perlin noise as a function of time. The stencils are being passed
each frame to the shader code as uniforms, and the final rendered image is produced using the shader code to mark where certain
textures should be showing.
