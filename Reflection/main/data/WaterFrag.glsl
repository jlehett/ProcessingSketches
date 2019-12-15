#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform int equator, resY, resX;

float dist(float x1, float y1, float x2, float y2) {
    return sqrt(pow(x1-x2, 2) + pow(y1-y2, 2));
}

float map(float x, float in_min, float in_max, float out_min, float out_max) {
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

vec4 getReflection() {
    vec4 color = vec4(0.0);
    for (int x = -10; x <= 10; x++) {
        color += texture2D(
            texture,
            vec2(
                (gl_FragCoord.x + x) / resX,
                map(gl_FragCoord.y, 0, equator, resY/2.75, equator) / resY
            )
        );
    }
    color /= 20.0;
    return vec4(color.r, color.g, color.b, 1.0);
}

void main() {
    vec4 color;
    if (gl_FragCoord.y <= equator) {
        color = getReflection();
        color = vec4(
        mix(color.r, 0.15, 0.2),
        mix(color.g, 0.15, 0.2),
        mix(color.b, 0.35, 0.2),
        1.0
    );
    } else {
        color = texture2D(texture, 
            vec2(gl_FragCoord.x/resX, gl_FragCoord.y/resY)
        );
    }
    gl_FragColor = color;
}