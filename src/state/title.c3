module state;

import std::math;
import raylib6;

// ================================
// State Definition
// ================================

State title = {
	.name      = "title",
	.on_init   = &title_init,
	.on_quit   = &title_quit,
	.on_enter  = &title_enter,
	.on_exit   = &title_exit,
	.on_update = &title_update,
};

// ================================
// State Callbacks
// ================================

fn void title_init() {

}

fn void title_quit() {

}

fn void title_enter(void* data) {

}

fn void title_exit() {

}

fn void title_update(float dt) {
	if (rl::is_key_pressed(SPACE)) {
		state::switch_to("game");
	}

	rl::clear_background(rl::BLUE);

	const String TEXT = "TITLE";
	Vec2 tsize   = rl::measure_text_ex(rl::get_font_default(), TEXT, 160, 4);
	Vec2 wsize = {(float)rl::get_screen_width(), (float)rl::get_screen_height()};
	rl::draw_text_ex(rl::get_font_default(), TEXT, (wsize - tsize) * 0.5, 160, 4, rl::RAYWHITE);
}
