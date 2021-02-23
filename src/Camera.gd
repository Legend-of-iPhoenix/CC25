extends Camera

onready var Player = get_parent()

func _ready():
	translation = Player.get_node("CharacterMesh").translation - Vector3.UP;

func _input(event):
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event is InputEventMouseMotion:
		var rotation_speed = deg2rad(-event.relative.y * Player.MOUSE_SENSITIVITY);
		
		var rotation = get_rotation()
		rotation.x = clamp(rotation.x + rotation_speed, -PI/2, PI/2)
		set_rotation(rotation)
