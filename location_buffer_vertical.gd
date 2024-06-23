extends Area2D

@export var placement_side = 0 # 0=N, 1=E, 2=S, 3=W
var player_in: int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	if player_in == 0 or player_in == 2:
		$CollisionShape2D2.shape.Size = Vector2(2304, 324) #horizontal dimentions
	else:
		$CollisionShape2D2.shape.Size = Vector2(576, 1296) #vertical dimentions
		
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
