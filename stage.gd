extends Node

enum Condition {GREEN, YELLOW, RED}
var condition = Condition.GREEN
var stage_score: int = 0
var player_buffer_location:int = 0b0000 # bit order is W,S,E,N. the combination of set bits tracks which near-border region the player is in
var player_exact_position: Vector2
var hex_bases_left = 0
var random = RandomNumberGenerator.new()
signal player_moved(player_buffer_location)
signal stage_cleared(score: int)
# Called when the node enters the scene tree for the first time.
func _ready():
	random.randomize() # seed random number generator
	# Count number of Hex Bases in level
	connect_to_entity_signals("HexBase", "compromised", _on_hex_base_compromised)
	#connect_to_entity_signals("HexBase", "destroyed_by_pslayer", _on_any_destroyed_by_player)
	connect_to_entity_signals("Asteroid", "destroyed_by_player", _on_any_destroyed_by_player)
	#var partial_path = "HexBase"
	#var i: int = 1
	#var h_base: Hex_Base = get_node(partial_path + str(i)) # makes string for node path "HexBase1"
	#while h_base != null: 
		##connect to base's compromised signal to be notified when a base is destroyed
		#h_base.compromised.connect(_on_hex_base_compromised) # see function of argument's name
		#hex_bases_left += 1 # add one to our count
		#i += 1 # increment
		## update node with new value of i in path string
		#h_base = get_node(partial_path + str(i)) 
		

func connect_to_entity_signals(partial_path, signal_name: String, function_name: Callable):
	var i: int = 1
	var node_ref = get_node(partial_path + str(i)) # makes string for node path "HexBase1"
	while node_ref != null: 
		#connect to base's compromised signal to be notified when a base is destroyed
		node_ref.connect(signal_name, function_name)
		if partial_path == "HexBase":
			hex_bases_left += 1 # add one to our count
			node_ref.connect("destroyed_by_player", _on_any_destroyed_by_player)
			
		i += 1 # increment
		# update node with new value of i in path string
		node_ref = get_node(partial_path + str(i)) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#TODO Provide less sudden stage transition in main scene OR implement a wait at the start of the level with sound to indicate a new level
func _on_hex_base_compromised():
	hex_bases_left -= 1
	if hex_bases_left == 0: # all the bases are gone
		#end level
		stage_cleared.emit(stage_score)
		

func set_player_location(player_in, buffer): # player in is a bool, buffer is an int 0-3
	var player_in_int = int(player_in) # cast bool to int (1 or 0)
	var player_in_mask = player_in_int << buffer #create mask
	player_buffer_location &= ~(1 << buffer) #reset correct bit 
	player_buffer_location |= player_in_mask # set correct bit if neccessary
	player_moved.emit(player_buffer_location) # report the new buffer region location for game objects to respond to
	#instead of emit, call group function here and pass arguments
	get_tree().call_group("mirrored", "group_mirror_update", player_buffer_location)

func spawn_enemies(type: PackedScene, amount: int):
	# spawn amount enemies of type in random directions away from player
	for i in amount:
		# Get random spawn direction excluding 0,0 making 24 possible directions using integers -2 to 2
		var direction: Vector2 = Vector2.ZERO
		while direction == Vector2.ZERO: # will re-roll the numbers if 0,0 is rolled
			direction = Vector2(random.randi_range(-2, 2), random.randi_range(-2, 2)).normalized()
		# add enemy in said direction offscreen a radius from the player
		if type.can_instantiate():
			var enemy = type.instantiate()
			#set enemy position
			var enemy_position: Vector2 = player_exact_position + (direction * 900) # 1000 pixels away from player in direction
			# set enemy facing player #TODO solve error
			#var rotate_diff = Vector2.UP.angle_to(player_exact_position - enemy_position)
			#enemy.get_node("CollisionShape2d").rotation += rotate_diff
			#enemy.get_node("Mirror").rotation += rotate_diff
			
			
			
			#adjust for out of bounds position
			@warning_ignore("integer_division")
			if enemy_position.x > Globals.MAP_LENGTH/2:
				enemy_position.x -= (Globals.MAP_LENGTH - 1) # subtract one less than map length
			elif enemy_position.x < -Globals.MAP_LENGTH/2:
				enemy_position.x += (Globals.MAP_LENGTH - 1) # add one less than map length
			if enemy_position.y > Globals.MAP_HEIGHT/2:
				enemy_position.y -= (Globals.MAP_HEIGHT - 1) # subtract one less than map height
			elif enemy_position.y < -Globals.MAP_HEIGHT/2:
				enemy_position.y += (Globals.MAP_HEIGHT - 1) # add one less than map height
			
			enemy.set_position(enemy_position)
			add_child(enemy) #add as child
			enemy.destroyed_by_player.connect(_on_any_destroyed_by_player)



func _on_north_buffer_player_state_changed(player_in, buffer): # runs when player enters or leaves the signaling buffer
	set_player_location(player_in, buffer)


func _on_east_buffer_player_state_changed(player_in, buffer):
	set_player_location(player_in, buffer)


func _on_south_buffer_player_state_changed(player_in, buffer):
	set_player_location(player_in, buffer)


func _on_west_buffer_player_state_changed(player_in, buffer):
	set_player_location(player_in, buffer)

## `player_location`, a vector2 representing the player's reported exact location
func _on_player_sent_location(player_position):
	get_tree().call_group("enemies", "get_player_location", player_position)
	player_exact_position = player_position


func _on_enemy_spawn_timer_timeout():
	var type: PackedScene
	var amount = random.randi_range(1, 2)
	match random.randi_range(0, 2):
		0:
			type = Globals.PACKED_ARC
		1:
			type = Globals.PACKED_BUG
		2:
			type = Globals.PACKED_BULLET
	spawn_enemies(type, amount) # spawn to enemies in random directions


func _on_any_destroyed_by_player(points):
	stage_score += points

func start_code_red():
	condition = Condition.RED
	# Change label to code red
	var label = $CanvasLayer/ConditionLabel
	label.text = "Code: Red"
	var color_rect = $CanvasLayer/ConditionColorRect
	color_rect.color = Color("f50000")
	color_rect.size.x = 109
	$EnemySpawnTimer.wait_time = Globals.CODE_RED_SPAWN_DELAY
	var blink_timer = $CanvasLayer/BlinkTimer
	blink_timer.wait_time = 0.4
	blink_timer.one_shot = false
	blink_timer.start()
	
func start_code_green():
	condition = Condition.GREEN
	var label = $CanvasLayer/ConditionLabel
	label.text = "Code: Green"
	var color_rect = $CanvasLayer/ConditionColorRect
	color_rect.color = Color("06ff06")
	color_rect.size.x = 136
	$EnemySpawnTimer.wait_time = Globals.CODE_GREEN_SPAWN_DELAY
	$CanvasLayer/BlinkTimer.stop()
	$CanvasLayer.show()

func _on_condition_timer_timeout():
	start_code_red()


func _on_blink_timer_timeout():
	$CanvasLayer.visible = not $CanvasLayer.visible
