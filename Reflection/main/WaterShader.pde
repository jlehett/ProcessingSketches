class WaterPass implements Pass {
    PShader shader;

    public WaterPass() {
        shader = loadShader("WaterFrag.glsl");
    }

    public void setUniforms() {
        shader.set("equator", HEIGHT-terrainEquator);
        shader.set("resY", HEIGHT);
        shader.set("resX", WIDTH);
    }

    @Override
    public void prepare(Supervisor supervisor) {
        // Set parameters of the shader if needed
    }

    @Override
    public void apply(Supervisor supervisor) {
        PGraphics pass = supervisor.getNextPass();
        supervisor.clearPass(pass);

        pass.beginDraw();
        pass.shader(shader);
        pass.image(supervisor.getCurrentPass(), 0, 0);
        pass.endDraw();
    }
}