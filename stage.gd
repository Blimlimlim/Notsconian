extends Node

# the combination of set bits tracks which near-border region the player is in
var player_buffer_location:int = 0b0000 # bit order is W,S,E,N
var hex_bases_left = 0
signal player_moved(player_buffer_location)
signal stage_cleared
# Called when the node enters the scene tree for the first time.
func _ready():
	# Count number of Hex Bases in level
	var partial_path = "HexBase"
	var i: int = 1
	var h_base: Hex_Base = get_node(partial_path + str(i)) # makes string for node path "HexBase1"
	while h_base != null: 
		#connect to base's compromised signal to be notified when a base is destroyed
		h_base.compromised.connect(_on_hex_base_compromised) # see function of argument's name
		hex_bases_left += 1 # add one to our count
		i += 1 # increment
		# update node with new value of i in path string
		h_base = get_node(partial_path + str(i)) 
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#TODO set logic for ending level
func _on_hex_base_compromised():
	hex_bases_left -= 1
	if hex_bases_left == 0:
		pass #end level
		$NextStageTimer.start()

func set_player_location(player_in, buffer): # player in is a bool, buffer is an int 0-3
	var player_in_int = int(player_in) # cast bool to int (1 or 0)
	var player_in_mask = player_in_int << buffer #create mask
	player_buffer_location &= ~(1 << buffer) #reset correct bit 
	player_buffer_location |= player_in_mask # set correct bit if neccessary
	player_moved.emit(player_buffer_location) # report the new buffer region location for game objects to respond to
	#instead of emit, call group function here and pass arguments
	get_tree().call_group("mirrored", "group_mirror_update", player_buffer_location)
	
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


func _on_next_stage_timer_timeout():
	stage_cleared.emit()
