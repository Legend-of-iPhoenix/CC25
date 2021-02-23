extends KinematicBody

const MOVEMENT_SPEED : float = 7.0
const JUMP_SPEED : float = 1.25 * MOVEMENT_SPEED
const GRAVITY : float = 20.0

const MOUSE_SENSITIVITY : float = 0.2

var velocity : Vector3 = Vector3()

func handle_movement():
	# the velocity the user wishes to go
	var desired_velocity : Vector3 = Vector3()
	
	if Input.is_action_pressed("move_forwards"):
		desired_velocity.z -= 1
	if Input.is_action_pressed("move_backwards"):
		desired_velocity.z += 1
	
	if Input.is_action_pressed("move_left"):
		desired_velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		desired_velocity.x += 1
	
	# enforce maximum speed so that moving diagonally is not faster
	desired_velocity = desired_velocity.normalized()
	
	# a point rotation- moving forwards means move in the direction the player is looking, not just +z
	return transform.basis.z * desired_velocity.z + transform.basis.x * desired_velocity.x

func _physics_process(delta):
	# stop side-to-side movement when button is pressed
	velocity.x = 0
	velocity.z = 0
	
	var desired_velocity : Vector3 = handle_movement()
	
	velocity.x = velocity.x + MOVEMENT_SPEED * desired_velocity.x
	velocity.z = MOVEMENT_SPEED * desired_velocity.z
	
	velocity.y -= delta * GRAVITY;
	
	if Input.is_action_pressed("jump") && is_on_floor():
		velocity.y = JUMP_SPEED
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * MOUSE_SENSITIVITY))
