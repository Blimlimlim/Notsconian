extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_main_player_moved(player_buffer_location):
	pass
	#text = String.num_int64(player_buffer_location, 2, true)


func _on_player_sent_location(player_position):
	text = str(player_position)
