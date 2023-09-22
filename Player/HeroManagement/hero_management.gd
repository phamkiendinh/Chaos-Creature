extends Node2D

@onready var view_port_size: Vector2 = get_viewport().size
@onready var shader: Object = preload("res://Deck/deck_management.gdshader")
@onready var select_shader: Object = preload("res://Deck/select_shader.gdshader")
@onready var item_selecting_index: int = -1
@onready var index: int = 0
@onready var counter: int = 0
@onready var select_artifact: bool = true
@onready var dragging: bool = false
@onready var time: float = 0
@onready var artifact: Object = null
@onready var pop_up_item_count = 0
@onready var is_mouse_inside_bag: bool = false
@onready var first_load: bool = true
@onready var columns: int = 4
#@onready var done_pop_up: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$PopUp.visible = false


	$ArtifactRow.size.x = view_port_size.x * 0.1
	$ArtifactRow.size.y = view_port_size.y * 0.9
	$ArtifactRow.position = Vector2(view_port_size.x * 0.1, view_port_size.y * 0.05)
	
	#$ArtifactRow/Slot1.size = $ArtifactRow.size * 0.1
	#$ArtifactRow/Slot2.size = $ArtifactRow.size * 0.1
	#$ArtifactRow/Slot3.size = $ArtifactRow.size * 0.1
	#$ArtifactRow/Slot4.size = $ArtifactRow.size * 0.1
	#$ArtifactRow/Slot5.size = $ArtifactRow.size * 0.1
	$ArtifactRow.add_theme_constant_override("separation", 20)
	

	for child in $ArtifactRow.get_children():
		child.material = ShaderMaterial.new()
		child.material.shader = shader 

	$BagContainer.size =  Vector2(view_port_size.x * 0.5, view_port_size.y * 0.9)
	$BagContainer.position = Vector2(view_port_size.x * 0.255, view_port_size.y * 0.05)
	$BagContainer/Artifact/Content.scale *= 0.5

	$Window.size.y = $BagContainer.size.y / 1.5
	$Window.size.x = $BagContainer.size.x / 2.2
	$Window/Background.scale *= $Window.size / $Window/Background.texture.get_size()
	$Window.position.y = $BagContainer.position.y + $BagContainer.size.y / 5
	$Window.position.x = $BagContainer.position.x + $BagContainer.size.x + 10
	$Window.size = $Window.size
	
	$Window/Container.size.x = $Window.size.x * 0.98
	$Window/Container.size.y = $Window.size.y * 0.98
	
	$Window/Container.position.x += $Window.size.x * 0.01
	$Window/Container.position.y += $Window.size.y * 0.01
	
	$Window/Container/Container.size = $Window/Container.size * 0.5

	$Back.size = view_port_size / 11
	$Back.position = Vector2(10,10)
	
	var sample_item_size: Vector2 = Vector2()
	var sample_done: bool = false
	
	for child in $BagContainer.get_children():
		child.get_child(0).columns = columns
		child.horizontal_scroll_mode = 3
		child.vertical_scroll_mode = 3
		child.clip_contents = true
		child.follow_focus = true
		child = child.get_child(0)
		for item in child.get_children():
			item.stretch_mode = 0
			item.toggle_mode = true
			item.action_mode = 0
			if not sample_done:
				sample_item_size = item.size
				sample_done = true
			item.material = ShaderMaterial.new()
			item.material.shader = shader


	
	var bag_style: Object = StyleBoxFlat.new()
	bag_style.set_border_width_all(2)
	bag_style.set_corner_radius_all(5)
	bag_style.bg_color = Color("BLACK")
	bag_style.border_color = Color("RED")
	bag_style.draw_center = true
	bag_style.content_margin_left = $BagContainer.size.x * 0.03
	bag_style.content_margin_top = $BagContainer.size.y * 0.04
	bag_style.content_margin_bottom = $BagContainer.size.y * 0.04
	$BagContainer.add_theme_stylebox_override("panel", bag_style)
	

	for child in Global.temp_artifact_deck:
		var button = TextureButton.new()
		button.stretch_mode = 0
		button.toggle_mode = true
		button.material = ShaderMaterial.new()
		button.material.shader = shader

		var resource = str('res://Assets/Artifacts/', child.image)
		var image = Image.load_from_file(resource)
		image.resize(224,224)
		var texture = ImageTexture.create_from_image(image)
		texture.resource_path = str('res://Assets/Artifacts/', child.image) #Store the image
		texture.resource_name = child.image #Store card type
		
		button.set_texture_normal(texture)
		button.scale *= $BagContainer.size / texture.get_size()
		button.size = $BagContainer/Artifact/Content.size / columns
		$BagContainer/Artifact/Content.add_child(button)
	
	$Window/Container.visible = false
func _physics_process(delta):
	#Add Artifact On Click
	if check_mouse_position_inside_bag():
		is_mouse_inside_bag = true
	else:
		is_mouse_inside_bag = false
	
	if is_mouse_inside_bag:
				
		match $BagContainer.current_tab:
			0:
				#Check when user click
				if select_artifact:
					index = 0
					counter = 0 
					for child in $BagContainer/Artifact/Content.get_children():
						if child.button_pressed:
							counter += 1
					
					if counter == 0:
						$Window/Container.visible = false
						for child in $BagContainer/Artifact/Content.get_children():
							child.material = ShaderMaterial.new()
							child.material.shader = shader
							
						item_selecting_index = -1
						index = 0
						artifact = null
					if counter == 1:
						for child in $BagContainer/Artifact/Content.get_children():
							if child.button_pressed:
								child.material = ShaderMaterial.new()
								child.material.shader = select_shader
								item_selecting_index = index
								artifact = child
								for data in Global.artifact_json:
									if data.image == artifact.texture_normal.resource_name:
										var resource = str('res://Assets/Artifacts/', data.image)
										var image = Image.load_from_file(resource)
										image.resize(224,224)
										var texture = ImageTexture.create_from_image(image)
										texture.resource_path = str('res://Assets/Artifacts/', data.image) #Store the image
										texture.resource_name = data.image #Store card type
										$Window.get_node('Container/Image').texture_normal = texture #load(str('res://Assets/Artifacts/', data.image))
										$Window.get_node('Container/Container/Name/Text').text = data.get('name')
										$Window.get_node('Container/Container/Description/Text').text = data.get('text')
										$Window/Container.visible = true
							else:
								index += 1
								if index > $BagContainer/Artifact/Content.get_child_count():
									index = 0
					if counter > 1:
						for child in $BagContainer/Artifact/Content.get_children():
							if child.button_pressed and index == 0 and item_selecting_index == 0:
								index += 1
								continue

							if child.button_pressed and index != item_selecting_index:
								child.material = ShaderMaterial.new()
								child.material.shader = select_shader
								var old_artifact = $BagContainer/Artifact/Content.get_child(item_selecting_index)
								old_artifact.button_pressed = false
								old_artifact.material = ShaderMaterial.new()
								old_artifact.material.shader = shader
								item_selecting_index = index
								index = 0
								artifact = child
								break
#			1:
#				index = 0
#				counter = 0 
#				for item in $BagContainer/Elixir/Content.get_children():
#					if item.button_pressed:
#						counter += 1
#				
#				if counter == 0:
#					for item in $BagContainer/Elixir/Content.get_children():
#						item.material = ShaderMaterial.new()
#						item.material.shader = shader
#						
#					item_selecting_index = -1
#					index = 0
#					artifact = null
#						
#				if counter == 1:
#					for item in $BagContainer/Elixir/Content.get_children():
#						if item.button_pressed:
#							item.material = ShaderMaterial.new()
#							item.material.shader = select_shader
#							item_selecting_index = index
#							card = item
#							var unit = str(item.get_texture_normal().resource_path).get_file()
#							unit = unit.substr(0, unit.find('.'))
#							#for data in json:
#							#	if data.name == unit:
							#		$Window.get_node('Container/Image').texture_normal = load(item.get_texture_normal().resource_path)
							#		$Window.get_node('Container/Container/Name/Text').text = data.name
							#		$Window.get_node('Container/Container/Attack/Text').text = str(data.attack_power)
							#		$Window.get_node('Container/Container/Rune/Text').text = str(data.rune)
							#		$Window.get_node('Container/Container/Description/Text').text = data.text
							#		$Window.show()
#							break

#						else:
#							index += 1
#							if index > $BagContainer/Elixir/Content.get_child_count():
#								index = 0
#				if counter > 1:
#					for item in $BagContainer/Elixir/Content.get_children():
#						if item.button_pressed and index == 0 and item_selecting_index == 0:
#							index += 1
#							continue
#
#						if item.button_pressed and index != item_selecting_index:
#							item.material = ShaderMaterial.new()
#							item.material.shader = select_shader
#							var old_artifact = $BagContainer/Elixir/Content.get_child(item_selecting_index)
#							old_artifact.button_pressed = false
#							old_artifact.material = ShaderMaterial.new()
#							old_artifact.material.shader = shader
#							item_selecting_index = index
#							index = 0
#							card = item
#							break
#				pass
#			2:
#				index = 0
#				counter = 0 
#				for item in $BagContainer/Material/Content.get_children():
#					if item.button_pressed:
#						counter += 1
#				
#				if counter == 0:
#					for item in $BagContainer/Material/Content.get_children():
#						item.material = ShaderMaterial.new()
#						item.material.shader = shader
#						
#					item_selecting_index = -1
#					index = 0
#					card = null
#						
#				if counter == 1:
#					for item in $BagContainer/Material/Content.get_children():
#						if item.button_pressed:
#							item.material = ShaderMaterial.new()
#							item.material.shader = select_shader
#							item_selecting_index = index
#							card = item
##							unit = unit.substr(0, unit.find('.'))
#							for data in json:
#								if data.name == unit:
#									$Window.get_node('Container/Image').texture_normal = load(item.get_texture_normal().resource_path)
#									$Window.get_node('Container/Container/Name/Text').text = data.name
#									$Window.get_node('Container/Container/Attack/Text').text = str(data.attack_power)
#									$Window.get_node('Container/Container/Rune/Text').text = str(data.rune)
#									$Window.get_node('Container/Container/Description/Text').text = data.text
#									$Window.show()
#							break
#						else:
#							index += 1
#							if index > $BagContainer/Material/Content.get_child_count():
#								index = 0
#				if counter > 1:
#					for item in $BagContainer/Material/Content.get_children():
#						if item.button_pressed and index == 0 and item_selecting_index == 0:
#							index += 1
#							continue
#
#						if item.button_pressed and index != item_selecting_index:
#							item.material = ShaderMaterial.new()
#							item.material.shader = select_shader
#							var old_artifact = $BagContainer/Material/Content.get_child(item_selecting_index)
#							old_artifact.button_pressed = false
#							old_artifact.material = ShaderMaterial.new()
#							old_artifact.material.shader = shader
#							item_selecting_index = index
#							index = 0
#							card = item
#							break
#				pass
#
	
func check_mouse_position_inside_bag():
	var mouse_position: Vector2 = get_global_mouse_position()
	var bag: Object = $BagContainer
	if mouse_position.x < bag.position.x or mouse_position.x > (bag.position.x + bag.size.x):
		return false
	elif mouse_position.y < bag.position.y or mouse_position.y > (bag.position.y + bag.size.y):
		return false
	else:
		return true
	
func _input(event):
	if Input.is_action_just_released("right_click") && is_mouse_inside_bag && counter >= 1:
		update_popup()
		pass


func update_popup():
	print("------------------Artifact Deck ----------------------")
	print(Global.artifact_deck)
	print("------------------ Storage Deck ----------------------")	
	print(Global.temp_artifact_deck)
	
	var bag = $BagContainer
	var current_tab_index: int = bag.current_tab
	var pop_up: Object = $PopUp
	var mouse_position: Vector2 = get_global_mouse_position()
	pop_up.visible = true
	pop_up.position = mouse_position
	pop_up.clear()
	match current_tab_index:
		0:
			pop_up.add_item('Add to Artifact Slot 1')
			pop_up.add_item('Add to Artifact Slot 2')
			pop_up.add_item('Add to Artifact Slot 3')
			pop_up.add_item('Add to Artifact Slot 4')
			pop_up.add_item('Add to Artifact Slot 5')
			pop_up_item_count = 5
			pass
		1:
			pop_up.add_item('Use')
			pop_up.add_item('Details')
			pop_up_item_count = 2
			pass
		2:
			pop_up.add_item('Use')
			pop_up.add_item('Details')
			pop_up_item_count = 2
			pass
	pop_up.popup(Rect2(mouse_position.x, mouse_position.y, pop_up.size.x, 0))
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_pop_up_index_pressed(index: int):
	$PopUp.visible = false
	var texture = artifact.get_texture_normal()
	#print(card.texture_normal.resource_path)
	if pop_up_item_count == 5:
		match index:
			0:
				if Global.artifact_deck[0] == null:
					move_artifact_to_slot(artifact, '', 0)
					$ArtifactRow/Slot1.set_texture_normal(texture)
				else:
					var added_artifact = ($ArtifactRow/Slot1.texture_normal.resource_name)
					move_artifact_to_slot(artifact, added_artifact, 0)
					$ArtifactRow/Slot1.set_texture_normal(texture)
			1:
				if Global.artifact_deck[1] == null:
					move_artifact_to_slot(artifact, '', 1)
					$ArtifactRow/Slot2.set_texture_normal(texture)
				else:
					var added_artifact = ($ArtifactRow/Slot2.texture_normal.resource_name)
					move_artifact_to_slot(artifact, added_artifact, 1)
					$ArtifactRow/Slot2.set_texture_normal(texture)

			2:
				if Global.artifact_deck[2] == null:
					move_artifact_to_slot(artifact, '', 2)
					$ArtifactRow/Slot3.set_texture_normal(texture)
				else:
					var added_artifact = ($ArtifactRow/Slot3.texture_normal.resource_name)
					move_artifact_to_slot(artifact, added_artifact, 2)
					$ArtifactRow/Slot3.set_texture_normal(texture)

			3:
				if Global.artifact_deck[3] == null:
					move_artifact_to_slot(artifact, '', 3)
					$ArtifactRow/Slot4.set_texture_normal(texture)
				else:
					var added_artifact = ($ArtifactRow/Slot4.texture_normal.resource_name)
					move_artifact_to_slot(artifact, added_artifact, 3)
					$ArtifactRow/Slot4.set_texture_normal(texture)

			4:
				if Global.artifact_deck[4] == null:
					move_artifact_to_slot(artifact, '', 4)
					$ArtifactRow/Slot5.set_texture_normal(texture)
				else:
					var added_artifact = ($ArtifactRow/Slot5.texture_normal.resource_name)
					move_artifact_to_slot(artifact, added_artifact, 4)
					$ArtifactRow/Slot5.set_texture_normal(texture)
				
func move_artifact_to_slot(artifact, added_artifact, slot: int):
	var artifact_data = ''
	for data in Global.artifact_json:
		if data.image == artifact.texture_normal.resource_name:
			artifact_data = data
			break
	if Global.artifact_deck[slot] == null:
		
		var index:int = 0
		for data in Global.temp_artifact_deck:
			if data.image == artifact.texture_normal.resource_name:
				Global.artifact_deck[slot] = artifact_data
				for child in $BagContainer/Artifact/Content.get_children():
					if child.texture_normal.resource_name == artifact.texture_normal.resource_name:
						var parent = child.get_parent()
						parent.remove_child(child)
						break
				Global.temp_artifact_deck.remove_at(index)
				break
			index += 1
	else:
		var artifact_old_data = ''
		for data in Global.artifact_json:
			if data.image == added_artifact:
				artifact_old_data = data
				break
			
		var index:int = 0
		for data in Global.temp_artifact_deck:
			if data.image == artifact.texture_normal.resource_name:
				Global.artifact_deck[slot] = artifact_data
				for child in $BagContainer/Artifact/Content.get_children():
					if child.texture_normal.resource_name == artifact.texture_normal.resource_name:
						child.get_parent().remove_child(child)
						child.queue_free()
						Global.temp_artifact_deck.remove_at(index)
						Global.temp_artifact_deck.append(artifact_old_data)
						## Recreate button
						var button = TextureButton.new()
						button.stretch_mode = 0
						button.toggle_mode = true
						button.material = ShaderMaterial.new()
						button.material.shader = shader

						var resource = str('res://Assets/Artifacts/', added_artifact)
						var image = Image.load_from_file(resource)
						image.resize(224,224)
						var texture = ImageTexture.create_from_image(image)
						texture.resource_path = str('res://Assets/Artifacts/', added_artifact) #Store the image
						texture.resource_name = added_artifact #Store card type
						
						button.set_texture_normal(texture)
						button.scale *= $BagContainer.size / texture.get_size()
						button.size = $BagContainer/Artifact/Content.size / columns
						#print(button.size)
						$BagContainer/Artifact/Content.add_child(button)
						break
				break
			index += 1

	
	if pop_up_item_count == 2:
		match index:
			0:
				pass
			1:
				pass
				
	$PopUp.position = Vector2(0,0)
	match $BagContainer.current_tab:
		0:
			for child in $BagContainer/Artifact/Content.get_children():
				child.button_pressed = false
		1:
			for child in $BagContainer/Elixir/Content.get_children():
				child.button_pressed = false
		2: 
			for child in $BagContainer/Material/Content.get_children():
				child.button_pressed = false
	pass


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Menu/menu.tscn")
