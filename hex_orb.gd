extends Base_Obstacle
class_name Hex_Orb

var is_core: bool = false
#var fire_mode: bool = false #set back to false after firing
var relative_player_position: Vector2 # vector from orb to player
var relative_player_angle
# Called when the node enters the scene tree for the first time.
func _ready():
	area_type = "enemy"
	points = 30
	free_after_destruct = false # so damaged sprites remain until base is finished
	hide_animations()
	if $CollisionShape2D/SpriteDamage != null:
		$CollisionShape2D/SpriteDamage.hide()
	if $Mirror/SpriteDamage != null:
		$Mirror/SpriteDamage.hide()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_bomb() -> Bomb:
	var bomb: Bomb = Globals.PACKED_BOMB.instantiate()
	#bomb.position = position
	bomb.velocity = relative_player_position.normalized() * Globals.BOMB_SPEED
	return bomb
	
func fire():
	var bomb: Bomb = new_bomb()
	add_child(bomb)

func _on_hex_base_named_core(make_core):
	is_core = make_core # Base makes the center component its core
	# only one of the 7 nodes with this script connects to the signal.


func _on_hex_base_detected_player(player_position):
	relative_player_position = player_position
	if $FireCooldown.time_left == 0: # cooldown has ended or not started
		var orb_to_player_angle = position.angle_to(player_position)
		if abs(orb_to_player_angle) < 0.8 and not is_destroyed:
			fire()
		$FireCooldown.start() # start timer
	
