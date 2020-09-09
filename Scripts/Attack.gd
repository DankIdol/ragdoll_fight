extends Node2D

signal hit(body)

export var active = false
var power = 3

var state = {}

func _ready():
	pass

func _process(delta):
	$Pivot/AttackArea.monitorable = active
	state["active"] = active

func _on_Area2D_body_entered(body):
	if active:
		emit_signal("hit", body)

func trigger():
	if not active:
		$Pivot/AnimationPlayer.play("hit")
		active = true

func _on_AnimationPlayer_animation_finished(anim_name):
	active = false
