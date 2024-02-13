extends Control

var current_panel_index = 0
var panels = []
var player : Player
func _ready():
	player = get_parent().get_parent()
	panels.append($Panel)  # 假设 Panel1 和 Panel2 是该 Control 节点的子节点
	panels.append($Panel2)
	update_panel_focus()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
		current_panel_index = (current_panel_index + 1) % panels.size()
		update_panel_focus()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
		current_panel_index -= 1
		if current_panel_index < 0:
			current_panel_index = panels.size() - 1
		update_panel_focus()
func update_panel_focus():
	for i in range(panels.size()):
		var panel = panels[i]
		if i == current_panel_index:
			panel.modulate = Color(0.5, 0.5, 0.5)  # 未选中的 Panel 变暗
		else:
			panel.modulate = Color(1, 1, 1)  # 高亮选中的 Panel




