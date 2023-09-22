var DATA = {
	"Effect" :
	[
		{
			"Attack_up" : 
			{
				"id": 1,
				"name": "attack_up",
				"is_beneficial": true,
				"priority": 0,
				"duration": 2,
				"is_removable": true,
				"can_stack": true,
				"entry_effect": "none",
				"per_cycle_effect": "none",
				"on_leave_effect": "none",
				"persistent_effect": "attack_up"
			}
		},
		
		{
			"Damage_over_time" : 
			{
				"id": 1,
				"name": "dot",
				"is_beneficial": false,
				"priority": 1,
				"duration": 3,
				"is_removable": true,
				"can_stack": true,
				"entry_effect": "none",
				"per_cycle_effect": "dot",
				"on_leave_effect": "none",
				"persistent_effect": "none"
			}
		},
		
		
		{
			"Say_hi" : 
			{
				"id": 1,
				"name": "say_hi",
				"is_beneficial": false,
				"priority": 1,
				"duration": 3,
				"is_removable": true,
				"can_stack": true,
				"entry_effect": "none",
				"per_cycle_effect": "dot",
				"on_leave_effect": "none",
				"persistent_effect": "none"
			}
		},
		{
			"Destined_Death" : 
			{
				"id": 1,
				"name": "destined_death",
				"is_beneficial": true,
				"priority": 1,
				"duration": 3,
				"is_removable": false,
				"can_stack": false,
				"entry_effect": "lp_down",
				"per_cycle_effect": "dot",
				"on_leave_effect": "none",
				"persistent_effect": "none"
			}
		},
		
		
	]
}

