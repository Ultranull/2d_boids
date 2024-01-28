extends Node2D

# main scene used for spawning boids and collecting settings from GUI.

const BOID = preload("res://tscn/boid.tscn")
const HUNTER = preload("res://tscn/hunter.tscn")

var dragging = false
var all_boids = []
var all_hunters = []
		
func _ready():
	$Settings/VBoxContainer/SettingsBox/TabContainer.get_tab_bar().grab_focus()
	
	# grab initial values from GUI
	# boid settings
	Globals.Coherence = %CoherenceSlide.value
	Globals.Seperation = %SeperationSlide.value
	Globals.Alignment = %AlignSlide.value
	Globals.BoidSpeed = %BoidSpeedSlide.value
	Globals.VisionRadius = %VisionSlide.value
	%BoidSpin.value = 30
	
	# hunter settings
	Globals.HunterCoherence = %HunterCoherenceSlide.value
	Globals.HunterSeperation = %HunterSeperationSlide.value
	Globals.HunterAlignment = %HunterAlignSlide.value
	Globals.HunterSpeed = %HunterSpeedSlide.value
	
	# other settings
	Globals.MouseRadius = %MouseRadius.value
	Globals.MouseAttracts = false
	Globals.MouseAvoid = false
	
	# initially spawn 30 boids
	for i in range(30):
		spawn_boid()

func _process(_delta):
	queue_redraw() # this is used to render the vision radius circle
	
	# update settings to match GUI
	# boid settings
	Globals.Coherence = %CoherenceSlide.value
	Globals.Seperation = %SeperationSlide.value
	Globals.Alignment = %AlignSlide.value
	Globals.BoidSpeed = %BoidSpeedSlide.value
	Globals.VisionRadius = %VisionSlide.value
	
	# hunter settings
	Globals.HunterCoherence = %HunterCoherenceSlide.value
	Globals.HunterSeperation = %HunterSeperationSlide.value
	Globals.HunterAlignment = %HunterAlignSlide.value
	Globals.HunterSpeed = %HunterSpeedSlide.value
	
	# other settings
	Globals.MouseRadius = %MouseRadius.value

func _draw():
	# if the vision slider is being dragged and there is at least one boid
	if dragging and len(all_boids):
		var color = Color(1.0, 0.0, 0.0)
		# draw a circle representing the how far a boid can see
		draw_circle(all_boids[0].position, Globals.VisionRadius, color)

func spawn_hunter():
	# create an instance of a hunter
	var hunter = HUNTER.instantiate()
	
	# get a random starting point on the screen
	var width = get_viewport().get_visible_rect().size.x
	var height = get_viewport().get_visible_rect().size.y
	var start_pos = Vector2(
		randi_range(0, width),
		randi_range(0, height))
		
	# give the hunter the starting point and add it to the scene
	hunter.start(start_pos)
	all_hunters += [hunter]
	%AllHunters.add_child(hunter)
	
func spawn_boid():
	# create an instance of a boid
	var boid = BOID.instantiate()
	
	# get a random starting point on the screen
	var width = get_viewport().get_visible_rect().size.x
	var height = get_viewport().get_visible_rect().size.y
	var start_pos = Vector2(
		randi_range(0, width),
		randi_range(0, height))
		
	# give the boid the starting point and add it to the scene
	boid.start(start_pos)
	all_boids += [boid]
	%AllBoids.add_child(boid)
	
func _on_mouse_align_check_toggled(toggled_on):
	Globals.MouseAttracts = toggled_on

func _on_mouse_avoid_check_toggled(toggled_on):
	Globals.MouseAvoid = toggled_on

func _on_check_box_toggled(toggled_on: bool) -> void:
	Globals.Looped = toggled_on
	
func _on_vision_slide_drag_ended(_value_changed: bool) -> void:
	Globals.VisionRadius = %VisionSlide.value
	dragging = false # disable rendering of vision circle 
	
func _on_vision_slide_drag_started() -> void:
	dragging = true # enable rendering of vision circle 

func _on_hunter_spin_value_changed(value: float) -> void:
	# calculate the change in the amount of hunters to match GUI value
	var delta = len(all_hunters) - value
	if delta > 0:
		# if the value is positive, then hunters are being removed
		for i in range(delta):
			var hunter = all_hunters.pop_front()
			# destroy the hunter only if there is one to destroy
			if hunter:
				hunter.queue_free()
	elif delta < 0:
		# if the value is negative, then hunters are being added
		for i in range(abs(delta)):
			spawn_hunter()
		
func _on_boid_spin_value_changed(value: float) -> void:
	# calculate the change in the amount of boids to match GUI value
	var delta = len(all_boids) - value
	if delta > 0:
		# if the value is positive, then boids are being removed
		for i in range(delta):
			var boid = all_boids.pop_front()
			# destroy the boid only if there is one to destroy
			if boid:
				boid.queue_free()
	elif delta < 0:
		# if the value is negative, then boids are being added
		for i in range(abs(delta)):
			spawn_boid()

func _on_hide_switch_toggled(toggled_on: bool) -> void:
	# allow for hiding the settings box, because it can be in the way
	if toggled_on:
		%SettingsBox.hide()
	else:
		%SettingsBox.show()
		

