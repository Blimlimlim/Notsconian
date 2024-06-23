extends Base_Obstacle
class_name Hex_Orb

var is_core: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	area_type = "enemy"
	free_after_destruct = false # so damaged sprites remain until base is finished
	hide_animations()
	if $CollisionShape2D/SpriteDamage != null:
		$CollisionShape2D/SpriteDamage.hide()
	if $Mirror/SpriteDamage != null:
		$Mirror/SpriteDamage.hide()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_hex_base_named_core(make_core):
	is_core = make_core # Base makes the center component its core
	# only one of the 7 nodes with this script connects to the signal.

