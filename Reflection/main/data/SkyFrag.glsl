#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform int sunPosX, sunPosY, sunRadius;
uniform float r1, r2, g1, g2, b1, b2;

float dist(float x1, float y1, float x2, float y2) {
    return sqrt(pow(x1-x2, 2) + pow(y1-y2, 2));
}

float map(float x, float in_min, float in_max, float out_min, float out_max) {
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

void main() {
    float distanceFromSun = dist(
        gl_FragCoord.x, gl_FragCoord.y, sunPosX, sunPosY
    );

    if (distanceFromSun <= sunRadius) gl_FragColor = vec4(1.0);
    else {
        distanceFromSun -= sunRadius;
        float mixValue = map(
            distanceFromSun, 0.0, dist(0.0, 0.0, 600.0, 600.0),
            0.0, 1.0
        );
        mixValue = clamp(mixValue, 0.0, 1.0);
        float r = mix(r1/255.0, r2/255.0, 1.0-mixValue);
        float g = mix(g1/255.0, g2/255.0, 1.0-mixValue);
        float b = mix(b1/255.0, b2/255.0, 1.0-mixValue);
        gl_FragColor = vec4(r, g, b, 1.0);
    }
}