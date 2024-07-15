extends Arc_Ship
class_name Bug_Ship

# Called when the node enters the scene tree for the first time.
func _ready():
	area_type = "enemy" # overwrites Base_Obstacle field
	points = 50
	speed = Globals.BUGSHIP_SPEED
	angular_speed = Globals.BUGSHIP_ANGLSPEED
	beeline_offset = Globals.ENEMY_BEELINE_SPEED_OFFSET * 0.75
	$Label.text = area_type
	hide_animations()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ship_process(delta)
