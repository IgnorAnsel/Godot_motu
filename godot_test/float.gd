extends Node2D

var velocity = Vector2.ZERO
var gravity = Vector2.ZERO
var mass = 100.0
var tween
var label:Label = null
var text = "-1"
var color = Color(1,1,1,1)
var font_size = 1
var timer:Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	label = $Label
	timer = $Timer
	timer.start()
	label.text = text
	label.modulate = color
	label.scale = Vector2(font_size,font_size)
	tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	#add_child(tween)  # 将Tween节点添加为当前节点的子节点
	# 假设Label节点名为"Label"
	tween.tween_property(label, "modulate", Color(label.modulate.r, label.modulate.g, label.modulate.b, 0),2)
	tween.tween_property(label, "scale", Vector2(0.5, 0.5), 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity += gravity * mass * delta
	position += velocity * delta


func _on_timer_timeout():
	queue_free()
