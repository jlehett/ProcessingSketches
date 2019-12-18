#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D circleImage;
uniform int resX, resY;

bool inSampler(sampler2D sampler) {
    float sx = gl_FragCoord.x / resX;
    float sy = gl_FragCoord.y / resY;
    if (texture2D(sampler, vec2(sx, sy)).r == 0.0) return true;
    return false;
}

vec4 colorInTexture(sampler2D texture) {
    float sx = gl_FragCoord.x / resX;
    float sy = gl_FragCoord.y / resY;
    return texture2D(texture, vec2(sx, sy));
}

void main() {
    float sx = gl_FragCoord.x / resX;
    float sy = gl_FragCoord.y / resY;
    vec4 color = texture2D(circleImage, vec2(sx, sy));

    if (color.r <= 0.75) gl_FragColor = vec4(3.0/255.0, 3.0/255.0, 9.0/255.0, 0.25);
    else gl_FragColor = vec4(33.0/255.0, 209.0/255.0, 159.0/255.0, 0.15);
}