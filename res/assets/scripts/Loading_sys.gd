extends Control

#warning-ignore:unused_class_variable
var current_scene = null

var thread = null

onready var progress = $progress

func _thread_load(path):
	var ril = ResourceLoader.load_interactive(path)
	assert( ril )
	var total = ril.get_stage_count()
	# Call deferred to configure max load steps
	progress.call_deferred("set_max",total)

	var res = null

	while (true): #iterate until we have a resource
		# Update progress bar, use call deferred, which routes to main thread
		progress.call_deferred("set_value",ril.get_stage())
		# Poll (does a load step)
		OS.delay_msec(2)
		var err = ril.poll()
		# if OK, then load another one. If EOF, it' s done. Otherwise there was an error.
		if ( err == ERR_FILE_EOF):
			#loading done, fetch resource
			res = ril.get_resource()
			break
		elif (err != OK):
			#Not OK, there was an error
			#LoggingSystem._log("There was an error loading", 2)
			break

	# Send whathever we did (or not) get
	call_deferred("_thread_done",res)

func _thread_done(resource):
	assert( resource )

	# Always wait for threads to finish, this is required on Windows
	thread.wait_to_finish()

	#Hide the progress bar
	progress.hide()

	# Instantiate new scene
	if(is_inside_tree()):
		var new_scene = resource.instance()
		# Free current scene
		get_tree().current_scene.free()
		get_tree().current_scene = null
		# Add new one to root
		get_tree().root.add_child(new_scene)
		# Set as current scene
		get_tree().current_scene = new_scene
	
	get_tree().paused = false
	progress.visible = false
	
func load_scene(path):
	thread = Thread.new()
	thread.start( self, "_thread_load", path)
	get_tree().paused = true
	raise() #show on top
	progress.visible = true
