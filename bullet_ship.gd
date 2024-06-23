extends Arc_Ship
class_name Bullet_Ship

# Called when the node enters the scene tree for the first time.
func _ready():
	area_type = "enemy" # overwrites Base_Obstacle field
	speed = Globals.BULLETSHIP_SPEED
	angular_speed = Globals.BULLETSHIP_ANGLSPEED
	$Label.text = area_type
	hide_animations()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ship_process(delta)
