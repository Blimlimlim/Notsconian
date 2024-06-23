extends Node
class_name Main

var stage_instance: Node
var stage_instance_num: int
# Called when the node enters the scene tree for the first time.
func _ready():
	var packed_stage: PackedScene = load("res://stages/stage_1.tscn")
	if packed_stage:
		stage_instance = packed_stage.instantiate()
		add_child(stage_instance)
		stage_instance_num = 1
		# connect to stage cleared and player died signals
		connect_stage_signals()
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_stage_path(stage_num: int) -> String:
	return "res://stages/stage_" + str(stage_num) + ".tscn"
	
# connect to stage cleared and player died signals
func connect_stage_signals():
	stage_instance.stage_cleared.connect(_on_stage_cleared)
	var player_instance = stage_instance.get_node("Player")
	if is_instance_valid(player_instance):
		player_instance.died.connect(_on_player_died)

# free stage and move to next
func _on_stage_cleared():
	if is_instance_valid(stage_instance):
		stage_instance.queue_free()
		stage_instance = null
		var packed_stage: PackedScene = load(get_stage_path(stage_instance_num+1))
		if packed_stage:
			stage_instance = packed_stage.instantiate()
			add_child(stage_instance)
			stage_instance_num += 1
			connect_stage_signals()
		else:
			#TODO do something else if player runs out of levels
			get_tree().quit() # quit game

func _on_player_died():
	# kill program for now TODO add game over screen
	$QuitTimer.start()

func _on_quit_timer_timeout():
	get_tree().quit() # quit program
