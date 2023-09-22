# { id, name, rune, rune_capacity, rune_gain_per_turn, max_card, card_in_hand, image, affinities, abilities, abilities_slot, artifact, text }
var DATA = {
	"Enemy" :
	[
		{
			"Thor" : 
			{
				"id": 1,
				"name": "Thor",
				"life_point" : 200,
				"rune": 20,
				"rune_capacity" : 20,
				"rune_gain_per_turn": 1,
				"max_card": 7,
				"card_in_hand": 10,
				"image" : "Footman.png", 
				"affinities": ['E','D'],
				"abilities": ['Thunder', 'Immunity', 'Slayer'],
				"abilities_slot": 3,
				"artifact": ['Art 1', "Art 2"],
				"text": "God of Thunder, Thor"
			}
		},
		{
			"Brynhildr" : {
				"id": 2,
				"name": "Brynhildr",
				"life_point" : 150,
				"rune": 20,
				"rune_capacity" : 20,
				"rune_gain_per_turn": 1,
				"max_card": 7,
				"card_in_hand": 5,
				"image" : "Footman.png", 
				"affinities": ['E','D'],
				"abilities": ['Courage', 'Heal'],
				"abilities_slot": 5,
				"artifact": ['Art 1', "Art 2"],
				"text": "Chooser of the Slain, Valkyrie"
			}
		},
		{
			"Freyja" : {
				"id": 3,
				"name": "Freyja",
				"life_point" : 100,
				"rune": 20,
				"rune_capacity" : 20,
				"rune_gain_per_turn": 2,
				"max_card": 7,
				"card_in_hand": 5,
				"image" : "Footman.png", 
				"affinities": ['E','D'],
				"abilities": ['Far Sigh'],
				"abilities_slot": 4,
				"artifact": ['Art 1', "Art 2"],
				"text": "Freyja, The Watchman of the Gods"
			}
		},
	]
}
