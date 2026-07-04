module state;

import std::math;
import raylib6;

// ================================
// State Definition
// ================================

State game = {
	.name      = "game",
	.on_init   = &game_init,
	.on_quit   = &game_quit,
	.on_enter  = &game_enter,
	.on_exit   = &game_exit,
	.on_update = &game_update,
};

// ================================
// State Callbacks
// ================================

fn void game_init() {

}

fn void game_quit() {

}

fn void game_enter(void* data) {

}

fn void game_exit() {

}

fn void game_update(float dt) {
	if (rl::is_key_pressed(SPACE)) {
		state::switch_to("title");
	}

	rl::clear_background(rl::GREEN);

	const String TEXT = "GAME";
	Vec2 tsize   = rl::measure_text_ex(rl::get_font_default(), TEXT, 160, 4);
	Vec2 wsize = {(float)rl::get_screen_width(), (float)rl::get_screen_height()};
	rl::draw_text_ex(rl::get_font_default(), TEXT, (wsize - tsize) * 0.5, 160, 4, rl::RAYWHITE);
}
