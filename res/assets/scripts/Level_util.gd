extends Spatial

func _ready():
	GameVars.current_level = "5"
	GameVars.in_game = true
	GameVars.internal_score = 0
	GameVars.Gui_Node.last_level = true
	GameVars.save_game()
