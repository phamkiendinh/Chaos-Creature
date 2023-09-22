extends Node2D
#This Scene Manages Node Generation and Navigation

var map_size = 6
var prev_node = 0
var prev_node_2 = 0
var current_node = 0
var next_node = 0
var next_node_2 = 0
var increment = 2
var checkpoint_node
var chosen_path = []

@onready var combat_node = preload("res://Levels/Combat.tscn") 
@onready var event_node = preload("res://Levels/Event.tscn")
@onready var save_node = preload("res://Levels/Save.tscn")
@onready var map_script = load("res://Levels/Map/map.gd")

@onready var camera_node = get_node("/root/Manager/Map/Camera2D")
var combat_node_counter = 0
var event_node_counter = 0
var save_node_counter = 0

var level_list = []
var level_dict = {}

var based_path_to_map_nodes = "/root/Manager/Map/"
func _ready():
	MapTransition.change_scene()
	await get_tree().create_timer(0.5).timeout
	camera_node.disable_zoom = true
#	camera_node.set_process_input(false)
	camera_node.position = Vector2(-63, 319)
	camera_node.is_tutorial_cam = true
	next_node = 1
	next_node_2 = 2
	prev_node = 0
	prev_node_2 = 0
	generate_nodes()
	$Map.map_gen(level_list)
#	$Map.draw_line_between_nodes($Map)
	level_list[0].visible = false
	chosen_path.append(0)
	
func spawn_node(node):
	return node.instantiate()	
	
func get_required_map_nodes():
	var map_info = {}
	prev_node = current_node - 1
	prev_node_2 = current_node - 2
	
	var current_map_node_path = based_path_to_map_nodes + $Map.map_list[current_node].name
	var current_map_node = get_node(current_map_node_path)
	map_info["current_map_node"] = current_map_node
	
	var spawned_map_node_1_path = based_path_to_map_nodes + $Map.map_list[next_node].name
	var spawned_map_node_1 = get_node(spawned_map_node_1_path)
	map_info["spawned_map_node_1"] = spawned_map_node_1
	
	if next_node_2 < 4:
		var spawned_map_node_2_path = based_path_to_map_nodes + $Map.map_list[next_node_2].name
		var spawned_map_node_2 = get_node(spawned_map_node_2_path)
		map_info["spawned_map_node_2"] = spawned_map_node_2
	
	var spawned_prev_map_node_path = based_path_to_map_nodes + $Map.map_list[prev_node].name
	var spawned_prev_map_node = get_node(spawned_prev_map_node_path)
	map_info["spawned_prev_map_node"] = spawned_prev_map_node
	
	var spawned_prev_map_node_path_2 = based_path_to_map_nodes + $Map.map_list[prev_node_2].name
	var spawned_prev_map_node_2 = get_node(spawned_prev_map_node_path_2)
	map_info["spawned_prev_map_node_2"] = spawned_prev_map_node_2
	
	next_node += increment
	next_node_2 += increment
	return map_info
	
#Probability and node spawn rules	
func roll_node(i:int):
	var type
	var save_node_spawn = [5, 10, 19]
	#If next node is at index 10, 20 or 50; 50% chance of spawning a save node
	if save_node_spawn.has(i) && save_node_counter <= 3: 
		type = 3 
	elif randi() % 3 == 1: type = 1 
	elif randi() % 4 == 1: type = 2
	else: type = 2
	
	return type

func generate_nodes():	
	var node_1 = spawn_node(combat_node)
	node_1.name = "Combat"
	level_list.append(node_1)
	level_dict[node_1.name] = node_1
	combat_node_counter += 1
	
	#If it is done manually, something funky happens so here's a pseudo generate-ish thing instead
	for i in range(0, 3):
		var r:int = roll_node(i) 
		match r:
			1: 
				var n = spawn_node(combat_node)
				n.name = "Combat" 
#				n.node_status = false
				level_list.append(n) 
				level_dict[n.name] = n 
				combat_node_counter += 1
			2:
				var n = spawn_node(event_node)
				n.name = "Encounter"
#				n.node_status = false
				level_list.append(n) 
				level_dict[n.name] = n 
				event_node_counter += 1		
	#Boss Node
	var f = spawn_node(combat_node)
	f.name = "Boss"
	f.is_boss_fight = true
	level_list.append(f)
	level_dict[f.name] = f
	
	print(level_list)
	
func activate_node():
	if current_node + 2 < map_size:
		var map_info = get_required_map_nodes()
	# Lumbago
		if map_info["current_map_node"].name != "Boss":
			if current_node + 2 < map_size + 2:
				map_info["current_map_node"].disabled = true
				if current_node > 2:
					map_info["spawned_prev_map_node"].disabled = true
					map_info["spawned_prev_map_node_2"].disabled = true
				map_info["spawned_map_node_1"].disabled = false
				if current_node + 2 < 4:
					map_info["spawned_map_node_2"].disabled = false
				if current_node < 2:
					current_node += 2
				else: current_node += increment
		else: print("End")
	
#Called by battle scene, event scenes, etc.
@onready var transitioner := $Transitioner
func to_map_screen():
	transitioner.transition_scene(self, "res://Levels/Manager.tscn", 2.5, Tween.TRANS_SINE, Tween.EASE_OUT, BTrans.DIRECTION.DOWN)
	MapTransition.change_scene()
	await get_tree().create_timer(0.5).timeout
	$Map.visible = true

func check_combat_condition():
	if level_list[current_node].status == 1:
		return true
	else: 
		return false

#Spawn the first combat node
func _on_start_pressed():
	var f = spawn_node(combat_node) #First node will always be combat_node
	f.name = "FirstCombatNode"
	$LevelNodes.add_child(f)
	$Start.visible = false
	f.visible = true
	pass # Replace with function body.

func create_map():
	pass
