#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform int sunPosX, sunPosY, sunRadius;

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
            distanceFromSun, 0.0, dist(0.0, 0.0, 50.0, 50.0),
            0.0, 1.0
        );
        mixValue = clamp(mixValue, 0.0, 1.0);
        gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0-mixValue);
    }
}