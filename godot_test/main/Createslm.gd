extends Button

var slm_scene = preload("res://enemy/slm_green.tscn")
var player: Player
var main:Node2D
func _enter_tree():
	set_multiplayer_authority(name.to_int())
# Called when the node enters the scene tree for the first time.
func _ready():
	player = $"../.."
	main = get_tree().get_root().get_node("main")
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _on_button_down():
	var slm = slm_scene.instantiate()
	main.add_child(slm)
	var offset_range = Vector2(500, 500) # 定义生成范围
	var random_offset = Vector2(randf_range(-offset_range.x, offset_range.x), randf_range(-offset_range.y, offset_range.y))
	slm.global_position = player.global_position + random_offset
	print("生成了")
