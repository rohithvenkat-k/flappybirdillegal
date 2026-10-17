extends Area2D

@export var speed: float = 320.0
@export var direction: float = 1.0
@export var horizontal_speed: float = 250.0
@export var lifetime: float = 4.0

var age: float = 0.0
var hit_bird: bool = false


func _ready() -> void:
	add_to_group("poop_projectiles")
	body_entered.connect(_on_body_entered)
	queue_redraw()


func _physics_process(delta: float) -> void:
	age += delta
	position.x -= horizontal_speed * delta
	position.y += speed * direction * delta

	if age >= lifetime:
		queue_free()


func _draw() -> void:
	var outline := Color("#422313")
	var brown := Color("#89502D")
	var light_brown := Color("#BD8050")

	var shape := PackedVector2Array([
		Vector2(-13, 9),
		Vector2(-15, 4),
		Vector2(-11, 0),
		Vector2(-7, -2),
		Vector2(-6, -7),
		Vector2(-2, -13),
		Vector2(3, -11),
		Vector2(7, -6),
		Vector2(7, -2),
		Vector2(12, 1),
		Vector2(14, 5),
		Vector2(11, 9),
		Vector2(5, 11),
		Vector2(-7, 11)
	])

	draw_colored_polygon(shape, brown)

	draw_polyline(
		PackedVector2Array([
			Vector2(-13, 9),
			Vector2(-15, 4),
			Vector2(-11, 0),
			Vector2(-7, -2),
			Vector2(-6, -7),
			Vector2(-2, -13),
			Vector2(3, -11),
			Vector2(7, -6),
			Vector2(7, -2),
			Vector2(12, 1),
			Vector2(14, 5),
			Vector2(11, 9),
			Vector2(5, 11),
			Vector2(-7, 11),
			Vector2(-13, 9)
		]),
		outline,
		2.0,
		true
	)

	draw_circle(Vector2(-5, 5), 4.0, light_brown)
	draw_circle(Vector2(4, 4), 4.0, brown)


func _on_body_entered(body: Node2D) -> void:
	if hit_bird:
		return

	if body.is_in_group("bird"):
		hit_bird = true

		if body.has_method("apply_poop_hit"):
			body.apply_poop_hit()

		queue_free()
