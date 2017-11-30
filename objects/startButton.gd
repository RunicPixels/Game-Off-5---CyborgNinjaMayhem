extends Button
var world
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	world = get_parent().get_parent().get_parent()
	set_process_input(true)
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _pressed():
	_select()
	
func _input(event):
	if !event.is_echo() && world.gameActive == false:
		if event.is_action_pressed("ui_select"):
			_select()

func _select():
	world._reset_game()
	get_parent().hide()