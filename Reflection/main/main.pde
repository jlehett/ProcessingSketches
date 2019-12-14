import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

// Window constants
int HEIGHT = 900;
int WIDTH = 900;

// Scene parameters
int sunPosX = 600;
int sunPosY = 400;
int sunRadius = 150;

color skyColor1 = #ef798a;
color skyColor2 = #ffaf87;

int terrainEquator = 700;
int terrainMaxHeight1 = 300;
int terrainMaxHeight2 = 200;
int terrainMaxHeight3 = 100;
color terrainColor1 = #832232;
color terrainColor2 = #370031;
color terrainColor3 = #0b0033;
float terrainRoughness1 = 0.55;
float terrainRoughness2 = 0.55;
float terrainRoughness3 = 0.5;
float fogOffset1 = -100.0;
float fogOffset2 = -10.0;
float fogOffset3 = 0.0;
float fogStrength1 = 0.65;
float fogStrength2 = 0.5;
float fogStrength3 = 0.35;


// PGraphics objects
PGraphics terrain, sky, water;

// PShader objects
PShader skyShader, sunBloomShader;
PShader terrain1Shader, terrain2Shader, terrain3Shader;


void setup() {
    // MAKE SURE SIZE HAS THE SAME ARGUMENTS AS HEIGHT AND WIDTH
    size(900, 900, P2D);
    smooth(8);

    loadShaders();

    // Create the sky
    sky = createGraphics(WIDTH, HEIGHT, P2D);
    sky.beginDraw();
    drawSky(sky);
    sky.endDraw();

    // Create the terrain
    terrain = createGraphics(WIDTH, HEIGHT, P2D);
    terrain.beginDraw();
    createTerrain(terrain);
    terrain.endDraw();

    // Create the water
    water = createGraphics(WIDTH, HEIGHT, P2D);
    water.beginDraw();
    drawWater(water, 700, color(80, 80, 148));
    water.endDraw();
}

void draw() {
    // Create the sky
    sky.beginDraw();
    sunPosX = mouseX;
    sunPosY = mouseY;
    drawSky(sky);
    sky.endDraw();
    
    // Blit all of the images to the screen
    image(sky, 0, 0);
    image(terrain, 0, 0);
    image(water, 0, 0);
}

void createTerrain(PGraphics surface) {
    // Create background terrain
    {
        // Set shader uniforms
        terrain1Shader.set("equator", HEIGHT-terrainEquator);
        terrain1Shader.set("maxHeight", terrainMaxHeight1);
        terrain1Shader.set("r", red(terrainColor1));
        terrain1Shader.set("g", green(terrainColor1));
        terrain1Shader.set("b", blue(terrainColor1));
        terrain1Shader.set("fogOffset", fogOffset1);
        terrain1Shader.set("fogStrength", fogStrength1);
        surface.shader(terrain1Shader);
        for (int i = 0; i < 5; i++) {
            drawTerrain(
                surface, terrainEquator, terrainRoughness1, terrainMaxHeight1
            );
        }
    }
    // Create middleground terrain
    {
        // Set shader uniforms
        terrain2Shader.set("equator", HEIGHT-terrainEquator);
        terrain2Shader.set("maxHeight", terrainMaxHeight2);
        terrain2Shader.set("r", red(terrainColor2));
        terrain2Shader.set("g", green(terrainColor2));
        terrain2Shader.set("b", blue(terrainColor2));
        terrain2Shader.set("fogOffset", fogOffset2);
        terrain2Shader.set("fogStrength", fogStrength2);
        surface.shader(terrain2Shader);
        for (int i = 0; i < 5; i++) {
            drawTerrain(
                surface, terrainEquator, terrainRoughness2, terrainMaxHeight2
            );
        }
    }
    // Create foreground terrain
    {
        // Set shader uniforms
        terrain3Shader.set("equator", HEIGHT-terrainEquator);
        terrain3Shader.set("maxHeight", terrainMaxHeight3);
        terrain3Shader.set("r", red(terrainColor3));
        terrain3Shader.set("g", green(terrainColor3));
        terrain3Shader.set("b", blue(terrainColor3));
        terrain3Shader.set("fogOffset", fogOffset3);
        terrain3Shader.set("fogStrength", fogStrength3);
        surface.shader(terrain3Shader);
        for (int i = 0; i < 5; i++) {
            drawTerrain(
                surface, terrainEquator, terrainRoughness3, terrainMaxHeight3
            );
        }
    }
}

void drawSky(PGraphics surface) {
    // Set the sun's position in both shaders
    skyShader.set("sunPosX", sunPosX + sunRadius/2);
    skyShader.set("sunPosY", HEIGHT - sunPosY - sunRadius/2);
    skyShader.set("sunRadius", sunRadius/2);

    sunBloomShader.set("sunPosX", sunPosX + sunRadius/2);
    sunBloomShader.set("sunPosY", HEIGHT - sunPosY - sunRadius/2);
    sunBloomShader.set("sunRadius", sunRadius/2);

    // Set the sky colors in the skyShader
    skyShader.set("r1", red(skyColor1));
    skyShader.set("g1", green(skyColor1));
    skyShader.set("b1", blue(skyColor1));
    skyShader.set("r2", red(skyColor2));
    skyShader.set("g2", green(skyColor2));
    skyShader.set("b2", blue(skyColor2));

    // Draw the sky gradient with the skyShader
    surface.shader(skyShader);
    surface.rect(0, 0, WIDTH, HEIGHT);
    // Draw the sun bloom with the sunBloomShader
    surface.shader(sunBloomShader);
    surface.rect(0, 0, WIDTH, HEIGHT);
}

void drawWater(PGraphics surface, float equator, color c) {
    surface.fill(c);
    surface.noStroke();
    surface.quad(0, HEIGHT, 0, equator, WIDTH, equator, WIDTH, HEIGHT);
}

void drawTerrain(
    PGraphics surface, float equator, float roughness, float displace
    ) {
    // Choose a color for the terrain
    surface.fill(255);
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

void loadShaders() {
    skyShader = loadShader("SkyFrag.glsl");
    sunBloomShader = loadShader("SunBloomFrag.glsl");
    terrain1Shader = loadShader("TerrainFrag.glsl");
    terrain2Shader = loadShader("TerrainFrag.glsl");
    terrain3Shader = loadShader("TerrainFrag.glsl");
}