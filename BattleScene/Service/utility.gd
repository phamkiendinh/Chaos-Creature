extends BattleScene
class_name Utility
	
func empty_slot_check(dict:Dictionary, key):
	var is_empty:bool = true
	if key in dict:
		is_empty = false
	return is_empty

# Return dictionary key
func max_attri(dict:Dictionary, attri:String):
	var arr = get_obj_array(dict)
	var arr_keys = dict.keys()
	var lp_arr = []
	var final_obj_key
	for i in range(arr.size()):
		lp_arr.append(arr[i].get(attri))
	var max = lp_arr.max()
	final_obj_key = arr_keys[arr_keys.find(lp_arr[lp_arr.find(max, 0)])]
	return final_obj_key

# Return dictionary key
func _min_attri(dict:Dictionary, attri:String):
	var arr = get_obj_array(dict)
	var arr_keys = dict.keys()
	var lp_arr = []
	var final_obj_key
	for i in range(arr.size()):
		lp_arr.append(arr[i].get(attri))
	var min = lp_arr.min()
	final_obj_key = arr_keys[arr_keys.find(lp_arr[lp_arr.find(min, 0)])]
	return final_obj_key
	
func get_obj_array(dict:Dictionary):
	var obj_arr = dict.values()
	return obj_arr
