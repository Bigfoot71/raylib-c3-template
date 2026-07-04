module state;

// ================================
// State Structure
// ================================

alias OnInit   = fn void();
alias OnQuit   = fn void();
alias OnEnter  = fn void(void* data);
alias OnExit   = fn void();
alias OnUpdate = fn void(float dt);

struct State {
	String   name;
	OnInit   on_init;
	OnQuit   on_quit;
	OnEnter  on_enter;
	OnExit   on_exit;
	OnUpdate on_update;
}

// ================================
// State Functions
// ================================

fn void init() {
	foreach (s : states) {
		assert(s.on_update != null);
		if (s.on_init != null) {
			s.on_init();
		}
	}
	g_current = states[0];
	if (g_current.on_enter != null) {
		g_current.on_enter(null);
	}
}

fn void quit() {
	foreach (s : states) {
		if (s.on_quit != null) {
			s.on_quit();
		}
	}
}

fn void update(float dt) {
	g_current.on_update(dt);
}

fn void switch_to(String name, void* data = null) {
	foreach (s : states) {
		if (s.name == name) {
			if (g_current.on_exit != null) {
				g_current.on_exit();
			}
			g_current = s;
			if (g_current.on_enter != null) {
				g_current.on_enter(data);
			}
			return;
		}
	}
	unreachable("State not found");
}

// ================================
// State Context
// ================================

State*[] states = {
	&title,
	&game,
};

State* g_current;
