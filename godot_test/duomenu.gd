extends VBoxContainer
var players:Node 
const PLAYER = preload("res://player/player.tscn")
const Main = preload("res://main/main.tscn")
var peer = ENetMultiplayerPeer.new()
var main
var Players
# Called when the node enters the scene tree for the first time.
func _ready():
	#main = Main.instantiate()
	main = get_tree().get_root().get_node("main")
	Players = main.get_node("Players")
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _on_return_pressed():
	get_tree().change_scene_to_file("res://UI/begin.tscn")


func _on_create_pressed():
	var error = peer.create_server(7788)
	if error != OK:
		printerr("创建服务器失败，错误码", error)
		return
	else:
		print("创建服务器成功")
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	add_player(multiplayer.get_unique_id())

func _on_peer_connected(id: int):
	#get_tree().get_root().add_child(main)
	print("有玩家连接，ID：",id)
	add_player(id)
	pass
func add_player(id: int):
	var player = PLAYER.instantiate()
	player.name = str(id)
	Players.add_child(player)
func _on_join_pressed():
	peer.create_client("127.0.0.1",7788)
	multiplayer.multiplayer_peer = peer
	pass # Replace with function body.
