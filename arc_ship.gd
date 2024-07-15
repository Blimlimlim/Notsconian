extends Base_Obstacle
class_name Arc_Ship

var speed = Globals.ARCSHIP_SPEED
var beeline_offset = Globals.ENEMY_BEELINE_SPEED_OFFSET
var angular_speed = Globals.ARCSHIP_ANGLSPEED
var collider_rotation = $CollisionShape2D.rotation #UNUSED
var mirror_rotation = $Mirror.rotation #UNUSED
var recent_player_position: Vector2
var near_player: bool = false

signal direction_set(direction) # UNSUSED

# Called when the node enters the scene tree for the first time.
func _ready():
	area_type = "enemy" # overwrites Base_Obstacle field
	points = 80
	$Label.text = area_type
	hide_animations()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ship_process(delta)


func get_player_location(player_position: Vector2):
	recent_player_position = player_position

## Moves the ship toward the player with ai. Meant to be called every frame in _process
func ship_process(delta):
	
	var direction = 0 # not turn (0), turn right (1), or left (-1)
	#NOTE do not rotate the whole node only children such as collision shapes (this will also rotate sprites) Otherwise the mirror will be messed up
	var velocity = Vector2.UP.rotated($CollisionShape2D.rotation) * speed # set current velocity via current rotation
	
	# get vector pointing from enemy to target (player)
	var target_velocity: Vector2 = recent_player_position - position # palyer position - enemy position gives a vector pointing from enemy to player
	var target_vel_mirr: Vector2 = recent_player_position - (position + $Mirror.position) # get vector between mirror image and player
	if target_vel_mirr.length() < target_velocity.length(): # if the mirror is closer, user that in calculating where the enemy should go
		target_velocity = target_vel_mirr
	
	# angle between current velocity and and target velocity
	var angle_diff = velocity.angle_to(target_velocity)
	# get direction to turn this frame
	if angle_diff > 0:
		direction = 1
		direction_set.emit(direction)
	elif angle_diff < 0:
		direction = -1
		direction_set.emit(direction)
	# (with an angle difference of 0, direction will remain 0
	if not near_player: # adjust angle difference to offset to nearest side
		if direction == 1:
			angle_diff -= Globals.ENEMY_ANGLE_OFFSET #offset angle
			if angle_diff > 0: # recompare with new angle
				direction = 1 # reset direction
			elif angle_diff < 0:
				direction = -1
		else: #elif direction == -1:
			angle_diff += Globals.ENEMY_ANGLE_OFFSET
			if angle_diff > 0: # recompare with new angle
				direction = 1 # reset direction
			elif angle_diff < 0:
				direction = -1
		
		# rotate enemy
		var rotation_change = direction * angular_speed * delta
		$CollisionShape2D.rotation += rotation_change
		$Mirror.rotation += rotation_change
		# update velocity
		velocity = Vector2.UP.rotated($CollisionShape2D.rotation) * speed
		# move enemy
		position += velocity * delta
	else:
		speed += beeline_offset
	
		# rotate enemy
		var rotation_change = direction * angular_speed * delta
		$CollisionShape2D.rotation += rotation_change
		$Mirror.rotation += rotation_change
		# update velocity
		velocity = Vector2.UP.rotated($CollisionShape2D.rotation) * speed
		# move enemy
		position += velocity * delta
		speed -= beeline_offset

func _on_direction_set(direction):
	##UNUSED
	pass # Replace with function body.
	#$Label.text = str(direction)


func _on_bounds_hitter_area_entered(area):
	if area.area_type == "player":
		near_player = true


func _on_bounds_hitter_area_exited(area):
	if area.area_type == "player":
		near_player = false


func _on_exploded():
	# turn off flying sound
	$CollisionShape2D/FlyingSound.stop()
	
