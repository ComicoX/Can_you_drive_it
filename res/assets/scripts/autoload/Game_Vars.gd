extends Node


var Player

var Checkpoint_manager

var next_checkpoint
var current_checkpoint
var total_checkpoints

var Start_TIme

var Gui_Node
var ManiMenu
var Options
var in_game = false


var current_level = "no"
var TutDone = false
var mouse_inverted = false
var fw_key = "no"
var rw_key = "no"
var fullscreen = false

var level_time = ["00:00:00","00:00:00","00:00:00","00:00:00","00:00:00",]

var internal_score = 0

var level_score = [0,0,0,0,0]

func _ready():
	load_game()

func toggle_options(var value, var main_menu = false):
	if(value == true):
		get_tree().paused = true
		Options.show()
		if(!main_menu):
			Gui_Node.hide()
		else:
			ManiMenu.hide()
	else:
		get_tree().paused = false
		Options.hide()
		if(!main_menu):
			Gui_Node.show()
		else:
			ManiMenu.show()
		save_game()

func save():
	if(GameVars.Options):
		mouse_inverted = GameVars.Options.mouse_inverted
		fw_key = GameVars.Options.fw_key
		rw_key = GameVars.Options.rw_key
		fullscreen = GameVars.Options.fullscreen
	else:
		mouse_inverted = false
		fw_key = "no"
		rw_key = "no"
		fullscreen = false

	var save_dict = {
		"level" : current_level,
		"mouse_inverted" : mouse_inverted,
		"fullscreen" : fullscreen,
		"tutDone" : TutDone,
		"Tlvl" : level_time,
		"Slvl" : level_score
	}
	return save_dict

func save_game():
	var save_game = File.new()
	save_game.open("user://config.cfg", File.WRITE)
	var save_data = save()
	save_game.store_line(to_json(save_data))
	save_game.close()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://config.cfg"):
		save_game()
		return
		
	save_game.open("user://config.cfg", File.READ)
	var node_data = parse_json(save_game.get_line())
	current_level = node_data["level"]
	mouse_inverted = node_data["mouse_inverted"]
	fullscreen = node_data["fullscreen"]
	TutDone = node_data["tutDone"]
	
	level_time = node_data["Tlvl"]
	
	level_score = node_data["Slvl"]
	
	save_game.close()
