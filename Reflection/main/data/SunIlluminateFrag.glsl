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
            sunPosY, 450.0, 1200.0,
            0.0, 0.75
        );
        mixValue = clamp(mixValue, 0.0, 0.75);
        gl_FragColor = vec4(0.0, 0.0, 0.05, mixValue);
    }
    else {
        float mixValue = map(
            sunPosY, 0.0, 450.0,
            0.10, 0.0
        );
        mixValue = clamp(mixValue, 0.0, 1.0);
        gl_FragColor = vec4(mixValue*0.8, mixValue*0.8, mixValue, 1.0);
    }
}