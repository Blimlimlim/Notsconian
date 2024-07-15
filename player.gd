extends Area2D


var area_type = "player"
var speed = Globals.PLAYER_SPEED
var velocity = Vector2.UP * speed # initial movement
var alive = true # player can control ship while true
var killable = true

signal sent_location(player_position: Vector2)
signal collided # TODO may be unused
signal died

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# handle wasd presses
	if Input.is_action_pressed("face_direction") and alive: # only make changes to velocity and rotation if a direction is pressed
		velocity = Vector2.ZERO # set velocity to 0 so only pressed keys determine direction
		var rotation_bias = 0 # used to determine diagonal sprite rotation
		if Input.is_action_pressed("faceup"):
			velocity.y = -1 # set movement direction
			rotation = 0 # set rotation in radians
			rotation_bias = PI / 4 # only up and down change bias from zero
		if Input.is_action_pressed("facedown"):
			velocity.y = 1
			rotation = PI
			rotation_bias = -(PI / 4)
		if Input.is_action_pressed("faceleft"):
			velocity.x = -1
			rotation = (PI * 1.5) + rotation_bias # left and right use the bias afterward to adjust their rotation
		if Input.is_action_pressed("faceright"):
			velocity.x = 1
			rotation = (PI / 2) - rotation_bias
			
	# set velocity length to 1 so diagnal is not faster and multipy by speed
	velocity = velocity.normalized() * speed
	# update position
	position += velocity * delta
	
	if Input.is_action_just_pressed("Fire") and alive: # finally add beam on fire
		pass
		var front_beam = new_beam(velocity, rotation)
		var back_beam = new_beam(velocity * -1, rotation + PI)
		#var front_beam = Beam.new_beam(velocity, position, rotation)
		#var back_beam = Beam.new_beam(velocity * -1, position, rotation + PI)
		add_sibling(front_beam) # beam instance gets added to parent scene
		add_sibling(back_beam)
		$BeamSound.play()
		
		

#func _on_body_entered(body):
	#collided.emit() # emit our signal
	#$AnimatedSprite2D.animation = "explode" # $ is same as get_node used to get a child node
	#$CollisionShape2D.set_deferred("disabled", true) # set this property

func new_beam(beam_velocity:Vector2, beam_rotation) -> Beam:
	var beam: Beam = Globals.packed_beam.instantiate() #create instance
	beam.velocity = beam_velocity.normalized() * beam.speed  #set velocity
	beam.position = position
	beam.rotation = beam_rotation
	return beam

func respawn():
	
	$AnimatedSprite2D.play("default")
	position = Vector2(0,0) # move player to center
	show()
	killable = false
	$CollisionShape2D.set_deferred("disabled", false)
	$FlyingSound.play()
	alive = true
	$InvulnerableTime.start()
	

func _on_area_entered(area):
	if area.area_type == "enemy" or area.area_type == "obstacle":
		if killable:
			collided.emit() # emit our signal
			var animation_sprite = $AnimatedSprite2D
			animation_sprite.animation = "explode" # $ is same as get_node used to get a child node
			if not animation_sprite.is_playing():
				animation_sprite.play()
				
			$CollisionShape2D.set_deferred("disabled", true) # set this property (disable collision)
			$FlyingSound.stop()
			$ExplodeSound.play()
			alive = false

func _on_animated_sprite_2d_animation_finished():
	hide()
	died.emit() # once animation is done tell main what happened


func _on_timer_timeout():
	sent_location.emit(position)


func _on_invulnerable_time_timeout():
	killable = true
