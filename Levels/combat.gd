extends Node2D
# When enter this node, the user will immediately be met with combat
class_name CombatNode
@onready var battle_scene = preload("res://BattleScene/battle_scene.tscn")
@onready var drop_manager = preload("res://Levels/DropManager.tscn")
var enemy_spawn
var is_boss_fight = false
var battle_status
var node_status:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	var inst = battle_scene.instantiate()
	self.add_child(inst)
	pass 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func inst_drop_manager():
	var battle_node
	if is_boss_fight: battle_node = get_node("/root/Manager/LevelNodes/Boss/BattleScene")
	else: battle_node = get_node("/root/Manager/LevelNodes/Combat/BattleScene")
#	battle_node.queue_free()
	self.add_child(drop_manager.instantiate())
