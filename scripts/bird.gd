extends CharacterBody2D

@export var gravity: float = 900.0
@export var flap_strength: float = -350.0
@export var max_fall_speed: float = 900.0
@export var weight_per_hit: float = 0.75
@export var energy_drain_rate: float = 2.0

var poop_weight: float = 0.0
var energy: float = 100.0
var is_dead: bool = false

func _ready() -> void:
	add_to_group("bird")

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	energy = maxf(energy - energy_drain_rate * delta, 0.0)
	var weight_factor := 1.0 + poop_weight
	var effective_gravity := gravity * weight_factor
	velocity.y += effective_gravity * delta
	velocity.y = minf(velocity.y, max_fall_speed)
	if Input.is_action_just_pressed("flap"):
		var energy_factor := energy / 100.0
		var effective_flap := flap_strength * energy_factor / weight_factor
		velocity.y = effective_flap
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		die()

func apply_poop_hit() -> void:
	if is_dead:
		return
	poop_weight += weight_per_hit

func die() -> void:
	if is_dead: 
		return
	is_dead = true
	velocity = Vector2.ZERO
	print("Game over! Final energy: ", energy)
