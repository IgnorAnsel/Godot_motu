extends TextureProgressBar
var stats : Stats
var max_health
var current_health
# Called when the node enters the scene tree for the first time.
func _ready():
	stats = $"../Stats"
	max_health = stats.max_health
	self.max_value = max_health
	self.value = max_health
	pass # Replace with function body.
	visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _on_enemy_heal_change():
	if stats.health <= 0:
		visible = false
	else:
		visible = true
	current_health = stats.health
	self.value = current_health
func _on_player_heal_change():
	if stats.health <= 0:
		visible = false
	else:
		visible = true
	current_health = stats.health
	self.value = current_health
