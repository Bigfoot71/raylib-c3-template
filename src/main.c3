module main;

import raylib6;
import state;

// ================================
// Local Structures
// ================================

struct Config @local {
	String title;
	int win_w;
	int win_h;
	int t_fps;
	RLConfigFlag flags;
}

// ================================
// Main Callbacks
// ================================

fn void boot(Config* config) {
	config.title = "MyGame";
	config.win_w = 720;
	config.win_h = 720;
	config.t_fps = 60;
	config.flags = WINDOW_RESIZABLE | VSYNC_HINT;
}

fn void init() {
	state::init();
}

fn void quit() {
	state::quit();
}

fn void tick() {
	float dt = rl::get_frame_time();
	rl::@drawing() {
		state::update(dt);
	};
}

// ================================
// Main Entry
// ================================

fn int main(String[] args) @winmain
{
	Config config = {
		.title = "",
		.win_w = 1280,
		.win_h = 720,
		.t_fps = 60,
	};
	boot(&config);

	$if !env::WASM:
		rl::set_config_flags(config.flags);
	$endif

	rl::init_window(config.win_w, config.win_h, (ZString)config.title);
	rl::init_audio_device();

	init();

	$if env::WASM:
		emscripten_set_main_loop(&tick, config.t_fps, 1);
	$else
		rl::set_target_fps(config.t_fps);
		while (!rl::window_should_close()) tick();
	$endif

	quit();

	rl::close_audio_device();
	rl::close_window();

	return 0;
}

// ================================
// Emscripten Stuff
// ================================

alias Em_callback_func = fn void();
extern fn void emscripten_set_main_loop(Em_callback_func func, int fps, int simulate_infinite_loop);
