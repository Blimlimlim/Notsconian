extends Area2D

@export var buffer_direction = 0 # 0=N, 1=E, 2=S, 3=W
@export var horizontal: bool
@export var north_or_west: bool #TODO set this in main
var forceadjust
var area_type = "buffer"
signal player_state_changed(player_in: bool, buffer: int)
# Called when the node enters the scene tree for the first time.
func _ready():
	# set position and dimentions based on map size
	# TODO repalce "thickness" with global constants for camera or screen width/height
	if horizontal:
		var thickness = 324
		$CollisionShape2D.shape.size = Vector2(Globals.MAP_LENGTH, thickness) #horizontal dimentions
		if north_or_west: #north buffer
			position = Vector2.UP * (Globals.MAP_HEIGHT/2 - thickness/2)
		else: #south buffer
			position = Vector2.DOWN * (Globals.MAP_HEIGHT/2 - thickness/2)
	else: 
		var thickness = 576
		$CollisionShape2D.shape.size = Vector2(thickness, Globals.MAP_HEIGHT) #vertical dimentions
		if north_or_west: #west buffer
			position = Vector2.LEFT * (Globals.MAP_LENGTH/2 - (thickness/2))
		else: # east
			position = Vector2.RIGHT * (Globals.MAP_LENGTH/2 - thickness/2)
		
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area): #signal self
	if area.get_parent().area_type == "player":
		#player_in = true
		player_state_changed.emit(true, buffer_direction)

func _on_area_exited(area):
	if area.get_parent().area_type == "player":
		#player_in = false
		player_state_changed.emit(false, buffer_direction)
