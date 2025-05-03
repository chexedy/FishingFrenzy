extends Node2D

var data = LibraryData.new();
var fish_amount = 0;
var fish = preload("res://Fish.tscn")
var current_pond = {
	"Common" = [],
	"Rare" = [],
	"Epic" = [],
	"Legendary" = [],
}

@onready var water = self.get_node("Water");

func _ready() -> void:
	water.child_entered_tree.connect(child_entered);
	water.child_exiting_tree.connect(child_exited);

	for n in 4:
		add_fish();
		await get_tree().create_timer(1).timeout;

var t = 0.0
func _process(delta: float) -> void:
	pass;
	t += delta;

	if fish_amount <= 15 and t >= 1.5:
		add_fish();
		t = 0.0;

func add_fish():
	var new_fish = fish.instantiate();
	water.add_child(new_fish);
	
	randomize();
	new_fish.position = Vector2(randi() % 350 + 81, randi() % 250 + 131);

	var chances = [];
	for key in data.fish_odds:
		for n in data.fish_odds[key]:
			chances.insert(0, key);

	var rarity = chances.pick_random();
	new_fish.setup(rarity, data.fish_speed[rarity], data.fish_color[rarity]);

func child_entered():
	fish_amount += 1;

func child_exited():
	fish_amount -= 1;
