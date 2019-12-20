#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform vec3 color1, color2;
uniform float resX, resY;

float dist(float x1, float y1, float x2, float y2) {
    return sqrt(pow(x1-x2, 2) + pow(y1-y2, 2));
}

float map(float x, float in_min, float in_max, float out_min, float out_max) {
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

void main() {
    float sx = gl_FragCoord.x / 1000.0;
    float sy = gl_FragCoord.y / 1000.0;

    float mixValue = clamp(
        map(
            dist(sx, sy, 0.5, 0.5),
            0.0, dist(0.0, 0.0, 0.5, 0.5), 0.0, 1.0
        ),
        0.0, 1.0
    );

    float r = mix(color1.r, color2.r, mixValue);
    float g = mix(color1.g, color2.g, mixValue);
    float b = mix(color1.b, color2.b, mixValue);

    gl_FragColor = vec4(r, g, b, 0.1);
}