#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform int sunPosY, sunRadius;

float dist(float x1, float y1, float x2, float y2) {
    return sqrt(pow(x1-x2, 2) + pow(y1-y2, 2));
}

float map(float x, float in_min, float in_max, float out_min, float out_max) {
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

void main() {
    if (sunPosY >= 450) {
        float mixValue = map(
            sunPosY, 450.0, 800.0,
            0.0, 0.85
        );
        mixValue = clamp(mixValue, 0.0, 0.85);
        gl_FragColor = vec4(0.05, 0.0, 0.175, mixValue);
    }
    else {
        float mixValue = map(
            sunPosY, 0.0, 450.0,
            0.25, 0.0
        );
        mixValue = clamp(mixValue, 0.0, 1.0);
        gl_FragColor = vec4(mixValue, mixValue, mixValue, 1.0);
    }
}