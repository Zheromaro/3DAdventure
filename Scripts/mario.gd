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

@export_subgroup("camera")
@export var min_pitch: float = -89.9
@export var max_pitch: float = 50

@export var min_yaw: float = 0
@export var max_yaw: float = 360

@export var mouse_sensitivity: float = 0.05
@onready var _player_pcam: PhantomCamera3D = %PlayerPhantomCamera

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

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		
		if _player_pcam.get_follow_mode() == _player_pcam.FollowMode.THIRD_PERSON:
			var pcam_rotation_degrees : Vector3
			
			# Assigns the current 3D rotation of the SpringArm3D node - so it starts off where it is in the editor
			pcam_rotation_degrees = _player_pcam.get_third_person_rotation_degrees()
			
			# Change the X rotation
			pcam_rotation_degrees.x -= event.relative.y * mouse_sensitivity
			
			# Clamp the rotation in the X axis so it go over or under the target
			pcam_rotation_degrees.x = clampf(pcam_rotation_degrees.x, min_pitch, max_pitch)
			
			# Change the Y rotation value
			pcam_rotation_degrees.y -= event.relative.x * mouse_sensitivity
			
			# Sets the rotation to fully loop around its target, but witout going below or exceeding 0 and 360 degrees respectively
			pcam_rotation_degrees.y = wrapf(pcam_rotation_degrees.y, min_yaw, max_yaw)
			
			# Change the SpringArm3D node's rotation and rotate around its target
			_player_pcam.set_third_person_rotation_degrees(pcam_rotation_degrees)
