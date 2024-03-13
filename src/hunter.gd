extends CharacterBody2D

# hunter implementation defining the behavoir of a hunter

var avoid_dist = 50.0
var boids_around = []
var hunters_around = []

func _physics_process(_delta):
	# vector pointing away from close hunters
	var avoid = Vector2()
	# the direction to the average center of the sorounding boids
	var group = Vector2()
	# the direction to the closest boid
	var target = Vector2()
	
	var minDist = 4096
	var averagePos = Vector2()
	var closest = Vector2()
	for boid in boids_around:
		if boid == self: continue
		
		# accumulate for average center
		averagePos += boid.position
		
		# calculate if the current boid is closer to the current closest
		var dist = position.distance_to(boid.position)
		if dist < minDist:
			closest = boid.position
			minDist = dist
		
	for hunter in hunters_around:
		var dist = position.distance_to(hunter.position)
		if dist > 0 and dist < avoid_dist:
			# if this hunter is too close then point away and make it stronger the closer it is
			avoid -= (hunter.position - position).normalized() * (avoid_dist/dist)
	
	if len(boids_around) != 0:
		# find the average position
		averagePos = averagePos/(len(boids_around))
		# point to the center of the group
		group = position.direction_to(averagePos)
		# point to the closest boid
		target = position.direction_to(closest)
	
	# starting with an acceleration of (0,0) sum the forces with their respective weights
	var accel = Vector2()
	accel += group * Globals.HunterCoherence
	accel += target * Globals.HunterAlignment
	accel += avoid * Globals.Seperation
	
	if not Globals.Looped:
		var distEdge = DistFromEdge()
		if distEdge > 0 and distEdge < 50:
			# if the boid is too close to the edge of the screen 
			# add a force pointing into the center of the screen
			accel += ((get_viewport().get_visible_rect().size/2) - position).normalized() * (50/distEdge)
	
	# add the acceleration to the vecocity, but dont allow the hunter to move faster then the speed
	velocity = (velocity + accel).normalized() * Globals.HunterSpeed
	rotation = velocity.angle() # rotate the hunter so that the sprite matches the direction of motion
	position += velocity # update the position (dont care about sliding or colliding)
	
func start(pos):
	# start a hunter with a given position and random direction to move
	position = pos
	rotation = randf_range(-PI, PI)
	velocity = Vector2(Globals.HunterSpeed, 0).rotated(rotation)

func DistFromEdge():
	var width = get_viewport().get_visible_rect().size.x
	var height = get_viewport().get_visible_rect().size.y
	# calculate how close the hunter is to an edge of the screen
	return min(min(position.x, width - position.x),min(position.y, height - position.y))

func _process(_delta):	
	if Globals.Looped:
		var width = get_viewport().get_visible_rect().size.x
		var height = get_viewport().get_visible_rect().size.y
		
		# loop the walls so the boid enter from the opposite edge
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
	# collect bodies entering the area of a group to its respective array
	if body.is_in_group("Boid"):
		boids_around.append(body)
	if body.is_in_group("Hunter"):
		hunters_around.append(body)

func _on_area_2d_body_exited(body):
	if body == self: 
		return
	# collect bodies exiting the area of a group to its respective array
	if body.is_in_group("Boid"):
		boids_around.erase(body)
	if body.is_in_group("Hunter"):
		hunters_around.erase(body)
			
