module utils;

import std::core;
import raylib6;

fn RLShader load_shader(ZString vs_file, ZString fs_file) {
	ZString vs_code = vs_file ? rl::load_file_text(vs_file) : null;
	ZString fs_code = fs_file ? rl::load_file_text(fs_file) : null;
	defer free(vs_code);
	defer free(fs_code);

	return load_shader_from_memory(vs_code, fs_code);
}

fn RLShader load_shader_from_memory(ZString vs_code, ZString fs_code) {
	@pool() {
		DString vs_final = dstring::temp();
		if (vs_code) {
			vs_final.append(SHADER_HEADER_VERT);
			vs_final.append(vs_code.str_view());
		}

		DString fs_final = dstring::temp();
		if (fs_code) {
			fs_final.append(SHADER_HEADER_FRAG);
			fs_final.append(fs_code.str_view());
		}

		return rl::load_shader_from_memory(
			vs_code ? vs_final.zstr_view() : null,
			fs_code ? fs_final.zstr_view() : null);
	};
}

// Available helpers (both versions):
//
// I/O
//   IN, OUT                 - attribute/varying qualifiers
//   FRAG_COLOR              - fragment shader color output
//
// Sampling
//   TEXTURE_2D(s,uv)        - sampler2D
//   TEXTURE_CUBE(s,uv)      - samplerCube
//
// Precision (no-op on desktop)
//   HIGHP, MEDIUMP, LOWP
//
// Math
//   saturate(x)             - clamp(x, 0, 1)
//   remap(v,a,b,c,d)        - remap v from [a,b] to [c,d]
//
// Constants
//   PI, TWO_PI, HALF_PI, INV_PI, SQRT2

const String SHADER_HELPERS @local = `
#define saturate(x) clamp((x), 0.0, 1.0)
#define remap(v,a,b,c,d) mix((c),(d),((v)-(a))/((b)-(a)))
#define PI 3.14159265358979323846
#define TWO_PI 6.28318530717958647692
#define HALF_PI 1.57079632679489661923
#define INV_PI 0.31830988618379067154
#define SQRT2 1.41421356237309504880
`;

const String SHADER_HEADER_VERT @local @if(env::WASM) = `#version 100
precision mediump float;
#define IN attribute
#define OUT varying
#define TEXTURE_2D texture2D
#define TEXTURE_CUBE textureCube
#define HIGHP highp
#define MEDIUMP mediump
#define LOWP lowp
#define _VERT` +++ SHADER_HELPERS;

const String SHADER_HEADER_FRAG @local @if(env::WASM) = `#version 100
precision mediump float;
#define IN varying
#define FRAG_COLOR gl_FragColor
#define TEXTURE_2D texture2D
#define TEXTURE_CUBE textureCube
#define HIGHP highp
#define MEDIUMP mediump
#define LOWP lowp
#define _FRAG` +++ SHADER_HELPERS;

const String SHADER_HEADER_VERT @local @if(!env::WASM) = `#version 330 core
#define IN in
#define OUT out
#define TEXTURE_2D texture
#define TEXTURE_CUBE texture
#define HIGHP
#define MEDIUMP
#define LOWP
#define _VERT` +++ SHADER_HELPERS;

const String SHADER_HEADER_FRAG @local @if(!env::WASM) = `#version 330 core
#define IN in
out vec4 FRAG_COLOR;
#define TEXTURE_2D texture
#define TEXTURE_CUBE texture
#define HIGHP
#define MEDIUMP
#define LOWP
#define _FRAG` +++ SHADER_HELPERS;
