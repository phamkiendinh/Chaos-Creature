var DATA = {
	"Ability" :
	[
		{
			"Damage_up" : 
			{
				"id": 1,
				"name": "attack_up",
				"type": "stat_modifer_buff",
				"effect": "attack_up",
				"modified_stat": "attack_power",
				"modified_amount" : 10, 
				"attack_power": 10,
				"duration": 3,
				"affinity": ['E','M'],
				"targeting": "self",
				"cost": 1,
				"is_active" :false,
				"owner": ["Footman", "Squadleader"]
			}
		},
		
		{
			"Damage_over_time" : 
			{
				"id": 2,
				"name": "dot",
				"type": "damage_effect",
				"effect": "dot",
				"modified_stat": "life_point",
				"modified_amount" : 10, 
				"attack_power": 5,
				"duration": 3,
				"affinity": ['E','M'],
				"targeting": "random",
				"cost": 2,
				"is_active" :false,
				"owner": ["Archer"]
			}
		},
		
		{
			"Max_lp_up" : 
			{
				"id": 3,
				"name": "max_lp_up",
				"type": "stat_modifer_buff",
				"effect": "max_lp_up",
				"modified_stat": "life_point",
				"modified_amount" : 10, 
				"attack_power": 5,
				"duration": 3,
				"affinity": ['E','M'],
				"targeting": "self",
				"cost": 2,
				"is_active" :false,
				"owner": ["Archer"]
			}
		},
		
			{
			"Say Hi" : 
			{
				"id": 4,
				"name": "say_hi",
				"effect": "say_hi",
				"type": "stat_modifer_buff",
				"modified_stat": "life_point",
				"modified_amount" : 10, 
				"attack_power": 5,
				"duration": 3,
				"affinity": ['E','M'],
				"targeting": "self",
				"cost": 2,
				"is_active" :false,
				"owner": ["Archer"]
			}
		},
		
	]
}
