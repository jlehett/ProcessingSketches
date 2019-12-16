#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D t1, t2, t3, t4; 
uniform sampler2D s1, s2, s3, s4, s5, s6, s7, s8;
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
    if (inSampler(s8)) gl_FragColor = colorInTexture(t1);
    else if (inSampler(s7)) gl_FragColor = colorInTexture(t2);
    else if (inSampler(s6)) gl_FragColor = colorInTexture(t3);
    else if (inSampler(s5)) gl_FragColor = colorInTexture(t2);
    else if (inSampler(s4)) gl_FragColor = colorInTexture(t1);
    else if (inSampler(s3)) gl_FragColor = colorInTexture(t2);
    else if (inSampler(s2)) gl_FragColor = colorInTexture(t3);
    else if (inSampler(s1)) gl_FragColor = colorInTexture(t2);
    else gl_FragColor = colorInTexture(t4);
}