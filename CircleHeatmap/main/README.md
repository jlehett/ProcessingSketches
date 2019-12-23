# Circle Heatmap

![graphic.wow](https://github.com/jlehett/ProcessingSketches/blob/master/CircleHeatmap/main/output/output.png)

### Overview

It's kind of hard to capture what this sketch looks like in 1 image since it is supposed to be displayed in motion.

In this sketch, multiple circles are moving around the screen, with new circles being spawned to replace those that go out of
bounds. The circles themselves are rendered to a PGraphics object with white strokes with opacity of 1/2 and a white fill with an
opacity of 1/3. This PGraphics object is sent to the fragment shader as a 2D texture for final rendering purposes.

The fragment shader used can be found in the "./data/shaders/" directory. It takes in the PGraphics object produced above as a 2D
texture. Then, for each fragment, the color value is grabbed for the corresponding fragment in the texture. These color values will
all be grayscale, and their values will vary depending on the number of circles touching that point, and where in the circle these
points are touching. Since stroke opacity is 1/2 and fill opacity is 1/3, the borders of the circles will tend to have higher
color values.

At this point, an arbitrary threshold is selected. In the example above, a threshold of 0.75 is selected. If the fragment's color
value in the texture is <= threshold, the background color is chosen for the fragment. Else, the foreground color is chosen for
the fragment.

In this way, we can see an interesting "heatmap" of where circles are intersecting as they move around the screen.

### [Back to Home](https://github.com/jlehett/ProcessingSketches)
