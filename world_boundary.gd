extends Area2D

var area_type = "boundary"
@export var vertical: bool # is this a vertical or horizontal boundary?
@export var north_or_west: bool
# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D2.shape.a.y = Globals.MAP_LENGTH + 10 #1152
	$CollisionShape2D2.shape.b.y = -Globals.MAP_LENGTH + 10 #-1152
	if  vertical: # is vertical E & W
		if north_or_west: #W
			position = Vector2.LEFT * Globals.MAP_LENGTH/2
		else: #E
			position = Vector2.RIGHT * Globals.MAP_LENGTH/2
	else: #change dimentions for horizontal bounds N&S
		if north_or_west: #N
			position = Vector2.UP * Globals.MAP_HEIGHT/2
		else: #S
			position = Vector2.DOWN * Globals.MAP_HEIGHT/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



#func _on_area_entered(area):
	#if vertical:
		#area.position.x -= area.position.normalized().x * 5
		#area.position.x *= -1
	#else:
		#area.position.y *= -1


func _on_area_exited(area):
	var parent = area.get_parent()
	if vertical:
		parent.position.x += (-parent.position.x / abs(parent.position.x)) * Globals.WRAP_OFFSET #add offset
		parent.position.x *= -1 # move to opposite side
	else:
		parent.position.y += (-parent.position.y / abs(parent.position.y)) * Globals.WRAP_OFFSET
		parent.position.y *= -1
