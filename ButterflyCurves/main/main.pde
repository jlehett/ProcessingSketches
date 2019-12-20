
// Butterfly Curve Parameters
float zoom = 100.0;
float span = 2.0;
float wings = 8.0;
float weirdSnap = 12.0;
float weirdSnap2 = 5.0;
float a = 1.0;

// PShader objects
PShader backgroundShader;


void setup() {
    size(1000, 1000, P2D);
    filter(BLUR, 7);

    backgroundShader = loadShader("shaders/BackgroundShader.glsl");
    backgroundShader.set("color2", 101/255.0, 69/255.0, 151/255.0);
    backgroundShader.set("color1", 226/255.0, 173/255.0, 242/255.0);
    
    shader(backgroundShader);
    rect(0, 0, width, height);
    resetShader();
}

void draw() {
    //background(0);

    shader(backgroundShader);
    rect(0, 0, width, height);
    resetShader();

    PVector origin = new PVector(width/2, height/2);

    PVector prevPoint = null;

    for (float theta = 0.0; theta <= 50.0 * 8.0 * 2.0 * PI; theta += 0.025) {
        float radialDist = (
            pow( exp(1), cos(a * theta) ) -
            span * cos(wings * theta) +
            pow( sin(theta / weirdSnap), weirdSnap2 )
        ) * zoom;

        float x = radialDist * cos(theta) + origin.x;
        float y = radialDist * sin(theta) + origin.y;

        if (prevPoint != null) {
            //if (radialDist < 0.0) radialDist *= -1.0;
            color strokeColor = lerpColor(
                #222a68, #574ae2,
                map(
                  radialDist, 0.0, dist(
                      width/2.0, height/2.0, 0.0, 0.0
                  ), -2.0, 2.0
                )
            );
            stroke(strokeColor, 3);
            line(prevPoint.x, prevPoint.y, x, y);
        }

        prevPoint = new PVector(x, y);
    }

    a -= 0.001;
    zoom = map(noise(a * 50.0), 0.0, 1.0, 50.0, 200.0);

    fill(#efd9ce);
    stroke(0);
    ellipse(width/2, height/2, 10, 10);
}
