extends ConditionLeaf

@export var ray_casts_to_check: Array[RayCast3D]

func  _ready() -> void:
	print(ray_casts_to_check)

func tick(actor: Node, blackboard: Blackboard) -> int:
	if ray_casts_to_check.size() == 0:
		print("there is no ray cast to check in " + self.name)
		return FAILURE
	
	for ray_cast in ray_casts_to_check:
		if ray_cast.is_colliding():
			return SUCCESS
	
	return FAILURE

