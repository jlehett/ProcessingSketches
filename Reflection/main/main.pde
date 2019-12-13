// Window constants
float HEIGHT = 900;
float WIDTH = 900;

void setup() {
    // MAKE SURE SIZE HAS THE SAME ARGUMENTS AS HEIGHT AND WIDTH
    size(900, 900, P2D);
    background(171, 171, 206);

    float r = 100;
    float g = 140;
    float b = 120;

    drawTerrain(700, 0.5, 400, color(r*0.4, g*0.4, b*0.4));
    drawTerrain(700, 0.5, 300, color(r*0.6, g*0.6, b*0.6));
    drawTerrain(700, 0.5, 200, color(r*0.8, g*0.8, b*0.8));
    drawTerrain(700, 0.5, 100, color(r, g, b));

    drawWater(700, color(80, 80, 148));
}

void draw() {
    
}

void drawWater(float equator, color c) {
    fill(c);
    noStroke();
    quad(0, HEIGHT, 0, equator, WIDTH, equator, WIDTH, HEIGHT);
}

void drawTerrain(
    float equator, float roughness, float displace,
    color c
    ) {
    // Choose a color for the terrain
    fill(c);
    noStroke();
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
        quad(x1, equator, x1, equator-h1,
             x2, equator-h2, x2, equator);
    }
}
