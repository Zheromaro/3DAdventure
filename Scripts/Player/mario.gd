extends CharacterBody3D

@export_subgroup("Movement")
@export var spring_arm: SpringArm3D 
@export var model: Node3D

@export var speed := 7.0
var canMove := true

@export_subgroup("jump")
@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity := (2.0 * jump_height) / jump_time_to_peak
@onready var jump_gravity := (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity := (-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)

@export_subgroup("Asend")
@export var ray_cast: RayCast3D 
@export var navigation_area_path: PackedScene


func _physics_process(delta: float) -> void:
	if canMove == false : return
	
	var move_diraction := Vector3.ZERO
	move_diraction.x = Input.get_action_strength("Left") - Input.get_action_strength("Right")
	move_diraction.z = Input.get_action_strength("Back") - Input.get_action_strength("Forward")
	move_diraction = move_diraction.rotated(Vector3.UP, spring_arm.rotation.y).normalized()
	
	
	velocity.x = move_diraction.x * speed
	velocity.z = move_diraction.z * speed
	velocity.y += get_gravity()
	
	if is_on_floor() and Input.is_action_just_pressed("Jump"):
		Jump()
	
	#if is_on_floor() and Input.is_action_just_pressed("Asend"):
		#Asend()
	
	move_and_slide()
	
	if velocity.length() > 0.2:
		var lookdir = atan2(-velocity.z, velocity.x)
		model.rotation.y = lerp_angle(model.rotation.y, lookdir, 0.2)

func get_gravity() -> float:
	if is_on_floor():
		return 0
	
	return jump_gravity if velocity.y > 0.0 else fall_gravity 

func Jump():
	velocity.y = jump_velocity

func Asend():
	if ray_cast.is_colliding():
		canMove = false
		var navigation_area := navigation_area_path.instantiate()
		add_child(navigation_area)
		navigation_area.position = ray_cast.get_collision_point()
		navigation_area.connect("on_surface",
		 func (surface_position : Vector3):
			position = surface_position
			canMove = true
			)


