import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

// Window constants
int HEIGHT = 900;
int WIDTH = 900;

// Scene parameters
int sunPosX = 600;
int sunPosY = 200;
int sunRadius = 150;


PGraphics terrain, sky, sun, water;


void setup() {
    // MAKE SURE SIZE HAS THE SAME ARGUMENTS AS HEIGHT AND WIDTH
    size(900, 900, P2D);

    // Create the sky
    sky = createGraphics(WIDTH, HEIGHT, P2D);
    sky.beginDraw();
    drawSky(sky);
    sky.endDraw();

    // Create the sun
    sun = createGraphics(sunRadius, sunRadius, P2D);
    sun.beginDraw();
    drawSun(sun, color(255, 255, 255));
    sun.endDraw();

    // Create the terrain
    terrain = createGraphics(WIDTH, HEIGHT, P2D);
    terrain.beginDraw();
    drawTerrain(terrain, 700, 0.55, 300, color(197, 169, 188));
    drawTerrain(terrain, 700, 0.55, 200, color(150, 139, 182));
    drawTerrain(terrain, 700, 0.5, 100, color(117, 116, 176));
    terrain.endDraw();

    // Create the water
    water = createGraphics(WIDTH, HEIGHT, P2D);
    water.beginDraw();
    drawWater(water, 700, color(80, 80, 148));
    water.endDraw();
}

void draw() {
    image(sky, 0, 0);
    image(sun, sunPosX, sunPosY);
    image(terrain, 0, 0);
    image(water, 0, 0);
}

void drawSky(PGraphics surface) {
    surface.fill(253, 200, 202);
    surface.rect(0, 0, WIDTH, HEIGHT);
}

void drawSun(PGraphics surface, color c) {
    surface.fill(c);
    surface.noStroke();
    surface.ellipse(sunRadius/2.0, sunRadius/2.0, sunRadius, sunRadius);
}

void drawWater(PGraphics surface, float equator, color c) {
    surface.fill(c);
    surface.noStroke();
    surface.quad(0, HEIGHT, 0, equator, WIDTH, equator, WIDTH, HEIGHT);
}

void drawTerrain(
    PGraphics surface, float equator, float roughness, 
    float displace, color c
    ) {
    // Choose a color for the terrain
    surface.fill(c);
    surface.noStroke();
    // Have array list store the heights for the terrain
    int power = round(pow(2, ceil(log(WIDTH) / log(2))));
    float[] heights = new float[power+1];
    // Put the starting heights into the arraylist
    heights[0] = random(-displace/2.0, displace/2.0) + displace*3.0/4.0;
    heights[power] = random(-displace/2.0, displace/2.0) + displace*3.0/4.0;
    // Start creating the heightmap
    for (int i = 1; i < power; i *= 2) {
        displace *= roughness;
        // Iterate through each segment, calculating the center point
        for (int j = (power / i) / 2; j < power; j += power / i) {
            float heightCenterPoint = ((heights[j - (power / i) / 2] + heights[j + (power / i) / 2]) / 2);
            heights[j] = heightCenterPoint + random(-displace/2.0, displace/2.0);
        }
    }
    // The number of total land segments should be equal to the size of
    // the arraylist - 1
    float heightmapSize = power;
    float numSegments = heightmapSize - 1;
    // Find the stepping distance for constructing the terrain given
    // the number of segments
    float steppingDistance = WIDTH / (numSegments);
    // Start iterating through the 2D heightmap array and rendering
    // the terrain.
    for (int index = 0; index < heightmapSize - 1; index++) {
        // Find the heights for the quad
        float h1 = heights[index];
        float h2 = heights[index+1];
        // Find the x positions for the quad
        float x1 = steppingDistance * index;
        float x2 = steppingDistance * (index + 1);
        // Draw the quad to the screen
        surface.quad(x1, equator, x1, equator-h1,
             x2, equator-h2, x2, equator);
    }
}
