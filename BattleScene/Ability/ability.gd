extends Node
class_name Ability

@onready var ability_database = preload("res://BattleScene/Ability/ability_database.gd")
@onready var json = ability_database.new()

"""Variables"""
var ability_name:String
var type:String
var modified_stat:String
var modified_amount:int
var attack_power:int
var duration:int
var affinity
var targeting:String
var cost:int
var ability_owner
var is_active:bool
var effect:String
var cycle_end:int
@export var i:int

func _ready():
	json = json.DATA.get('Ability')
	json = json[i]
	var a = json.get(json.keys()[0])

	ability_name = a.get("name")
	type = a.get("type")
	modified_stat = a.get("modified_stat")
	modified_amount = a.get("modified_amount")
	attack_power = a.get("attack_power")
	duration = a.get("duration")
	affinity = a.get("affinity")
	targeting = a.get("targeting")
	cost = a.get("cost")
	ability_owner = a.get("ability_owner")
	is_active = a.get("is_active")
	effect = a.get("effect")
	#	json = json[0]
	
