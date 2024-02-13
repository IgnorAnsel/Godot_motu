extends VBoxContainer
@onready var main_scene = preload("res://main/main.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_start_pressed():
	main_scene = main_scene.instantiate()
	get_tree().get_root().add_child(main_scene)


func _on_option_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()


func _on_duo_pressed():
	get_tree().change_scene_to_file("res://UI/duo.tscn")
