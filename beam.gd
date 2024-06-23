class_name Beam
extends Area2D
#TODO implement mirror clones for beams as well to avoid potential glitch
var area_type = "beam"
@export var speed = 1600 # speed for beams
var velocity = Vector2.ZERO * speed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * delta

#static func new_beam(caller_velocity:Vector2, caller_position, caller_rotation) -> Beam: # static method to be used like a constructor
	#var beam: Beam = Preloads.packed_beam.instantiate() #create instance
	#beam.velocity = caller_velocity.normalized() * beam.speed  #set velocity
	#beam.position = caller_position
	#beam.rotation = caller_rotation
	#return beam


func _on_visibleOnScreenNotifier2d_screen_exited():
	queue_free()


func _on_area_entered(_area):
	queue_free()
