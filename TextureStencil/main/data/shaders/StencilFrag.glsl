#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D t1, t2, t3, s1, s2, s3;
uniform int resX, resY;

void main() {
    float sx = gl_FragCoord.x / resX;
    float sy = gl_FragCoord.y / resY;

    if (texture2D(s3, vec2(sx, sy)).r == 0.0) {
        gl_FragColor = texture2D(t3, vec2(sx, sy));
    }
    else if (texture2D(s2, vec2(sx, sy)).r == 0.0) {
        gl_FragColor = texture2D(t2, vec2(sx, sy));
    }
    else if (texture2D(s1, vec2(sx, sy)).r == 0.0) {
        gl_FragColor = texture2D(t1, vec2(sx, sy));
    }
    else gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
}