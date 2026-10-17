extends Node2D

@export var pipe_scene: PackedScene = preload("res://scenes/entities/pipe.tscn")
@export var poop_scene: PackedScene = preload("res://scenes/entities/poop.tscn")

@export var pipe_spawn_x: float = 850.0
@export var pipe_speed: float = 250.0
@export var poop_burst_count: int = 3
@export var poop_burst_delay: float = 0.18

var pipe_pair_count: int = 0
var next_shooter_pair: int = 0


func _ready() -> void:
	randomize()
	_schedule_next_shooter()


func _on_timer_timeout() -> void:
	var new_pipe = pipe_scene.instantiate()
	new_pipe.position = Vector2(
		pipe_spawn_x,
		randf_range(-150.0, 150.0)
	)
	add_child(new_pipe)

	pipe_pair_count += 1

	if pipe_pair_count >= next_shooter_pair:
		_schedule_next_shooter()
		_fire_poop_burst(new_pipe)


func _schedule_next_shooter() -> void:
	next_shooter_pair = pipe_pair_count + randi_range(2, 4)


func _fire_poop_burst(pipe: Node2D) -> void:
	for i in range(poop_burst_count):
		await get_tree().create_timer(poop_burst_delay).timeout

		if not is_inside_tree() or not is_instance_valid(pipe):
			return

		var poop = poop_scene.instantiate()
		add_child(poop)

		var shoot_up := randf() < 0.5
		poop.direction = -1.0 if shoot_up else 1.0
		poop.horizontal_speed = pipe_speed

		poop.global_position = pipe.to_global(Vector2(
			349.0,
			-90.0 if shoot_up else 90.0
		))
