extends Node
class_name Main

var stage_instance: Node
var stage_instance_num: int
var total_score: int = 0
var game_over = false
var additional_lives = 2 # number of times player can die and respawn in level
# Called when the node enters the scene tree for the first time.
func _ready():
	start_title_screen()

func _process(delta):
	if Input.is_action_pressed("quit"):
		$QuitTimer.start()

func start_title_screen():
	var packed_title := load("res://title.tscn")
	if packed_title != null:
		var title: Node = packed_title.instantiate()
		if $TitleTimer.timeout.is_connected(_on_title_timer_timeout):
			$TitleTimer.timeout.disconnect(_on_title_timer_timeout) # disconnect is title screen has been run before so it can connect to the new title screen
		$TitleTimer.timeout.connect(_on_title_timer_timeout.bind(title)) # connect timer signal with title node ref as argument
		title.get_node("SkipButton").released.connect(_on_title_timer_timeout.bind(title))
		add_child(title)
		$TitleTimer.start()
	

func start_first_stage():
	# set number of lives
	additional_lives = 2
	$CanvasLayer/Lives.text = str("Ships Left: " ,additional_lives)
	var packed_stage: PackedScene = load("res://stages/stage_1.tscn")
	if packed_stage:
		stage_instance = packed_stage.instantiate()
		add_child(stage_instance)
		stage_instance_num = 1
		# connect to stage cleared and player died signals
		connect_stage_signals()
		$CanvasLayer/Message.text = "Stage " + str(stage_instance_num)
		$CanvasLayer/Message.show()
		$MessageTimer.start()

func get_stage_path(stage_num: int) -> String:
	return "res://stages/stage_" + str(stage_num) + ".tscn"
	
# connect to stage cleared and player died signals
func connect_stage_signals():
	stage_instance.stage_cleared.connect(_on_stage_cleared)
	var player_instance = stage_instance.get_node("Player")
	if is_instance_valid(player_instance):
		player_instance.died.connect(_on_player_died)

# free stage and move to next
func _on_stage_cleared(score):
	stage_instance.get_node("Player").killable = false
	total_score += score
	$CanvasLayer/FinalScore.text = str(total_score)
	$CanvasLayer/FinalScore.visible = true
	$NextStageTimer.start() # when timer ends, main will transition the stage


func _on_player_died():
	# kill program for now TODO add game over screen
	if additional_lives == 0:
		total_score += stage_instance.stage_score
		$CanvasLayer/FinalScore.text = str(total_score)
		$CanvasLayer/FinalScore.visible = true
		game_over = true
		total_score = 0
		$NextStageTimer.start()
	else:
		stage_instance.start_code_green()
		additional_lives -= 1
		$CanvasLayer/Lives.text = str("Ships Left: " ,additional_lives)
		var player = stage_instance.get_node("Player")
		player.respawn() # respawns player at center after dying
	

func _on_next_stage_timer_timeout():
	if game_over:
		if is_instance_valid(stage_instance): #check that current stage scene exists
			stage_instance.queue_free() # free it
			stage_instance = null
			$CanvasLayer/FinalScore.visible = false
			start_title_screen()
		else:
			$QuitTimer.start()
	else:
		$CanvasLayer/FinalScore.visible = false
		if is_instance_valid(stage_instance): #check that current stage scene exists
			stage_instance.queue_free() # free it
			stage_instance = null
			var packed_stage: PackedScene = load(get_stage_path(stage_instance_num+1)) # increment stage number
			if packed_stage != null: # There is another stage
				stage_instance = packed_stage.instantiate() # create instance of next stage number
				add_child(stage_instance)
				stage_instance.get_node("Player").killable = true
				stage_instance_num += 1 # increment the property tracking the current stage
				connect_stage_signals() # connect to new stage's signals
				$CanvasLayer/Message.text = "Stage " + str(stage_instance_num)
				$CanvasLayer/Message.show()
				$MessageTimer.start()
			else:
				#TODO do something else if player runs out of levels
				$CanvasLayer/FinalScore.text = str(total_score)
				$CanvasLayer/FinalScore.visible = true
				#$QuitTimer.start() # quit game
	game_over = false
	
func _on_quit_timer_timeout():
	get_tree().quit() # quit program


func _on_message_timer_timeout():
	$CanvasLayer/Message.hide()


func _on_title_timer_timeout(title: Node):
	Randomness.random.randomize()
	title.queue_free()
	start_first_stage()
