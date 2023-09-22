extends Node
class_name CombatEffect

@onready var db = preload("res://BattleScene/Effect/effect_database.gd")
@onready var json = db.new()

@export var effect_name:String
@export var duration:int
@export var end_cycle:int
@export var is_benificial:bool
@export var can_stack:bool
@export var priority:int
@export var is_removable:bool
@export var entry_effect:String
@export var per_cycle_effect:String #tick, dot
@export var persistent_effect:String
@export var on_leave_effect:String
@export var mod_attribute:String
@export var mod_value:int
@export var i:int

func _ready():
	json = json.DATA.get('Effect')
	json = json[i]
	var a = json.get(json.keys()[0])
	
	effect_name = a.get("name")
	duration = a.get('duration')
	is_benificial = a.get('is_beneficial')
	is_removable = a.get('is_removable')
	can_stack = a.get('can_stack')
	entry_effect = a.get('entry_effect')
	per_cycle_effect = a.get('per_cycle_effect')
	persistent_effect = a.get('persistent_effect')
	on_leave_effect = a.get('on_leave_effect')
