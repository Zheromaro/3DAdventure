extends CharacterBody3D

@export var speed := 5.0
@export var turning_speed := 0.4 
@export var forward_ray_cast: RayCast3D 
@onready var input_dir = -abs(Vector3.FORWARD.rotated(Vector3.UP, rotation.y))

var canMove = true
var just_casted_collisions = false
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	turn()
	
	if !canMove:
		return
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	move_and_slide()

func turn():
	if forward_ray_cast.is_colliding() and just_casted_collisions == false:
		canMove = false
		just_casted_collisions = true
		var tween = create_tween()
		tween.tween_property(self, "rotation_degrees:y", rotation_degrees.y + 180, turning_speed)
		tween.connect("finished", 
		func(): 
			canMove = true
			just_casted_collisions = false
			)
