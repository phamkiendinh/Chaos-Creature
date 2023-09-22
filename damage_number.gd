class_name DamageNumber2D
extends Node2D

@onready var label:Label = $LabelContainer/Label
@onready var label_container:Node2D = %LabelContainer
@onready var ap:AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

	
func set_values_and_animate(value:String, start_pos:Vector2, height:float, spread:float) -> void:
	$LabelContainer/Label.text = value
	$AnimationPlayer.play("scale_x")
	
	var tween = get_parent().get_tree().create_tween()
	var end_pos = Vector2(randf_range(-spread,spread),-height) + start_pos
	var tween_length = $AnimationPlayer.get_animation("scale_x").length
	
	tween.tween_property($LabelContainer,"position",end_pos,tween_length).from(start_pos)


func remove() -> void:
	$AnimationPlayer.stop()
	queue_free()
	if is_inside_tree():
		get_parent().remove_child(self)
