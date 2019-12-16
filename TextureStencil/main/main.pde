
// Set up variables for texture images
PImage image1, image2, image3;
// Set up variables for texture pgrahics objects
PGraphics g1, g2, g3;

// Set up variables for texture stencils
PGraphics s1, s2, s3;

// Set up variables for shaders
PShader textureStencil;

float time = 0.0;

void setup() {
    // Make sure that the arguments to size are the same as WIDTH & HEIGHT
    size(1000, 1000, P2D);

    // Setup textures for shader
    image1 = loadImage("textures/red.jpg");
    g1 = createGraphics(image1.width, image1.height, P2D);
    g1.beginDraw();
    g1.image(image1, 0, 0);
    g1.endDraw();
    image2 = loadImage("textures/gray.jpg");
    g2 = createGraphics(image2.width, image2.height, P2D);
    g2.beginDraw();
    g2.image(image2, 0, 0);
    g2.endDraw();
    image3 = loadImage("textures/marble.jpg");
    g3 = createGraphics(image3.width, image3.height, P2D);
    g3.beginDraw();
    g3.image(image3, 0, 0);
    g3.endDraw();

    // Setup texture stencils
    s1 = createGraphics(width, height, P2D);
    s2 = createGraphics(width, height, P2D);
    s3 = createGraphics(width, height, P2D);

    // Load the shaders
    loadShaders();
}

void draw() {
    renderStencils();
    renderWhole();
}

void renderWhole() {
    // Activate the shader and render the scene
    shader(textureStencil);

    rect(0, 0, width, height);
}

void renderStencils() {
    time += 0.01;
    // Draw in patterns for the stencils. Stencils should consist only
    // of black and white pixels.
    {
        // Render s1
        s1.beginDraw();
        s1.background(255);
        s1.fill(0);
        s1.ellipse(
            width/2 + noise(time+25.0) * 100.0 - 50.0, 
            height/2 + noise(time-50.0) * 100.0 - 50.0, 
            500, 500);
        s1.endDraw();

        // Render s2
        s2.beginDraw();
        s2.background(255);
        s2.fill(0);
        s2.ellipse(
            width/2 + noise(time+50.0) * 300.0 - 150.0, 
            height/2 + noise(time+16.0) * 300.0 - 150.0, 
            300, 300);
        s2.endDraw();

        // Render s3
        s3.beginDraw();
        s3.background(255);
        s3.fill(0);
        s3.ellipse(
            width/2 + noise(time - 16.0) * 500.0 - 250.0, 
            height/2 + noise(time - 28.0) * 500.0 - 250.0, 
            100, 100);
        s3.endDraw();
    }
}

void loadShaders() {
    // Load the texture stencil shader and set its uniforms
    textureStencil = loadShader("shaders/StencilFrag.glsl");
    
    textureStencil.set("t1", g1);
    textureStencil.set("t2", g2);
    textureStencil.set("t3", g3);

    textureStencil.set("s1", s1);
    textureStencil.set("s2", s2);
    textureStencil.set("s3", s3);

    textureStencil.set("resX", width);
    textureStencil.set("resY", height);
}
