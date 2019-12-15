import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

// Timers
float time = 0.0;
float waterTimer = 0.0;

// Window constants
int HEIGHT = 1200;
int WIDTH = 1200;

// Scene parameters
int sunPosX = 600;
int sunPosY = 600;
int sunRadius = 100;

float sunCenterX = WIDTH/2.0-25;
float sunCenterY = HEIGHT/2.0;
float sunSpinRadius = WIDTH/2.0;
float sunSpinSpeed = 0.01;
float sunAngle = -PI;

color skyColor1 = color(88, 171, 225);
color skyColor2 = color(250, 245, 236);

int terrainEquator = 900;
int terrainMaxHeight1 = 450;
int terrainMaxHeight2 = 200;
int terrainMaxHeight3 = 100;
color terrainColor1 = color(98, 114, 128);
color terrainColor2 = color(124, 118, 56);
color terrainColor3 = color(132, 126, 114);
float terrainRoughness1 = 0.55;
float terrainRoughness2 = 0.75;
float terrainRoughness3 = 0.65;
float fogOffset1 = -120.0;
float fogOffset2 = -50.0;
float fogOffset3 = 100.0;
float fogStrength1 = 0.65;
float fogStrength2 = 0.5;
float fogStrength3 = 0.15;

float waterSpeed = 0.005;
float waterSmoothness = 0.05;
float waterMagnitude = 50.0;


// PGraphics objects
PGraphics canvas;
PGraphics terrain, sky, sun_postfx, stars;

// PShader objects
PShader skyShader, sunBloomShader, sunIlluminateShader;
PShader terrain1Shader, terrain2Shader, terrain3Shader;

// PostFX objects
PostFXSupervisor supervisor;

WaterPass waterPass;


void setup() {
    // MAKE SURE SIZE HAS THE SAME ARGUMENTS AS HEIGHT AND WIDTH
    size(1200, 1200, P2D);
    smooth(8);

    loadShaders();
    loadFX();

    canvas = createGraphics(WIDTH, HEIGHT, P2D);

    // Create the sky
    sky = createGraphics(WIDTH, HEIGHT, P2D);
    sky.beginDraw();
    drawSky(sky);
    sky.endDraw();

    // Create the stars
    stars = createGraphics(WIDTH, HEIGHT, P2D);
    stars.beginDraw();
    drawStars(stars);
    stars.endDraw();

    // Create the terrain
    terrain = createGraphics(WIDTH, HEIGHT, P2D);
    terrain.beginDraw();
    createTerrain(terrain);
    terrain.endDraw();

    // Create the sunlight postf
    sun_postfx = createGraphics(WIDTH, HEIGHT, P2D);
    sun_postfx.beginDraw();
    applySunPostFX(sun_postfx);
    sun_postfx.endDraw();
}

void draw() {
    clear();
    canvas.beginDraw();
    canvas.clear();
    // Create the sky
    sky.beginDraw();
    sunPosX = round(sunSpinRadius * cos(sunAngle) + sunCenterX);
    sunPosY = round(sunSpinRadius * sin(sunAngle) + sunCenterY);
    drawSky(sky);
    sky.endDraw();

    sunAngle += sunSpinSpeed;

    // Create the sun postFX
    sun_postfx.beginDraw();
    applySunPostFX(sun_postfx);
    sun_postfx.endDraw();
    
    // Blit all of the images to the canvas
    canvas.blendMode(BLEND);
    canvas.tint(255, 255.0);
    canvas.image(sky, 0, 0);
    canvas.image(terrain, 0, 0);
    canvas.endDraw();

    //blendMode();
    supervisor.render(canvas);
    // Apply the water shader
    waterPass.setUniforms();
    supervisor.pass(waterPass);
    supervisor.compose();

    if (sunPosY <= HEIGHT / 2.0) blendMode(ADD);
    else blendMode(BLEND);
    image(sun_postfx, 0, 0);

    time += 1.0;
    if (sunAngle <= -PI + 2.0 * PI) {
        //saveFrame("./output/######.png");
    } //else background(0);
}

void drawStars(PGraphics surface) {
    surface.fill(255);
    surface.noStroke();
    for (int i = 0; i < 100; i++) {
        float scalarSize = random(0.05, 0.15);
        float posX = random(0, WIDTH);
        float posY = random(0, 300);
        star(surface, posX, posY, 5*scalarSize, 70*scalarSize, 5);
    }
}

void applySunPostFX(PGraphics surface) {
    // Clear the surface of all postFX
    surface.clear();
    // Apply sun illumination
    sunIlluminateShader.set("sunPosY", sunPosY);
    
    surface.shader(sunIlluminateShader);
    surface.rect(0, 0, WIDTH, HEIGHT);
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
        for (int i = 0; i < 2; i++) {
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
        for (int i = 0; i < 6; i++) {
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
        for (int i = 0; i < 2; i++) {
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

void star(PGraphics surface, float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  surface.beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    surface.vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    surface.vertex(sx, sy);
  }
  surface.endShape(CLOSE);
}

void loadShaders() {
    skyShader = loadShader("SkyFrag.glsl");
    sunBloomShader = loadShader("SunBloomFrag.glsl");
    terrain1Shader = loadShader("TerrainFrag.glsl");
    terrain2Shader = loadShader("TerrainFrag.glsl");
    terrain3Shader = loadShader("TerrainFrag.glsl");
    sunIlluminateShader = loadShader("SunIlluminateFrag.glsl");
}

void loadFX() {
    // Load supervisor
    supervisor = new PostFXSupervisor(this);
    // Load water pass
    waterPass = new WaterPass();
}
