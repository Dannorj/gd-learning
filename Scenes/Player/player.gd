extends CharacterBody2D

@export var animator: AnimatedSprite2D
@export var area_2d: Area2D
@export var player_red_material: ShaderMaterial

var _move_speed: float = 100.0
var _jump_speed: float = -300.0
var _dead: bool # If a bool have no default value will be defaulted to false


func _ready() -> void:
	area_2d.body_entered.connect(_on_area_2d_body_entered)

func _physics_process(delta: float) -> void:
	if _dead:
		return
		
	# Gravity
	velocity += get_gravity() * delta # Multiplied * delta to be frame indepentent
	
	# Jump
	if Input.is_action_just_pressed("Jump") && is_on_floor():
		velocity.y = _jump_speed
	
	# Movement
	if Input.is_action_pressed("Right"):
		velocity.x = _move_speed
		animator.flip_h = true
	elif Input.is_action_pressed("Left"):
		velocity.x = -_move_speed
		animator.flip_h = false
	else:
		velocity.x = 0
	
	move_and_slide()
	
	# Animation
	if !is_on_floor():
		animator.play("Jump")
	elif velocity.x != 0:
		animator.play("Run")
	else:
		animator.play("Idle")
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	animator.material = player_red_material
	_dead = true
	animator.stop()
