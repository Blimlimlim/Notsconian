extends Node2D
class_name Hex_Base

enum STATE {IDLE, ATTACK, LOCKDOWN, SEND_BULLETSHIP, SENDFORMATION}
var state = STATE.IDLE
var base_points: int = 1000
var orbs_left = 6
var recent_player_position: Vector2

signal named_core(make_core)
signal compromised
signal destroyed_by_player(points: int) # sends points to level score
signal detected_player(player_position) # called when
# Called when the node enters the scene tree for the first time.
func _ready():
	named_core.emit(true) # set base's core
	# Connect orb signals
	for i in range(1, 7):
		get_node("Orb" + str(i)).destroyed_by_player.connect(_on_orb_destroyed_by_player) # get notified when an orb is destroyed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_player_location(player_position: Vector2):
	recent_player_position = player_position
	var base_to_player: Vector2 = player_position - position
	if base_to_player.length() < 500:
		state = STATE.ATTACK
		detected_player.emit(base_to_player)
	else:
		state = STATE.IDLE

func _on_core_area_entered(area):
	if area.area_type == "beam":
		compromised.emit()


func _on_orb_area_entered(area):
	if area.area_type == "beam":
		orbs_left -= 1
	if orbs_left == 0:
		var partial_node_path = "Orb"
		for i in range(1, 7): # silence all the orb explosion sounds
			var orb_path = partial_node_path + str(i)
			# silence orb explosion sounds
			get_node(str(orb_path) + "/CollisionShape2D/ExplodeSound").stop()
			get_node(str(orb_path, "/Mirror/ExplodeSound")).stop()
			
		destroyed_by_player.emit(320) #bonus points for destroying base via orbs
		compromised.emit()

func _on_compromised():
	destroyed_by_player.emit(base_points)
	$Core/CollisionShape2D/AnimatedSprite2D.show()
	$Core/Mirror/AnimatedSprite2D.show()
	
	$Core/CollisionShape2D/Sprite2D.hide()
	$Core/Mirror/Sprite2D.hide()
	
	#TODO make this better
	$Orb1.hide()
	$Orb2.hide()
	$Orb3.hide()
	$Orb4.hide()
	$Orb5.hide()
	$Orb6.hide()
	
	#$BigSlodeSound.play()
	$Core/CollisionShape2D/ExplodeSound.play()
	$Core/Mirror/ExplodeSound.play()
	
	$Core/CollisionShape2D/AnimatedSprite2D.play("default")
	$Core/Mirror/AnimatedSprite2D.play("default")
	


func _on_animated_sprite_2d_animation_finished():
	queue_free()

func _on_orb_destroyed_by_player(points):
	destroyed_by_player.emit(points) # pass points to stage score
