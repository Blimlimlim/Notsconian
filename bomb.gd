extends Beam
class_name Bomb

# Called when the node enters the scene tree for the first time.
func _ready():
	area_type = "enemy"
	$sprite
	#speed = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# rotate sprite
	$Sprite2D.rotation += 12 * delta
	position += velocity * delta
