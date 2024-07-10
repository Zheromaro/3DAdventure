extends Area3D

@export var rotation_speed := 2
@onready var game_manager = %GameManager
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(delta: float) -> void:
	rotate_y(deg_to_rad(rotation_speed))


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		game_manager.AddPoint()
		animation_player.play("pikeup")
