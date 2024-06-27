extends Area3D

@export var rotation_speed := 2


func _process(delta: float) -> void:
	rotate_y(deg_to_rad(rotation_speed))


func _on_body_entered(body: Node3D) -> void:
	queue_free()
