extends Node2D

var state = {
	"name": "john",
	"id": 1,
	"health": 5
}

func _ready():
	pass

func setup(payload: Dictionary):
	for key in payload.keys():
		var path = key.replace("_rot", "").replace("_pos", "")
		var node = get_node("Parts/" + path)
		if node != null:
			node.position = str2vec(payload[path + "_pos"])
			node.rotation = payload[path + "_rot"]
	
	$Attack.active = payload["Attack_active"]
	if $Attack.active:
		$Attack.rotation = payload["Attack_rot"]
		$Attack.position = str2vec(payload["Attack_pos"])

func yeet(dir: Vector2):
	$Parts/Torso.apply_central_impulse(dir)
	
func str2vec(inp: String):
	var arr = inp.replace("(", "").replace(")", "").replace(" ", "").split(",")
	return Vector2(arr[0], arr[1])

func _on_HitArea_area_entered(area):
	if area.get_name() == "AttackArea":
		var attack: Node2D = area.get_parent().get_parent()
		var x = attack.power * (attack.position.x - self.position.x)
		var y = attack.power * (attack.position.y - self.position.y)
		self.yeet(Vector2(x, y))

#func serialize():
#	for part in $Parts.get_children():
#		state[part.get_name() + "Pos"] = {
#			"x": part.global_position.x,
#			"y": part.global_position.y
#		}
#		state[part.get_name() + "Rot"] = part.rotation
#	if $Attack.active:
#		state["AttackActive"] = true
#		state["AttackRot"] = $Attack.rotation
#	else:
#		state["AttackActive"] = false
#	var state_serialized = JSON.print(state)
#
#	return state_serialized
