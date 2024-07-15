extends CanvasLayer
var letters1 # array of leftmost letters
var letters2 # array of rightmost letters
var letters1_movement:= [.0,.0,.0,.0,.0] # array of amounts to move leftmost letters each frame
var letters2_movement:= [.0,.0,.0,.0,.0] # starts off without values
var framenum = 300.0

func _ready():
	letters1 = $TitleLetters/Half1.get_children() 
	letters2 = $TitleLetters/Half2.get_children() 
	for i in 5: # math to get the proper values to move the letters each frame
		letters1_movement[i] = (200 + (100*i)) / framenum
		letters2_movement[i] = (-700 + (100*i)) / framenum
	

# -100		1300
# Node letters move to 100-500, Node2 letters move 600-1000
# 200,300,400,500,600		-700,-600,-500,-400,-300
func _process(delta): # move in 120 frames
	if framenum >= 0: # move letters
		for i in 5:
			letters1[i].position.x += letters1_movement[i]
			letters2[i].position.x += letters2_movement[i]
		framenum -= 1
	else: # change letters color
		if $ColorRect.modulate.v >= 0:
			$TitleLetters.modulate.g -= 0.00238
			$TitleLetters.modulate.b -= 0.002
			$ColorRect.modulate.v -= 0.0025

