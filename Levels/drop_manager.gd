extends Node2D
const _SPELL_BASE = preload("res://Card/Spell/spell_base.tscn")
const _MONSTER_BASE = preload("res://Card/Monster/monster_base.tscn")
const _ARTIFACT_DATA = preload("res://Artifact/artifact_database.gd")
const _CARD_DATA = preload("res://Card/Monster/newmonster_database.gd")


var artifact = preload("res://Artifact/artifact.tscn")
var arti_json = _ARTIFACT_DATA.new()

var monster = preload("res://Card/Monster/monster_base.tscn")
#var card = monster.new()

var drop_pool = ["Card", "50% Attack Up", "+1 Rune Limit", "Artifact"]
var card_drop_count = 0
var artifact_drop_count = 0
var artifact_pool = []
var card_pool = []
@onready var button1 = $DropOptionMarginContainer/DropOptionContainers/ItemDropsButton
@onready var button2 = $DropOptionMarginContainer/DropOptionContainers/ItemDropsButton2
@onready var button3 = $DropOptionMarginContainer/DropOptionContainers/ItemDropsButton3

var target_pos_for_chosen_button = Vector2(320,0)
var margin_container_script = load("res://Levels/Buttons/margin_container_script.gd")

#var path_to_asset = "res://Assets/Buttons/margin_container_script.gd"

# The drop button behaviours
func roll_drop(drop_button:Button):
	#Card 
	if randi() % 2 == 1 && card_drop_count == 0: #50% chance 
#		var card = card_pool[randi() % card_pool.size()]
		drop_button.text = drop_pool[0]
#		add_img_to_button(drop_button, card.image)
		card_drop_count += 1
	#Artifact
	elif randi() % 2 == 1 && artifact_drop_count == 0: #10% chance
		var a = artifact_pool[randi() % artifact_pool.size()]
		drop_button.text = a.artifact_name
		print(a.artifact_name)
		add_img_to_button(drop_button, a.image_path)
		artifact_drop_count += 1
	#Buff
	elif randi() % 5 == 1: drop_button.text = drop_pool[1] #20% chance
	else: drop_button.text = drop_pool[2] # the rest

#Mostly For Artifact for now
func add_img_to_button(button, img_path, is_card = false):
	var img_rect = TextureRect.new()
	var label = Label.new()
	#Format Label
	label.text = button.text
	label.size.x = button.size.x / 1.25
	label.size.y = button.size.y / 1.8
	label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var margin_container = MarginContainer.new()
	margin_container.set_script(margin_container_script)
	#Add Image
	if !is_card: img_rect.texture = load(str('res://Assets/Artifacts/', img_path))
	else: img_rect.texture = load(str('res://Assets/Units/', img_path, "/", img_path))
	#Put everything together
	button.add_child(margin_container)
	margin_container.add_child(img_rect)
	button.add_child(label)

# Add artifact objects to a Pool to be used later
func create_artifact_pool():
	for i in arti_json.DATA.get('Artifact'):
		var a = artifact.instantiate()
		$ArtifactPool.add_child(a)
		a.visible = false
		artifact_pool.append(a) 

func create_card_pool():
#	for i in card.DATA.get('Monster'):
#		var c = monster.instantiate()
#		card_pool.append(c)
	pass
		
func _ready():
	create_artifact_pool()
	create_card_pool()
	roll_drop(button1)
	roll_drop(button2)
	roll_drop(button3)
	intro_anim()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func button1_picked_anim():
	var tween = get_tree().create_tween()
	tween.tween_property(button2, "modulate", Color(1,1,1,0), 0.6).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(button3, "modulate", Color(1,1,1,0), 0.6).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(button1, "position", button2.position, 0.4).set_trans(Tween.TRANS_QUART)
	
func button2_picked_anim():
	var tween = get_tree().create_tween()
	tween.tween_property(button1, "modulate", Color(1,1,1,0), 0.6).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(button3, "modulate", Color(1,1,1,0), 0.6).set_trans(Tween.TRANS_LINEAR)
	
func button3_picked_anim():
	var tween = get_tree().create_tween()
	tween.tween_property(button1, "modulate", Color(1,1,1,0), 0.6).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(button2, "modulate", Color(1,1,1,0), 0.6).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(button3, "position", button2.position, 0.4).set_trans(Tween.TRANS_QUART)
	
func _on_level_chooser_pressed():
	var manager_node = get_node("/root/Manager")
	var map_screen = get_node("/root/Manager/Map")
	var parent = self.get_parent()
	var battle_node = parent.get_child(3)
	battle_node.queue_free()
	manager_node.to_map_screen()
	map_screen.visible = true
	self.visible = false
	pass # Replace with function body.

"""TODO: Conect function to signal"""
func _on_item_drops_button_pressed():
	button1_picked_anim()
func _on_item_drops_button_2_pressed():
	button2_picked_anim()
func _on_item_drops_button_3_pressed():
	button3_picked_anim()

func intro_anim() -> void:
	$AnimationPlayer.play('drop_intro')
	await get_node("AnimationPlayer").animation_finished
