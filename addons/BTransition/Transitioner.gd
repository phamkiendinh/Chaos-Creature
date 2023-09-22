@icon("res://addons/BTransition/BTransition.svg")
extends Node
class_name Transitioner

## Transitions scenes smoothly using tweens.
##
## Allows for you to transition scenes smoothly from one to another.
## This addon supports for 4 directions of scene transitions.
## [br][br]For variables used by this node, view [BTrans].

## Viewport size.
var viewport_size : Vector2
## Viewport size with integers.
var viewport_sizei : Vector2i

## Allows the window to be resized during a transition. Useful when window is fullscreen.
@export var allow_window_resizing : bool = false

func _process(_delta):
	viewport_sizei = get_viewport().size
	viewport_size = Vector2(viewport_sizei)

## Transitions from one scene to another
## Example Transition:
	## [codeblock]
	## transition_scene(self, "res://scenes/Settings.tscn", 1.0, Tween.TRANS_SINE, Tween.EASE_OUT, BTrans.DIRECTION.UP)
	## [/codeblock]
func transition_scene(old_scene : Object, new_scene_path : String, time : float, transition_type : Tween.TransitionType, ease_type : Tween.EaseType, direction : BTrans.DIRECTION):
	set_process(true)
#	if !allow_window_resizing:
#		get_window().unresizable = not (false)
	var scene = old_scene
	
	if direction == BTrans.DIRECTION.DOWN:
		scene.position = Vector2(0, viewport_size.y)
	elif direction == BTrans.DIRECTION.UP:
		scene.position = Vector2(0, -viewport_size.y)
	elif direction == BTrans.DIRECTION.LEFT:
		scene.position = Vector2(-viewport_size.x, 0)
	elif direction == BTrans.DIRECTION.RIGHT:
		scene.position = Vector2(viewport_size.x, 0)
	
	var tween = get_tree().create_tween()
	tween.set_ease(ease_type)
	tween.set_trans(transition_type)
	tween.tween_property(scene, "position", Vector2(0, 0), time)
	
	await get_tree().create_timer(time+0.05).timeout
		
#	if !allow_window_resizing:
#		get_window().unresizable = not (true)
	set_process(false)
