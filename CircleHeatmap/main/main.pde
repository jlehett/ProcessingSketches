
// Array holding all 100 circles in the scene
Circle[] circles = new Circle[100];

// Timers
float prevTime;

void setup() {
    size(1000, 1000);

    // Spawn all circles
    for (int i = 0; i < 100; i++) {
        PVector position = new PVector(
            random(0, width),
            random(0, height)
        );
        float radius = random(width/20/4, width/20/2);

        circles[i] = new Circle(position, radius);
    }

    // Start timer
    prevTime = millis();
}

void draw() {
    background(0);

    float currentTime = millis();
    float timeElapsed = currentTime - prevTime;
    prevTime = currentTime;

    // Update and draw all circles on the screen
    for (int i = 0; i < 100; i++) {
        // Update the circle's position based on its velocity
        circles[i].updateCircle(timeElapsed/1000.0);
        // If circle is now out of bounds, spawn a new one in its place
        if (circles[i].isOutOfBounds()) {
            PVector position = new PVector(
                random(0, width),
                random(0, height)
            );
            float radius = random(width/20/4, width/20/2);

            circles[i] = new Circle(position, radius);
        }
        // Draw the circle
        circles[i].drawCircle();
    }
}