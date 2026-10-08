////////////
// constants
////////////

// player
IDLE_MOVE_SPEED = 1
IDLE_ROTATE_SPEED = 1
MOVE_SPEED = 5
ROTATE_SPEED = 5

// rock
ROCK_SPEED = 3
ROCK_COUNT = {
	SMALL: 5,
	MED: 10,
}
ROCK_SCORE = {
	SMALL: 1,
	MED: 5,
}

// bullet
BULLET_SPEED = 5

// gun
GUN_THROW_SPEED = 1

///////////////
// global state
///////////////

IDLE = true
STARTED = false
ALIVE = true
EQUIPPED = noone
INPUT = {
	LEFT: false,
	RIGHT: false,
	FIRE: false,
	START: false,
	RESTART: false,
	QUIT: false,
}
SCORE = 0


////////
// setup
////////

// some game setup stuff
window_set_caption("game1")
game_set_speed(60, gamespeed_fps)

// player setup
direction = 90
speed = 0

// text setup
var Text = instance_find(oText,0)
Text.visible = true