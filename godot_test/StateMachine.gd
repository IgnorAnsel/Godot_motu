class_name StateMachine
extends Node

var current_state: int = -1:
	set(v):
		owner.translate_state(current_state, v)
		current_state = v

# Called when the node enters the scene tree for the first time.
func _ready():
	await  owner.ready
	current_state = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	while true:
		var next := owner.get_next_state(current_state) as int
		if current_state == next:
			break
		else:
			current_state = next
	owner.tick_physics(current_state, delta)
		
