extends Area2D
class_name Base_Obstacle

var area_type = "obstacle"
var entity_buffer_location = 0b0000 #WSEN (cardinal direction order) Represents which buffers this Area2D is inside
var recent_player_location = 0b0000
var free_after_destruct: bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
	#$AnimatedSprite2D.hide()
	hide_animations()
	#move_mirror(Globals.S)
	#position.y += Globals.MAP_HEIGHT # start with object outside the map. (see _on_initial_timer_timeout)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hide_animations():
	$CollisionShape2D/AnimatedSprite2D.hide()
	$Mirror/AnimatedSprite2D.hide()
	
func play_explode(collision_nodepath, animation_nodepath,sprite_nodepath):
	animation_nodepath.show()
	animation_nodepath.play("explode")
	sprite_nodepath.hide()
	collision_nodepath.set_deferred("disabled", true)
	$CollisionShape2D/ExplodeSound.play()
	$Mirror/ExplodeSound.play()
	
	
func move_mirror(cardinal_direction: Vector2):
	$Mirror.position = cardinal_direction

func conditional_mirror_update():
	if entity_buffer_location != 0b0000: # no need to move mirror when entity is on 0b0000
		pass
		# Check which location the player is inside. No need to move when player is on 0b0000
		if recent_player_location == 0b0001: #North
			if (entity_buffer_location & 0b0100) == 0b0100: # South enemies project north
				move_mirror(Globals.N)
		elif recent_player_location == 0b0010: #East
			if (entity_buffer_location & 0b1000) == 0b1000: # W enemies project E
				move_mirror(Globals.E)
		elif recent_player_location == 0b0100: #South
			if (entity_buffer_location & 0b0001) == 0b0001: # N enemies project S
				move_mirror(Globals.S)
		elif recent_player_location == 0b1000: #West
			if (entity_buffer_location & 0b0010) == 0b0010: # E enemeies project W
				move_mirror(Globals.W)
		elif recent_player_location == 0b0011: #NorthEast
			# project S enemies N
			if (entity_buffer_location & 0b0100) == 0b0100: 
				move_mirror(Globals.N)
			# project W enemies E
			if entity_buffer_location == 0b1000: 
				move_mirror(Globals.E)
			# project SW enemies NE
			if entity_buffer_location == 0b1100: 
				move_mirror(Globals.NE)
		elif recent_player_location == 0b0110: #SouthEast
			# project N enemies S
			if (entity_buffer_location & 0b0001) == 0b0001: 
				move_mirror(Globals.S)
			# project W enemies E
			if (entity_buffer_location & 0b1000) == 0b1000: 
				move_mirror(Globals.E)
			# project NW enemies SE
			if entity_buffer_location == 0b1001: 
				move_mirror(Globals.SE)
		elif recent_player_location == 0b1100: #SouthWest
			# project N enemies S
			if (entity_buffer_location & 0b0001) == 0b0001: 
				move_mirror(Globals.S)
			# project E enemies W
			if (entity_buffer_location & 0b0010) == 0b0010: 
				move_mirror(Globals.W)
			# project NE enemies SW
			if entity_buffer_location == 0b0011: 
				move_mirror(Globals.SW)
		elif recent_player_location == 0b1001: #NorthWest
			# project all S enemies N
			if (entity_buffer_location & 0b0100) == 0b0100: 
				move_mirror(Globals.N)
			# project all E enemies W
			if (entity_buffer_location & 0b0010) == 0b0010: 
				move_mirror(Globals.W)
			# project SE enemies NW
			if entity_buffer_location == 0b0110: 
				move_mirror(Globals.NW)
	
func _on_area_entered(area):
	if area.area_type == "buffer": #handle entering buffer
		entity_buffer_location |= (1 << area.buffer_direction) #set the bit corresponding with the buffer
		conditional_mirror_update() # update mirror based on current player and entity locations
	elif area.area_type != area_type and area.area_type != "player" : # if area type is different from yours
		#$AnimatedSprite2D.show()
		#$AnimatedSprite2D.play("explode")
		#$Sprite2D.hide() # hide sprite so only animation is visible
		#$CollisionShape2D.set_deferred("disabled", true) # disable collision
		play_explode($CollisionShape2D, $CollisionShape2D/AnimatedSprite2D, $CollisionShape2D/Sprite2D)
		play_explode($Mirror, $Mirror/AnimatedSprite2D, $Mirror/Sprite2D)
		
		# TODO a hacky fix to a later inheritance problem. Redo later
		if $CollisionShape2D/SpriteDamage != null:
			$CollisionShape2D/SpriteDamage.show()
		if $Mirror/SpriteDamage != null:
			$Mirror/SpriteDamage.show()
		
func _on_area_exited(area): 
	if area.area_type == "buffer": #handle leaving buffer
		entity_buffer_location &= ~(1 << area.buffer_direction) #reset the bit corresponding with the buffer
		conditional_mirror_update() # update mirror based on current player and entity locations

func _on_animated_sprite_2d_animation_finished():
	$CollisionShape2D/AnimatedSprite2D.hide()
	$Mirror/AnimatedSprite2D.hide()
	if free_after_destruct:
		queue_free() # free scene

# player_buffer_location msb-lsb: 3,W; 2,S; 1,E; 0,N
#func _on_main_player_moved(player_buffer_location): # Move the mirror when the player is near one of the edge zones so mirror appears outside world bounds and world appears to loop
	#recent_player_location = player_buffer_location
	#conditional_mirror_update() # update mirror based on current player and entity locations

#try this function on group instead of on player moved
func group_mirror_update(player_buffer_location):
	recent_player_location = player_buffer_location
	conditional_mirror_update() # update mirror based on current player and entity locations

