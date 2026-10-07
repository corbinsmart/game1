var WhiteColor = #FFFFFF
var BlueColor = #8393CA
var PinkColor = #F16EAA

draw_set_font(fFont)
draw_set_halign(fa_center)
draw_set_valign(fa_center)

// score during game
if STARTED and ALIVE {
	draw_set_colour(BlueColor)
	draw_set_alpha(0.4)
	
	var Text = string(SCORE)
	var X = room_width * 0.5
	var Y = room_height * 0.5
	draw_text(X,Y,Text)
}

// score during game over
else if not ALIVE {
	draw_set_colour(PinkColor)
	draw_set_alpha(0.4)
	
	var Text = "you got " + string(SCORE) + " pts"
	var X = room_width * 0.5
	var Y = room_height * 0.43
	draw_text(X,Y,Text)
}

// when done,
// set alpha back to 1
// for the rest of the ui
draw_set_alpha(1)