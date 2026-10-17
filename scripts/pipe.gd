extends Area2D

var speed = 250.0

func _process(delta: float) -> void:
	position.x -= speed * delta
		
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
