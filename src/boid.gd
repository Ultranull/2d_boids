extends CharacterBody2D

var avoid_dist = 50.0
var hunterAvoid_dist = 300.0
var boids_around = []
var hunters_around = []

func _physics_process(delta):
	var center = Vector2()
	var align = Vector2()
	var avoid = Vector2()
	var avoidHunter = Vector2()
		
	var averagePos = Vector2(0,0)
	for boid in boids_around:
		if boid == self: continue
		align += boid.velocity
		averagePos += boid.position
		
		var dist = position.distance_to(boid.position)
		if dist > 0 and dist < avoid_dist:
			avoid -= (boid.position - position).normalized() * (avoid_dist/dist)
			
	for hunter in hunters_around:
		var dist = position.distance_to(hunter.position)
		if dist > 0 and dist < hunterAvoid_dist:
			avoidHunter -= (hunter.position - position).normalized() * (hunterAvoid_dist/dist)
	
	var mouse_dist = position.distance_to(get_global_mouse_position())
	
	if len(boids_around) != 0:
		align = align/(len(boids_around))
		averagePos = averagePos/(len(boids_around))
		center = position.direction_to(averagePos)
	
	var accel = Vector2()
	accel += center * Globals.Coherence
	accel += align * Globals.Alignment
	accel += avoid * Globals.Seperation
	accel += avoidHunter * Globals.HunterSeperation
	
	if not Globals.Looped:
		var distEdge = DistFromEdge()
		if distEdge > 0 and distEdge < 20:
			accel += ((get_viewport().get_visible_rect().size/2) - position) 
	
	if Globals.MouseAvoid:
		if mouse_dist > 0 and mouse_dist < Globals.MouseRadius:
			accel -= (get_global_mouse_position() - position).normalized() * (Globals.MouseRadius/mouse_dist)
			
	if Globals.MouseAttracts:
		if mouse_dist > 0 and mouse_dist > Globals.MouseRadius:
			accel += position.direction_to(get_global_mouse_position())
	
	velocity = (velocity + accel).normalized() * Globals.BoidSpeed
	rotation = velocity.angle()
	#move_and_collide(velocity)
	position += velocity
	
	
func start(pos):
	position = pos
	rotation = randf_range(-PI, PI)
	velocity = Vector2(Globals.BoidSpeed, 0).rotated(rotation)
	
func interpolate(a,b,t):
	return a*t + (1-t)*b

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func DistFromEdge():
	var width = get_viewport().get_visible_rect().size.x
	var height = get_viewport().get_visible_rect().size.y
	return min(min(position.x, width - position.x),min(position.y, height - position.y))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Area2D/CollisionShape2D.shape.radius = Globals.VisionRadius
	
	if Globals.Looped:
		var width = get_viewport().get_visible_rect().size.x
		var height = get_viewport().get_visible_rect().size.y
		if position.x > width:
			position.x = 0
		if position.x < 0:
			position.x = width
		if position.y > height:
			position.y = 0
		if position.y < 0:
			position.y = height
			

func _on_area_2d_body_entered(body):
	if body == self: 
		return
	if body.is_in_group("Boid"):
		boids_around.append(body)
	if body.is_in_group("Hunter"):
		hunters_around.append(body)

func _on_area_2d_body_exited(body):
	if body == self: 
		return
	if body.is_in_group("Boid"):
		boids_around.erase(body)
	if body.is_in_group("Hunter"):
		hunters_around.erase(body)
			
