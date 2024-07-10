extends Node

var score := 0
@export var score_text: MeshInstance3D 

func AddPoint():
	score += 1
	score_text.mesh.text = "you collected " + str(score) + " coins !!!!!"
