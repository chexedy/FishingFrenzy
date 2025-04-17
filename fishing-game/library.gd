class_name LibraryData extends Node

var fish_score = {
	"Common" = 15,
	"Rare" = 25,
	"Epic" = 50,
	"Legendary" = 100,
};

var fish_rarity = {
	"Common" = ["Coho Salmon", "Moray Eel", "Striped Bass", "Prawn", "Umbrella"],
	"Rare" = ["Northern Stargazer", "African Glass Catfish", "Sea Bream", "European Squid", "Flounder"],
	"Epic" = ["Oarfish", "Wobbegong", "Black Marlin", "Tuna", "Scorpionfish"],
	"Legendary" = ["Great White Shark", "Coelacanth", "Humpback Whale", "Dolphin", "Treasure Chest"],
};

var fish_odds = {
	"Common" = 4,
	"Rare" = 3,
	"Epic" = 2,
	"Legendary" = 1,
}

var fish_bar_odds = {
	"Common" = {
		"Common" = 5,
		"Rare" = 3,
		"Epic" = 1.5,
		"Legendary" = 0.5,
	},
	"Rare" = {
		"Common" = 3,
		"Rare" = 5,
		"Epic" = 1.5,
		"Legendary" = 0.5,
	},
	"Epic" = {
		"Common" = 1.5,
		"Rare" = 1.5,
		"Epic" = 5,
		"Legendary" = 2,
	},
	"Legendary" = {
		"Common" = 0.5,
		"Rare" = 1.5,
		"Epic" = 3,
		"Legendary" = 5,
	},
}

var fish_speed = {
	"Common" = Vector2(1, 1),
	"Rare" = Vector2(2.5,2.5),
	"Epic" = Vector2(4,4),
	"Legendary" = Vector2(7,7),
};

var fish_color = {
	"Common" = Color8(160, 160, 160),
	"Rare" = Color8(53, 148, 229),
	"Epic" = Color8(194, 92, 221),
	"Legendary" = Color8(229, 172, 58),
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass