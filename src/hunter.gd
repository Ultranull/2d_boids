extends CharacterBody2D

var avoid_dist = 50.0
var boids_around = []

func _physics_process(delta):
	var center = Vector2()
	var target = Vector2()
	
	var minDist = 4096
	var averagePos = Vector2()
	var closest = Vector2()
	for boid in boids_around:
		if boid == self: continue
		averagePos += boid.position
		
		var dist = position.distance_to(boid.position)
		if dist < minDist:
			closest = boid.position
			minDist = dist
		
	
	if len(boids_around) != 0:
		averagePos = averagePos/(len(boids_around))
		center = position.direction_to(averagePos)
		target = position.direction_to(closest)
	
	var accel = Vector2()
	accel += center * Globals.HunterCoherence
	accel += target * Globals.HunterAlignment
	
	if not Globals.Looped:
		var distEdge = DistFromEdge()
		if distEdge > 0 and distEdge < 20:
			accel += ((get_viewport().get_visible_rect().size/2) - position) 
	
	velocity = (velocity + accel).normalized() * Globals.HunterSpeed
	rotation = velocity.angle()
	position += velocity
	
	
func start(pos):
	position = pos
	rotation = randf_range(-PI, PI)
	velocity = Vector2(Globals.HunterSpeed, 0).rotated(rotation)
	
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

func _on_area_2d_body_exited(body):
	if body == self: 
		return
	if body.is_in_group("Boid"):
		boids_around.erase(body)
			
