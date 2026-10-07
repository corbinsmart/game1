////////
// input
////////

INPUT.LEFT = keyboard_check(vk_left)
INPUT.RIGHT = keyboard_check(vk_right)
INPUT.FIRE = keyboard_check_pressed(vk_space)
INPUT.START = keyboard_check_pressed(vk_enter)
INPUT.RESTART = keyboard_check_pressed(vk_backspace)
INPUT.QUIT = keyboard_check_pressed(vk_escape)

/////////////
// game state
/////////////

function GameStart() {
	// text
	var Text = instance_find(oText,0)
	Text.visible = false
	
	// spawn rocks
	function SpawnRock(RockObj) {
		var X = random(room_width)
		var Y = random(room_height)
		var Rock = instance_create_layer(X, Y, 0, RockObj)
		Rock.speed = ROCK_SPEED
		Rock.direction = random(360)
	}	
	for (var i = 0; i < ROCK_COUNT.SMALL; i++)
		SpawnRock(oRockSmall)
	for (var i = 0; i < ROCK_COUNT.MED; i++)
		SpawnRock(oRockMed)

	// spawn gun
	var GunX = random(room_width)
	var GunY = random(room_height)
	instance_create_layer(GunX, GunY, 0, oGun)
	
	// player
	speed = MOVE_SPEED
	
	// game
	STARTED = true
}

function GameOver() {
	ALIVE = false
	EQUIPPED = noone
	
	// player
	speed = IDLE_MOVE_SPEED
	
	// throw gun
	var Gun = instance_find(oGun,0)
	Gun.direction = random(360)
	Gun.speed = GUN_THROW_SPEED
	
	// game over text
	var Text = instance_find(oText,0)
	Text.image_index = 1
	Text.visible = true
}

function Score(amt) {
	if ALIVE
		SCORE += amt
}

//////
// sim
//////

function SimulateRock(Rock) {
	var HittingEdge = Rock.x <= 0 or Rock.x >= room_width or
	                  Rock.y <= 0 or Rock.y >= room_height
	if HittingEdge {
		Rock.direction += 180
	}
}

function SimulateBullet(Bullet) {
	var HittingEdge = Bullet.x <= 0 or Bullet.x >= room_width or
	                  Bullet.y <= 0 or Bullet.y >= room_height
	if HittingEdge {
		Bullet.direction += 180
	}
	
}

function SimulateGun(Gun) {
	// keep at player pos
	Gun.x = x
	Gun.y = y
	
	if INPUT.FIRE {
		var BulletX = Gun.x + 55
		var BulletY = Gun.y
		var Bullet = instance_create_layer(BulletX,BulletY,0,oBullet)
		Bullet.direction = 0
		Bullet.speed = BULLET_SPEED
	}
}

function SimulatePlayer(Player) {
	if not STARTED {
		if INPUT.LEFT or INPUT.RIGHT
			IDLE = false
		
		if IDLE
			Player.direction += IDLE_ROTATE_SPEED
	}
	
	if ALIVE {
		// rotate
		if INPUT.LEFT {
			Player.direction += ROTATE_SPEED
		}
		else if INPUT.RIGHT {
			Player.direction -= ROTATE_SPEED
		}
	
		// gun
		if EQUIPPED != noone {
			SimulateGun(EQUIPPED)
		}
	}
	
	// edge collision
	var HittingEdge = Player.x <= 0 or Player.x >= room_width or
	                  Player.y <= 0 or Player.y >= room_height
	if HittingEdge {
		Player.direction += 180
	}
	
	// update graphics
	Player.image_angle = Player.direction - 90
	if ALIVE
		Player.image_index = 0
	else
		Player.image_index = 1
}

function SimulateGame() {
	// start
	if not STARTED and INPUT.START {
		GameStart()
	}
	
	// restart
	if INPUT.RESTART {
		game_restart()
	}
	
	// quit
	if INPUT.QUIT {
		game_end()
	}
}

////////////
// collision
////////////

// player / rock
var HitRock = instance_position(x, y, [oRockSmall, oRockMed])
if HitRock != noone {
	speed *= -1
}

// player / gun
var HitGun = instance_position(x, y, oGun)
if EQUIPPED == noone and HitGun != noone {
	EQUIPPED = HitGun
}

// player / bullet
var HitBullet = instance_position(x, y, oBullet)
if HitBullet != noone {
	GameOver()
}

// bullet / rockmed
for (var i = 0; i < instance_number(oBullet); i++) {
	var Bullet = instance_find(oBullet,i)
	var HitRock = instance_position(Bullet.x, Bullet.y, oRockMed)
	if HitRock != noone {
		for (var i = 0; i < 3; i++) {
			var NewRock = instance_create_layer(HitRock.x, HitRock.y, 0, oRockSmall)
			NewRock.speed = ROCK_SPEED
			NewRock.direction = random(360)
		}
		instance_destroy(Bullet)
		instance_destroy(HitRock)
		Score(ROCK_SCORE.MED)
	}
}

// bullet / rocksmall
for (var i = 0; i < instance_number(oBullet); i++) {
	var Bullet = instance_find(oBullet,i)
	var HitRock = instance_position(Bullet.x, Bullet.y, oRockSmall)
	if HitRock != noone {
		instance_destroy(Bullet)
		instance_destroy(HitRock)
		Score(ROCK_SCORE.SMALL)
	}
}

///////////
// simulate
///////////

// sim rocks
for (var i = 0; i < instance_number(oRockSmall); i++) {
    var Rock = instance_find(oRockSmall,i)
	SimulateRock(Rock)
}
for (var i = 0; i < instance_number(oRockMed); i++) {
    var Rock = instance_find(oRockMed,i)
	SimulateRock(Rock)
}

// sim bullets
for (var i = 0; i < instance_number(oBullet); i++) {
    var Bullet = instance_find(oBullet,i)
	SimulateBullet(Bullet)
}

// sim player
var Player = instance_find(oPlayer,0)
SimulatePlayer(Player)

// sim game
SimulateGame()