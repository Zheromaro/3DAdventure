extends ActionLeaf

var input_dir
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func before_run(actor: Node, blackboard: Blackboard) -> void:
	input_dir = -abs(Vector3.FORWARD.rotated(Vector3.UP, actor.rotation.y))

func tick(actor: Node, blackboard: Blackboard) -> int:
	if not actor.is_on_floor():
		actor.velocity.y -= gravity 
	
	var direction = (actor.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	actor.velocity.x = direction.x * blackboard.get_value("Speed")
	actor.velocity.z = direction.z * blackboard.get_value("Speed")
	
	actor.move_and_slide()
	return SUCCESS

