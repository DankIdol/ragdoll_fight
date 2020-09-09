extends Node2D

var ws = WebSocketClient.new()
var URL = "ws://localhost:9001/"
var character = preload("res://Scenes/Dummy.tscn")
onready var player = $Character
var dummy_data: Dictionary

#func _ready():
#	var c = character.instance()
#	var payload = JSON.parse($Character.serialize()).result
#	print(payload)
#	c.setup(payload)
#	c.position.y += 100
#	add_child(c)

func _ready():
	dummy_data = $Character.get_state()
	ws.connect('connection_closed', self, '_closed')
	ws.connect('connection_error', self, '_closed')
	ws.connect('connection_established', self, '_connected')
	ws.connect('data_received', self, '_on_data')

	var err = ws.connect_to_url(URL)
	if err != OK:
		print('connection refused')

func _closed():
	print("connection closed")
	
func _connected():
	print("connected to host")
	
func _on_data():
	var payload = JSON.parse(ws.get_peer(1).get_packet().get_string_from_utf8()).result
	for e in $Enemies.get_children():
		$Enemies.remove_child(e)
		e.queue_free()
	for config in payload:
		if config["id"] != player.get_state()["id"]:
			var c = character.instance()
			c.setup(config)
			$Enemies.add_child(c)

func _process(delta):
	$Debug.text = "player id: " + str($Character.get_state()["id"])
	var data = $Character.serialize()
	ws.get_peer(1).put_packet(JSON.print(data).to_utf8())
	ws.poll()

