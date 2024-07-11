extends CharacterBody3D

signal on_surface(surface_position : Vector3)

@export var navigation_speed := 2


func _physics_process(delta: float) -> void:
	velocity.y = navigation_speed
	
	move_and_slide()

func _on_navigation_area_body_exited(body: Node3D) -> void:
	on_surface.emit(position)
	queue_free()
