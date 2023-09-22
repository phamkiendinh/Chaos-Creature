extends Button

var node
var is_last_node:bool = false
@onready var transitioner := $Transitioner
func _on_pressed():
	MapTransition.change_scene()
	await get_tree().create_timer(1).timeout
	var map_node = get_node("/root/Manager/Map")
	var camera_node = get_node("/root/Manager/Map/Camera2D")
	var level_node = get_node("/root/Manager/LevelNodes")
	camera_node.position = self.get_viewport().position / 1.25 #Reset camera position whenever enter a node
	camera_node.limit_left = 0
	camera_node.zoom = Vector2(1,1)
	camera_node.set_process_input(false)
	map_node.visible = false
	node.visible = true
	if level_node.get_child_count() != 0:
		kill_all_children(level_node)
	level_node.add_child(node)
	node_traversal()
	
func node_traversal():
	var manager_node = get_node("/root/Manager")
	manager_node.activate_node()
	pass	
	
# Delete all children from node
func kill_all_children(node):
	for i in node.get_children():
		i.queue_free()
