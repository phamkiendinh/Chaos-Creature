extends Node2D
class_name GenericEventTemplate
@onready var event_database = preload("res://Levels/Events/EventsData/event_database.gd")
@onready var json = event_database.new()

#@onready var name_box = $Name
@onready var flavor_text_box = $FlavorText
@onready var button1 = $MarginContainer/GridContainer/EventButton
@onready var button2 = $MarginContainer/GridContainer/EventButton2
@onready var button_grid_container = $MarginContainer/GridContainer

var id:String
var event_name:String
var type:String
var background
var flavor_text:String
var flavor_rewards_text:String
var rewards
var flavor_exit_text:String

# Called when the node enters the scene tree for the first time.
func _ready():
	json = json.DATA.get('Event')
	button1.visible = false
	button2.visible = false
	#Insert Data to Object
	var new_event = json[randi() % json.size()] 
	id = new_event.get("id")
	event_name = new_event.get("name")
	type = new_event.get("type")
	background = new_event.get("background")
	flavor_text = new_event.get("flavor_text")
	flavor_rewards_text = new_event.get("rewards_flavor_text")
	flavor_exit_text = new_event.get("exit_flavor_text")
	rewards = new_event.get("rewards")
	
	
	#Insert Data to GUI elements
	flavor_text_box.text = flavor_text
	button1.text = flavor_rewards_text
	if flavor_exit_text != "0": button2.text = flavor_exit_text
	else: button2.text = "Move On"
	var text_type_time = flavor_text_box.calc_tween_time()
	await get_tree().create_timer(2).timeout
	#Animation
	button1.visible = true
	button2.visible = true
#	button1.modulate = Color(1,1,1,0)
#	button2.modulate = Color(1,1,1,0)
#	var tween = create_tween()
#	tween.tween_property(button1, "modulate", Color(1,1,1,1), 1).set_trans(Tween.TRANS_LINEAR)
#	tween.tween_property(button2, "modulate", Color(1,1,1,1), 1).set_trans(Tween.TRANS_LINEAR)
#	tween.set_trans(Tween.TRANS_CIRC)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			# Left mouse button to skip waiting for choice button
			if event.button_index == MOUSE_BUTTON_LEFT: 
				toggle_buttons_visibile()
				self.emit_signal("anim_completed")
				
				
func toggle_buttons_visibile():
	button1.visible = true
	button2.visible = true
	button1.modulate = Color(1,1,1,1)
	button2.modulate = Color(1,1,1,1)
	
func _on_event_button_pressed():
#	var stat_name = rewards.keys()[0]
	# Apply event's behaviour
	for i in rewards.keys():
		var value = rewards[i]
		EventsFunc.apply_stat_mod(i, value)
	var parent = self.get_parent() #parent is the main Event scene
	parent.to_transitional_screen()

func _on_event_button_2_pressed():
	var parent = self.get_parent()
	parent.to_transitional_screen()

func _on_flavor_text_finished():
	pass # Replace with function body.
