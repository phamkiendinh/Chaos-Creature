extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var test_variable = 200

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
#	get_node()
	pass

func _physics_process(delta):
	pass
#	# Add the gravity.
#	if not is_on_floor():
#		velocity.y += gravity * delta
#
#	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY
#
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("ui_left", "ui_right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#
#	move_and_slide()


#func _on_button_pressed():
#	$CharacterBody2D.animation = "Attack"
#	await get_tree().create_timer(1).timeout
#	$CharacterBody2D.animation = "Idle"
#	pass # Replace with function body.
