#JSON Format
var DATA = {
	"Event" :
	[
		{
			"id": "GE1",
			"name": "A Sound Rest",
			"type": "generic",
			"background" : "a1.png", 
			"flavor_text": "Every Journey Desires a Brief Respite",
			"rewards_flavor_text": "Get Some Health Back",
			"exit_flavor_text": "0",
			"rewards": {"restore_life_point": 50},
		},
		{
			"id": "GE2",
			"name": "Persona",
			"type": "generic",
			"background" : "a1.png", 
			"flavor_text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
			"rewards_flavor_text": "Buff Single Attack By A Lot",
			"exit_flavor_text": "0",
			"rewards": {"single_attack": 1000000},
		},
		
		{
			"id": "GE3",
			"name": "Mit",
			"type": "generic",
			"background" : "a1.png", 
			"flavor_text": "You Feel More Resilient",
			"rewards_flavor_text": "Nothing could stop you",
			"exit_flavor_text": "0",
			"rewards": {"mitigation": 727},
		},
		
		{
			"id": "GE4",
			"name": "Bombardment",
			"type": "generic",
			"background" : "a1.png", 
			"flavor_text": "You found a pile of old, broken weapons, a fireced battle have happened here.",
			"rewards_flavor_text": "Could be Useful",
			"exit_flavor_text": "Seems dangerous, best to leave them be.",
			"rewards": {"aoe_attack": 50000},
		},
		
		{
			"id": "GE5",
			"name": "Bombardment",
			"type": "generic",
			"background" : "a1.png", 
			"flavor_text": "A strange man standing in front of you, dressed in drappy clothes that look like he isnt't even in the same century as you. Flicking his strange metal hat that seems to do little to protect from anything, he tells you about a strange tale.",
			"rewards_flavor_text": "Bizzare things you heard, \nbut somehow, you feel empowered",
			"exit_flavor_text": "Whatever the man says, you are not having any of it. \nYou stomped off angrily.",
			"rewards": {"aoe_attack": 50000,
						"single_attack": 50000},
		},
		
	]
}

