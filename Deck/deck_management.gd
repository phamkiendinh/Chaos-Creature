extends Node2D

@onready var view_port_size: Vector2 = self.get_viewport_rect().size
@onready var shader: Object = preload("res://Deck/deck_management.gdshader")
@onready var select_shader: Object = preload("res://Deck/select_shader.gdshader")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Light.enabled = false
	$HUD.size = get_viewport_rect().size
	$HUD/Text.size = $HUD.size / 11
	$HUD/Text.position.x = get_viewport_rect().size.x * 0.06
	$HUD/Text.position.y = get_viewport_rect().size.y * 0.25
	$HUD/Line.size.x = $HUD.size.x
	$HUD/Line.size.y = $HUD/Text.size.y
	$HUD/Line.position.y = $HUD/Text.position.y
	$HUD.hide()
	
	#TopContainer
	$TopContainer.size = Vector2(view_port_size.x, view_port_size.y * 0.1)
	
	#Margins
	$TopContainer/LeftMargin.set_custom_minimum_size(Vector2($TopContainer.size.x * 0.005, $TopContainer.size.y))
	$TopContainer/MiddleMargin.set_custom_minimum_size(Vector2($TopContainer.size.x * 0.29, $TopContainer.size.y))	
	$TopContainer/RightMargin.set_custom_minimum_size(Vector2($TopContainer.size.x * 0.13, $TopContainer.size.y))
	
	#Left
	$TopContainer/Left.size = Vector2($TopContainer.size.x, $TopContainer.size.y)
	$TopContainer/Left/Return.set_custom_minimum_size(Vector2($TopContainer.size.x * 0.125, $TopContainer.size.y * 0.9))
	$TopContainer/Left/TopMargin.set_custom_minimum_size(Vector2($TopContainer.size.x * 0.125, $TopContainer.size.y * 0.2))
	
	#Right
	$TopContainer/Right.size = Vector2($TopContainer.size.x, $TopContainer.size.y)
	$TopContainer/Right/Save.set_custom_minimum_size(Vector2($TopContainer.size.x * 0.125, $TopContainer.size.y * 0.9))
	$TopContainer/Right/TopMargin.set_custom_minimum_size(Vector2($TopContainer.size.x * 0.125, $TopContainer.size.y * 0.2))
	
	#Label
	$TopContainer/Label.set_custom_minimum_size(Vector2($TopContainer.size.x * 0.3, $TopContainer.size.y))
	$TopContainer/Label.push_bold()
	$TopContainer/Label.push_font_size(26)
	$TopContainer/Label.append_text('')
	$TopContainer/Label.pop()
	
	var top_margin: float = view_port_size.y * 0.15
	var right_margin: float = view_port_size.x * 0.8
	var left_margin: float = view_port_size.x * 0.001
	var bottom_margin:float = view_port_size.y
	var columns: int = 3
	
	#Menu Container
	$MenuContainer.size = Vector2(view_port_size.x * 0.1, view_port_size.y * 0.8)
	$MenuContainer.position = Vector2(view_port_size.x * 0.45, top_margin)
	$MenuContainer/Container.size = $MenuContainer.size
	$MenuContainer/Container.position = $MenuContainer.position
	$MenuContainer/Container.add_theme_constant_override("separation", 11)
	
	
	#Styling
	var position: float = 0
	for child in $MenuContainer/Container.get_children():
		child.position = Vector2($MenuContainer/Container.position.x, position)
		child.set_custom_minimum_size(Vector2($MenuContainer/Container.size.x, $MenuContainer/Container.size.y * 0.15))
		child.set_modulate(Color(0, 1, 1, 1))
		
		var normal_style: Object = StyleBoxFlat.new()
		normal_style.set_border_width_all(2)
		normal_style.set_corner_radius_all(10)
		normal_style.bg_color = Color(1,0,1,1)
		child.add_theme_stylebox_override("normal", normal_style)
		
		var hover_style: Object = StyleBoxFlat.new()
		hover_style.set_border_width_all(2)
		hover_style.set_corner_radius_all(10)
		hover_style.bg_color = Color(0,0,0,1)
		child.add_theme_stylebox_override("hover", hover_style)
		
		
		var focus_style: Object = StyleBoxFlat.new()
		focus_style.set_border_width_all(5)
		focus_style.set_corner_radius_all(10)
		focus_style.bg_color = Color(0,0,0,1)
		focus_style.border_color = Color(1, 0.647059, 0, 1)
		child.add_theme_stylebox_override("focus", focus_style)
		child.position.y = position
		position += $MenuContainer/Container.size.y / $MenuContainer/Container.get_child_count()
		
	#Panel
	
	$PanelContainer.position = Vector2(left_margin, top_margin)
	$PanelContainer.size = Vector2(view_port_size.x * 0.44, view_port_size.y * 0.8)
	$PanelContainer/Panel.size = $PanelContainer.size
	$PanelContainer/Panel/Content.size = $PanelContainer.size
	$PanelContainer/Panel/Content.columns = columns
	$PanelContainer/Label.position = $PanelContainer.position

	for card in Global.temp_deck:
		var button = TextureButton.new()
		button.stretch_mode = 0
		button.toggle_mode = true
		button.material = ShaderMaterial.new()
		button.material.shader = shader

		var image = Image.load_from_file(str('res://Assets/Units/', card.name.replace(" ","").to_lower(), '/', card.get('image')))
		image.resize(224,224)
		var texture = ImageTexture.create_from_image(image)
		
		button.set_texture_normal(texture)
		button.scale *= $PanelContainer.size / texture.get_size()
		button.size = $PanelContainer/Panel/Content.size / columns
		#print(button.size)
		$PanelContainer/Panel/Content.add_child(button)
	
	$PanelContainer/Panel.horizontal_scroll_mode = 3
	$PanelContainer/Panel.vertical_scroll_mode = 3
	$PanelContainer/Panel.clip_contents = true
	$PanelContainer/Panel.follow_focus = true
	
	var panel_style: Object = StyleBoxFlat.new()
	panel_style.set_border_width_all(2)
	panel_style.set_corner_radius_all(5)
	panel_style.bg_color = Color("BLACK")
	panel_style.border_color = Color("RED")
	panel_style.draw_center = true
	panel_style.content_margin_left = $PanelContainer.size.x * 0.1
	panel_style.content_margin_top = $PanelContainer.size.y * 0.04
	panel_style.content_margin_bottom = $PanelContainer.size.y * 0.04
	$PanelContainer.add_theme_stylebox_override("panel", panel_style)
	
	#Deck
	$DeckContainer.size = Vector2(view_port_size.x * 0.44, view_port_size.y * 0.8)
	$DeckContainer.position = Vector2(view_port_size.x * 0.56, top_margin)
	$DeckContainer/Deck.size = $DeckContainer.size
	$DeckContainer/Deck/Content.size = $DeckContainer.size
	$DeckContainer/Deck/Content.columns = columns
	
	for card in Global.monster_deck:
		var button = TextureButton.new()
		button.stretch_mode = 0
		button.toggle_mode = true
		button.material = ShaderMaterial.new()
		button.material.shader = shader

		var resource = str('res://Assets/Units/', card.name.replace(" ","").to_lower(), '/', card.get('image'))
		var image = Image.load_from_file(resource)
		image.resize(224,224)
		var texture = ImageTexture.create_from_image(image)
		texture.resource_path = str('res://Assets/Units/', card.name.replace(" ","").to_lower(), '/', card.get('image')) #Store the image
		texture.resource_name = card.get('image') #Store card type
		
		button.set_texture_normal(texture)
		button.scale *= $DeckContainer.size / texture.get_size()
		button.size = $DeckContainer/Deck/Content.size / columns
		#print(button.size)
		$DeckContainer/Deck/Content.add_child(button)
		
	for card in Global.spell_deck:
		var button = TextureButton.new()
		button.stretch_mode = 0
		button.toggle_mode = true
		button.material = ShaderMaterial.new()
		button.material.shader = shader

		var image = Image.load_from_file(str('res://Assets/Spells/', card.get('image')))
		image.resize(224,224)
		var texture = ImageTexture.create_from_image(image)
		texture.resource_path = str('res://Assets/Spells/', card.get('image')) #Store the image
		texture.resource_name = card.get('image') #Store card type
		
		button.set_texture_normal(texture)
		button.scale *= $DeckContainer.size / texture.get_size()
		button.size = $DeckContainer/Deck/Content.size / columns
		#print(button.size)
		$DeckContainer/Deck/Content.add_child(button)
	
	$DeckContainer/Deck.horizontal_scroll_mode = 3
	$DeckContainer/Deck.vertical_scroll_mode = 3
	$DeckContainer/Deck.clip_contents = true
	$DeckContainer/Deck.follow_focus = true
	var deck_style: Object = StyleBoxFlat.new()
	deck_style.set_border_width_all(2)
	deck_style.set_corner_radius_all(5)
	deck_style.bg_color = Color("BLACK")
	deck_style.border_color = Color("RED")
	deck_style.draw_center = true
	deck_style.content_margin_left = $DeckContainer.size.x * 0.1
	deck_style.content_margin_top = $DeckContainer.size.y * 0.04
	deck_style.content_margin_bottom = $DeckContainer.size.y * 0.04
	$DeckContainer.add_theme_stylebox_override("panel", deck_style)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#Add
	for card in $PanelContainer/Panel/Content.get_children():
		if card.button_pressed:
			card.material = ShaderMaterial.new()
			card.material.shader = select_shader
		if not card.button_pressed:
			card.material = ShaderMaterial.new()
			card.material.shader = shader
	
	#Remove
	for card in $DeckContainer/Deck/Content.get_children():
		if card.button_pressed:
			card.material = ShaderMaterial.new()
			card.material.shader = select_shader
		if not card.button_pressed:
			card.material = ShaderMaterial.new()
			card.material.shader = shader
		
func _input(event):
	pass
		
"""
	Panel Content
"""

	
"""
	Deck Content
"""

func _on_add_pressed():
	for card in $PanelContainer/Panel/Content.get_children():
		if card.button_pressed:
			card.material = ShaderMaterial.new()
			card.material.shader = shader
			card.button_pressed = false
			$PanelContainer/Panel/Content.remove_child(card)
			$DeckContainer/Deck/Content.add_child(card)
	return
	
func _on_remove_pressed():
	for card in $DeckContainer/Deck/Content.get_children():
		if card.button_pressed:
			card.material = ShaderMaterial.new()
			card.material.shader = shader
			card.button_pressed = false
			$DeckContainer/Deck/Content.remove_child(card)
			$PanelContainer/Panel/Content.add_child(card)
	return

func _on_add_all_pressed():
	for card in $PanelContainer/Panel/Content.get_children():
		card.material = ShaderMaterial.new()
		card.material.shader = shader
		card.button_pressed = false
		$PanelContainer/Panel/Content.remove_child(card)
		$DeckContainer/Deck/Content.add_child(card)
	return
	
func _on_clear_pressed():
	for card in $DeckContainer/Deck/Content.get_children():
		card.material = ShaderMaterial.new()
		card.material.shader = shader
		card.button_pressed = false
		$DeckContainer/Deck/Content.remove_child(card)
		$PanelContainer/Panel/Content.add_child(card)
	return


func _on_save_pressed():
	
	var duplicated: bool = false
	var temp_monster_deck: Array = []
	var temp_spell_deck: Array = []
	var place_holder_deck: Array = []
	
	for card in $DeckContainer/Deck/Content.get_children():
		for monster in Global.monster_json:
			if monster.image == card.texture_normal.resource_name:
				temp_monster_deck.append(monster)
				continue
		for spell in Global.spell_json:
			if spell.image == card.texture_normal.resource_name:
				temp_spell_deck.append(spell)
				
	for card in $PanelContainer/Panel/Content.get_children():
		for monster in Global.monster_json:
			if monster.get('image') == card.texture_normal.resource_name:
				place_holder_deck.append(monster)
				
		for spell in Global.spell_json:
			if spell.get('image') == card.texture_normal.resource_name:
				place_holder_deck.append(spell)

	if temp_monster_deck.size() == 0 || temp_spell_deck.size() == 0:
		$HUD/Line.color = Color(1,0,0,1)
		$HUD/Text.text = "Place At Least 1 Monster & Spell Card In Your Deck"
		$Light.enabled = true
		$HUD.show()
		await get_tree().create_timer(1).timeout
		$Light.enabled = false
		$HUD.hide()
		return
	Global.monster_deck = temp_monster_deck
	Global.spell_deck = temp_spell_deck
	Global.temp_deck = place_holder_deck
	
	print("-----------------Monster-------------------")
	print(Global.monster_deck)
	print(str("Size: "), temp_monster_deck.size())
	print("-----------------Spell-------------------")
	print(Global.spell_deck)
	print(str("Size: "), temp_spell_deck.size())
	print("-----------------PlaceHolder-------------------")
	print(Global.temp_deck)
	print(str("Size: "), place_holder_deck.size())

	$HUD/Line.color = Color(0,1,0,1)
	$HUD/Text.text = "\t\t\t\t\t\t\t\tSaved Successfully"
	$Light.enabled = true
	$HUD.show()
	await get_tree().create_timer(1).timeout
	$Light.enabled = false
	$HUD.hide()
		
func _on_return_pressed():
	get_tree().change_scene_to_file('res://Menu/menu.tscn')
