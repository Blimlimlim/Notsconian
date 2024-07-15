extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= 20 * delta


func _on_timer_timeout():
	queue_free()
