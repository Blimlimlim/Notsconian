extends Node2D
class_name Hex_Base

var orbs_left = 6

signal named_core(make_core)
signal compromised

# Called when the node enters the scene tree for the first time.
func _ready():
	named_core.emit(true) # set base's core
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func explode_base():
	pass # explode animation
	# free base on finish
	#queue_free()

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
			
		compromised.emit()

func _on_compromised():
	
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
	
	#explode_base()


func _on_animated_sprite_2d_animation_finished():
	queue_free()
