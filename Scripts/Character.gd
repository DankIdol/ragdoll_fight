extends Node2D

export var controlled: bool = false
var can_jump: bool = true
var state = {
	"name": "john",
	"id": 1,
	"health": 5
}

func _ready():
	pass

#func setup(payload: Dictionary):
#	remove_child($Joints)
#	for key in payload.keys():
#		var path = key.replace("Rot", "").replace("Pos", "")
#		var node = get_node("Parts/" + path)
#		if node != null:
#			node.position.x = payload[path + "Pos"]["x"]
#			node.position.y = payload[path + "Pos"]["x"]
#			node.rotation = payload[path + "Rot"]
#			node.gravity_scale = 0
#	if payload["AttackActive"]:
#		$Attack.active = true
#		$Attack.rotation = payload["AttackRot"]
#	else: $Attack.active = false
#	controlled = false

func _process(delta):
	$Attack.position = $Parts/Torso.position
	if controlled:
		var mouse = get_global_mouse_position()
		var rot = get_angle_to(mouse)
		$Attack.rotation = rot
	

func _input(event):
	if controlled:
		if event.is_action_pressed("w") and can_jump:
			can_jump = false
			$Parts/Torso.apply_central_impulse(Vector2(0, -1000))
		if event.is_action_pressed("a"):
			$Parts/Torso.apply_central_impulse(Vector2(-1000, 0))
		if event.is_action_pressed("s"):
			$Parts/Torso.apply_central_impulse(Vector2(0, 1000))
		if event.is_action_pressed("d"):
			$Parts/Torso.apply_central_impulse(Vector2(1000, 0))
		if event is InputEventMouseButton and event.get_button_index() == 1:
			$Attack.trigger()

func yeet(dir: Vector2):
	$Parts/Torso.apply_central_impulse(dir)

func _on_HitArea_body_entered(body):
	can_jump = true

func _on_HitArea_area_entered(area):
	if area.get_name() == "AttackArea":
		var attack: Node2D = area.get_parent().get_parent()
		var x = attack.power * (attack.global_position.x - self.global_position.x)
		var y = attack.power * (attack.global_position.y - self.global_position.y)
		self.yeet(Vector2(-x, -y))

func serialize():
	for part in $Parts.get_children():
		state[part.get_name() + "_pos"] = part.global_position
		state[part.get_name() + "_rot"] = part.global_rotation
		
	state["Attack_active"] = $Attack.active
	state["Attack_pos"] = $Attack.global_position
	state["Attack_rot"] = $Attack.global_rotation
		
	var state_serialized = JSON.print(state)
	return state_serialized

func get_state(): return state
