extends CharacterBody2D

# boid implementation defining the behavoid of a boid

var avoid_dist = 50.0
var hunterAvoid_dist = 300.0
var boids_around = []
var hunters_around = []

func _physics_process(_delta):
	# the direction to the average center of the sorounding boids
	var center = Vector2() 
	# the average direction of the sorounding boids
	var align = Vector2() 
	# vector pointing away from close boids
	var avoid = Vector2()
	# vector pointing away from close hunters
	var avoidHunter = Vector2()
		
	var averagePos = Vector2(0,0)
	for boid in boids_around:
		if boid == self: continue
		
		# accumulate for average center and direction
		align += boid.velocity
		averagePos += boid.position
		
		var dist = position.distance_to(boid.position)
		if dist > 0 and dist < avoid_dist:
			# if this boid is too close then point away and make it stronger the closer it is
			avoid -= (boid.position - position).normalized() * (avoid_dist/dist)
			
	for hunter in hunters_around:
		var dist = position.distance_to(hunter.position)
		if dist > 0 and dist < hunterAvoid_dist:
			# if this boid is too close then point away and make it stronger the closer it is
			avoidHunter -= (hunter.position - position).normalized() * (hunterAvoid_dist/dist)
	
	var mouse_dist = position.distance_to(get_global_mouse_position())
	
	if len(boids_around) != 0:
		# if there are boids around then calulate the averages for alignment and center
		align = align/(len(boids_around))
		averagePos = averagePos/(len(boids_around))
		
		# point to the center of the group
		center = position.direction_to(averagePos)
	
	# starting with an acceleration of (0,0) sum the forces with their respective weights
	var accel = Vector2()
	accel += center * Globals.Coherence
	accel += align * Globals.Alignment
	accel += avoid * Globals.Seperation
	accel += avoidHunter * Globals.HunterSeperation
	
	if not Globals.Looped:
		var distEdge = DistFromEdge()
		if distEdge > 0 and distEdge < 20:
			# if the boid is too close to the edge of the screen 
			# add a force pointing into the center of the screen
			accel += ((get_viewport().get_visible_rect().size/2) - position) 
	
	if Globals.MouseAvoid:
		if mouse_dist > 0 and mouse_dist < Globals.MouseRadius:
			# if the boid is too close to the mouse include a force to avoid it
			accel -= (get_global_mouse_position() - position).normalized() * (Globals.MouseRadius/mouse_dist)
			
	if Globals.MouseAttracts:
		if mouse_dist > 0 and mouse_dist > Globals.MouseRadius:
			# if the boid is too far away from the mouse include a force to get closer to it
			accel += position.direction_to(get_global_mouse_position())
	
	# add the acceleration to the vecocity, but dont allow the boid to move faster then the speed
	velocity = (velocity + accel).normalized() * Globals.BoidSpeed
	rotation = velocity.angle() # rotate the boid so that the sprite matches the direction of motion
	position += velocity # update the position (dont care about sliding or colliding)
	
func start(pos):
	# start a boid with a given position and random direction to move
	position = pos
	rotation = randf_range(-PI, PI)
	velocity = Vector2(Globals.BoidSpeed, 0).rotated(rotation)

func DistFromEdge():
	var width = get_viewport().get_visible_rect().size.x
	var height = get_viewport().get_visible_rect().size.y
	# calculate how close the boid is to an edge of the screen
	return min(min(position.x, width - position.x),min(position.y, height - position.y))

func _process(_delta):
	# update the vision radius with the setting
	$Area2D/CollisionShape2D.shape.radius = Globals.VisionRadius
	
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
			
