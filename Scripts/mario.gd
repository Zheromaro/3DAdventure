extends CharacterBody3D

@export var spring_arm_3d: SpringArm3D 
@export var model: MeshInstance3D

@export var speed := 7.0

@export_subgroup("jump")
@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity := (2.0 * jump_height) / jump_time_to_peak
@onready var jump_gravity := (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity := (-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)

func _physics_process(delta: float) -> void:
	var move_diraction := Vector3.ZERO
	move_diraction.x = Input.get_action_strength("Left") - Input.get_action_strength("Right")
	move_diraction.z = Input.get_action_strength("Back") - Input.get_action_strength("Forward")
	move_diraction = move_diraction.rotated(Vector3.UP, spring_arm_3d.rotation.y).normalized()
	
	velocity.x = move_diraction.x * speed
	velocity.z = move_diraction.z * speed
	
	if not is_on_floor():
		velocity.y += get_gravity()
	
	
	if is_on_floor() and Input.is_action_just_pressed("Jump"):
		jump()
	
	move_and_slide()
	
	if velocity.length() > 0.2:
		var look_direction := Vector2(velocity.z, velocity.x)
		model.rotation.y = look_direction.angle()

func _process(delta: float) -> void:
	spring_arm_3d.position = position

func get_gravity():
	return jump_gravity if velocity.y > 0.0 else fall_gravity 

func jump():
	velocity.y = jump_velocity
