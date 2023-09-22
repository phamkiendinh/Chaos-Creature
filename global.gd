extends Node
@onready var menu_scene = 'menu'

@onready var monster_database = preload("res://Card/Monster/newmonster_database.gd")
@onready var spell_database = preload("res://Card/Spell/spell_database.gd")
@onready var artifact_database = preload("res://Artifact/artifact_database.gd")

@onready var monster_json = monster_database.new()
@onready var spell_json = spell_database.new()
@onready var artifact_json = artifact_database.new()

#Deck data for stuff here
@onready var monster_deck = []
@onready var spell_deck = []
@onready var temp_deck = []
@onready var artifact_deck = [null,null,null,null,null]
@onready var temp_artifact_deck = []

@onready var enemy_deck = []
func _ready(): 
	print("Global Script: LP" ,hero_lp)
	monster_json = monster_json.DATA.get('Monster')
	spell_json = spell_json.DATA.get('Spell')
	artifact_json = artifact_json.DATA.get('Artifact')
	
	var start_monster_cards:int = 5
	var start_spell_cards:int = 3
	var start_artifacts = 5
	var i:int = 0
	while i < start_monster_cards:
		var new_card = monster_json[randi() % monster_json.size()]
		enemy_deck.append(new_card)
		if monster_deck.find(new_card) != -1:
			continue
		else:
			monster_deck.append(new_card)
			i += 1
	i = 0
	while i < start_spell_cards:
		var new_card = spell_json[randi() % spell_json.size()]
		if spell_deck.find(new_card) != -1:
			continue
		else:
			spell_deck.append(new_card)
			i += 1
	i = 0
	while i < start_artifacts:
		var new_artifact = artifact_json[randi() % artifact_json.size()]
		if temp_artifact_deck.find(new_artifact) != -1:
			continue
		else:
			temp_artifact_deck.append(new_artifact)
			i += 1
	#print(artifact_deck)
	#print(temp_artifact_deck)

@export var hero_lp:int

func _physics_process(delta):
#	print("Global Script: LP After Chose Hero" ,hero_lp)
	pass

func attack_hero(damage):
	hero_lp -= damage
func hero_lp_check():
	if hero_lp <= 0:
		print("You are dead")

var log_text:String = ""
