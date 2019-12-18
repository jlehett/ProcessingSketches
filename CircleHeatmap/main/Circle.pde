
// Global parameters

float MIN_VEL = 0.1;
float MAX_VEL = 2.0;

// Circle class

class Circle {

    private PVector position, velocity;
    private float radius;

    public Circle(PVector startingPos, float radius) {
        // Set starting position
        this.position = startingPos;
        // Set radius of the circle
        this.radius = radius;
        // Set velocity with MIN_VEL and MAX_VEL bounds
        float flipX, flipY;

        if (random(1) > 0.5) flipX = -1.0;
        else flipX = 1.0;
        if (random(1) > 0.5) flipY = -1.0;
        else flipY = 1.0;

        this.velocity = new PVector(
            random(MIN_VEL, MAX_VEL) * flipX,
            random(MIN_VEL, MAX_VEL) * flipY
        );
    }

    public boolean isOutOfBounds() {
        // Return true if this circle is out of bounds (including radius)
        // Else, return false
        if (this.position.x + this.radius < 0.0) return true;
        else if (this.position.x - this.radius > width) return true;
        else if (this.position.y + this.radius < 0.0) return true;
        else if (this.position.y - this.radius > height) return true;
        else return false;
    }

    public void drawCircle(PGraphics surface) {
        // Draw the circle at its specified coordinates
        surface.stroke(255, 255, 255, 255/2.0);
        surface.noFill();
        surface.strokeWeight(15);
        surface.fill(255, 255, 255, 255/3.0);
        surface.ellipse(this.position.x, this.position.y, 
                this.radius*2, this.radius*2);
    }

    public void updateCircle(float timeElapsed) {
        // Update the circle's position based on its velocity,
        // current position, and time elapsed since last update
        this.position.add(
            this.velocity.copy().mult(timeElapsed)
        );
    }
}