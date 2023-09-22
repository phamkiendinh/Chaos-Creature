extends Node2D

@export var node_list:Array
@onready var container = 0
@onready var button = preload("res://Levels/Map/MapNode.tscn")
var map_list = []
var count = 0

func inst_node(node, pos):
	var b = button.instantiate()
	self.add_child(b)
	b.modulate = Color(1,1,1,0)
	b.name = node.name
	b.position = pos
	b.size = Vector2(200,100)
	if count > 0:
		b.disabled = true
	
	var tween = create_tween()
	tween.tween_property(b, "modulate", Color(1,1,1,1), 0.2).set_trans(Tween.TRANS_LINEAR)
	
	b.node = node
	b.text = node.name
	
	map_list.append(b)
	count += 1	

func draw_lines(start_node, destination_node):
	var line = Line2D.new()
	pass

func map_gen(list):
	count = 0
	var viewport_center:Vector2 = get_viewport_rect().size / 2
	var pos:Vector2 = Vector2(0,0)
	var node_pair_increment = 2
	var current_pos:Vector2 = Vector2(0,0)
	for i in range(list.size()):
		if count == 0: 
			pos.y = viewport_center.y
			inst_node(list[i], pos)
			await self.get_tree().create_timer(0.2).timeout
			count += 1
		elif i % 2 == 0 && (i + 1) % 2 != 0 && count != 0:
			var dist = randi_range(60, 200)
			# Spawn the remaining nodes in pairs of odd:even, starting from the second spawned node (index = 1)
			if i < list.size() - 1:
				pos.y = viewport_center.y - dist 
				await self.get_tree().create_timer(0.2).timeout
				inst_node(list[i], pos)
				pos.y = viewport_center.y + dist 
				inst_node(list[i + 1], pos)
			elif i == list.size() - 1:
				pos.y = viewport_center.y
				inst_node(list[i], pos)
		else: pos.x += 400

func draw_line_between_nodes(map):
	var child_count = 0
	for i in map.get_children():
		child_count += 1
		if child_count > 1:
			var recieve_point = i.get_child(1)
			var line = Line2D.new()
			var start_point = i.get_child(0)
			line.add_point(start_point.position)
			line.add_point(recieve_point.position)
			map.get_parent().add_child(line)
