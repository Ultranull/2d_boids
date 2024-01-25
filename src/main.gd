extends Node2D

const BOID = preload("res://tscn/boid.tscn")
const HUNTER = preload("res://tscn/hunter.tscn")

var dragging = false
var all_boids = []
var all_hunters = []

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.Coherence = %CoherenceSlide.value
	Globals.Seperation = %SeperationSlide.value
	Globals.Alignment = %AlignSlide.value
	Globals.VisionRadius = %VisionSlide.value
	Globals.MouseRadius = %MouseRadius.value
	Globals.MouseAttracts = false
	Globals.MouseAvoid = false
	Globals.HunterCoherence = %HunterCoherenceSlide.value
	Globals.HunterSeperation = %HunterSeperationSlide.value
	Globals.HunterAlignment = %HunterAlignSlide.value
	Globals.BoidSpeed = %BoidSpeedSlide.value
	Globals.HunterSpeed = %HunterSpeedSlide.value
	%BoidSpin.value = 30
	for i in range(30):
		spawn_boid()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()

func _draw():
	if dragging and len(all_boids):
		var color = Color(1.0, 0.0, 0.0)
		draw_circle(all_boids[0].position, Globals.VisionRadius, color)

func spawn_hunter():
	var hunter = HUNTER.instantiate()
	var width = get_viewport().get_visible_rect().size.x
	var height = get_viewport().get_visible_rect().size.y
	var start_pos = Vector2(
		randi_range(0, width),
		randi_range(0, height))
	hunter.start(start_pos)
	all_hunters += [hunter]
	%AllHunters.add_child(hunter)
	
func spawn_boid():
	var boid = BOID.instantiate()
	var width = get_viewport().get_visible_rect().size.x
	var height = get_viewport().get_visible_rect().size.y
	var start_pos = Vector2(
		randi_range(0, width),
		randi_range(0, height))
	boid.start(start_pos)
	all_boids += [boid]
	%AllBoids.add_child(boid)
	
func _on_coherence_slide_drag_ended(value_changed):
	Globals.Coherence = %CoherenceSlide.value
	
func _on_seperation_slide_drag_ended(value_changed):
	Globals.Seperation = %SeperationSlide.value

func _on_align_slide_drag_ended(value_changed):
	Globals.Alignment = %AlignSlide.value

func _on_mouse_align_check_toggled(toggled_on):
	Globals.MouseAttracts = toggled_on

func _on_mouse_avoid_check_toggled(toggled_on):
	Globals.MouseAvoid = toggled_on

func _on_vision_slide_drag_ended(value_changed: bool) -> void:
	Globals.VisionRadius = %VisionSlide.value
	dragging = false
	
func _on_vision_slide_drag_started() -> void:
	dragging = true

func _on_vision_slide_value_changed(value: float) -> void:
	Globals.VisionRadius = %VisionSlide.value

func _on_mouse_radius_drag_ended(value_changed: bool) -> void:
	Globals.MouseRadius = %MouseRadius.value

func _on_check_box_toggled(toggled_on: bool) -> void:
	Globals.Looped = toggled_on

func _on_hunter_coherence_slide_drag_ended(value_changed: bool) -> void:
	Globals.HunterCoherence = %HunterCoherenceSlide.value

func _on_hunter_seperation_slide_drag_ended(value_changed: bool) -> void:
	Globals.HunterSeperation = %HunterSeperationSlide.value

func _on_hunter_align_slide_drag_ended(value_changed: bool) -> void:
	Globals.HunterAlignment = %HunterAlignSlide.value

func _on_hunter_spin_value_changed(value: float) -> void:
	var delta = len(all_hunters) - value
	if delta > 0:
		for i in range(delta):
			var boid = all_hunters.pop_front()
			if boid:
				boid.queue_free()
	elif delta < 0:
		for i in range(abs(delta)):
			spawn_hunter()
		
func _on_boid_spin_value_changed(value: float) -> void:
	var delta = len(all_boids) - value
	if delta > 0:
		for i in range(delta):
			var boid = all_boids.pop_front()
			if boid:
				boid.queue_free()
	elif delta < 0:
		for i in range(abs(delta)):
			spawn_boid()

func _on_hunter_speed_slide_drag_ended(value_changed: bool) -> void:
	Globals.HunterSpeed = %HunterSpeedSlide.value

func _on_boid_speed_slide_drag_ended(value_changed: bool) -> void:
	Globals.BoidSpeed = %BoidSpeedSlide.value
