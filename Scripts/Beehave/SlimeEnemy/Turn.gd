extends ActionLeaf

var already_turning := false
var finished_turning := false

func before_run(actor: Node, blackboard: Blackboard) -> void:
	already_turning = false
	finished_turning = false

func tick(actor: Node, blackboard: Blackboard) -> int:
	
	if not already_turning:
		already_turning = true
		
		var tween = create_tween()
		
		tween.tween_property( actor
		, "rotation_degrees:y"
		, actor.rotation_degrees.y + 180
		, blackboard.get_value("TurnSpeed"))
		
		tween.connect("finished", func(): 
			print("turn SUCCESS")
			finished_turning = true
		)
	
	if finished_turning:
		return SUCCESS 
	
	print("turn RUNNING")
	return RUNNING

