
int NUM_CIRCLES = 100;

// Array holding all 100 circles in the scene
Circle[] circles = new Circle[NUM_CIRCLES];

// PGraphics object to pass to shader to view circle intersections
PGraphics circleImage;

// Timers
float prevTime;
float time = 0.0;

// PShader object
PShader circleShader;


void setup() {
    size(1200, 1200, P2D);
    background(0);

    smooth(8);

    // Create PGraphics object
    circleImage = createGraphics(width, height, P2D);

    // Load shaders
    loadShaders();

    // Spawn all circles
    for (int i = 0; i < NUM_CIRCLES; i++) {
        PVector position = new PVector(
            random(0, width),
            random(0, height)
        );
        float radius = random(width/20/4, width/20);

        circles[i] = new Circle(position, radius);
    }

    // Start timer
    prevTime = millis();
}

void draw() {
    float currentTime = millis();
    float timeElapsed = currentTime - prevTime;
    prevTime = currentTime;

    // Update and draw all circles on the PGraphics object
    circleImage.beginDraw();
    circleImage.clear();
    for (int i = 0; i < NUM_CIRCLES; i++) {
        // Update the circle's position based on its velocity
        circles[i].updateCircle(timeElapsed/1000.0);
        // If circle is now out of bounds, spawn a new one in its place
        if (circles[i].isOutOfBounds()) {
            PVector position = new PVector(
                random(0, width),
                random(0, height)
            );
            float radius = random(width/20/4, width/10/2);

            circles[i] = new Circle(position, radius);
        }
        // Draw the circle
        circles[i].drawCircle(circleImage);
    }
    circleImage.endDraw();

    // Passing this PGraphics object to the shader, render the final
    // output
    shader(circleShader);
    rect(0, 0, width, height);

    time += 1.0;
    if (time > 20.0 && time < 1.0*60.0*7.0 + 20.0) saveFrame("./output/######.png");
    else background(0);
}

void loadShaders() {
    circleShader = loadShader("shaders/CircleIntersectFrag.glsl");
    circleShader.set("circleImage", circleImage);
    circleShader.set("resX", width);
    circleShader.set("resY", height);
}