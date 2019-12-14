#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform int equator, maxHeight;
uniform float r, g, b, fogOffset, fogStrength;

float dist(float x1, float y1, float x2, float y2) {
    return sqrt(pow(x1-x2, 2) + pow(y1-y2, 2));
}

float map(float x, float in_min, float in_max, float out_min, float out_max) {
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

void main() {
    float mixValue = map(gl_FragCoord.y - equator + fogOffset, 0.0, maxHeight, 1.0-fogStrength, 1.0);
    mixValue = clamp(mixValue, 1.0-fogStrength, 1.0);

    float newr = mix(r/255.0, 1.0, 1.0-mixValue);
    float newg = mix(g/255.0, 1.0, 1.0-mixValue);
    float newb = mix(b/255.0, 0.9, 1.0-mixValue);
    gl_FragColor = vec4(newr, newg, newb, 1.0);
}