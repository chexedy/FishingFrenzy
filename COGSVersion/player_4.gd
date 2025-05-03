# this script controls the fishing game and updating each players stats
extends Control

var data = LibraryData.new();
var current_score = 0;
const plr_id = 4;
var rarity = ["Common", "Rare", "Epic", "Legendary"];
var currently_fishing = false;
var is_run_fishing_running = false;
var pos_change = 500;

signal stop_fishing_button();
signal send_score_to_main(score);

@onready var player = owner.get_node("Player").get_node("Player" + str(plr_id));
@onready var hook = player.get_node("CharacterBody2D")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bar = self.get_node("ProgressBar").get_node("RarityHolder");

	for key in data.fish_odds:
		bar.get_node(key).size_flags_stretch_ratio = data.fish_odds[key];

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if currently_fishing:
		if !is_run_fishing_running:
			run_fishing();

		var direction = Input.get_vector("move_left4", "move_right4", "move_up4", "move_down4");
		hook.velocity = direction * pos_change;
		hook.move_and_slide();

func _input(event: InputEvent) -> void:
	if currently_fishing:
		if Input.is_action_just_pressed("select_button4"):
				stop_fishing_button.emit();
				return;	

func _on_game_add_score(id, score) -> void:
	if (id != plr_id):
		return
	
	var new_score = current_score + score;
	current_score = new_score;
	self.get_node("Score").text = "     Coins: " + str(current_score)

	send_score_to_main.emit(current_score);

func _on_game_remove_score(id:Variant, score:Variant) -> void:
	if (id != plr_id):
		return
	
	var new_score = current_score - score;
	current_score = new_score;
	self.get_node("Score").text = "     Coins: " + str(current_score)

	send_score_to_main.emit(current_score);

func run_fishing() -> void:
	is_run_fishing_running = true;
	var texture = self.get_node("ArrowStart");
	var texture_position = self.get_node("ArrowPosition");
	var bar = self.get_node("ProgressBar").get_node("RarityHolder");
	texture.position = Vector2(294, 522);

	await stop_fishing_button;
	player.get_node("CharacterBody2D").visible = false;
	var hook_rarity = hook_fish();
	if hook_rarity == "Nothing":
		self.get_node("FishResult").get_node("VBoxContainer").get_node("Name").text = "[center] You caught [/center]"
		self.get_node("FishResult").get_node("VBoxContainer").get_node("FishResult").text = "[center] Nothing : ( [/center]";
		self.get_node("FishResult").visible = true;
		await get_tree().create_timer(1).timeout;
		self.get_node("FishResult").visible = false;
		is_run_fishing_running = false;
		player.get_node("CharacterBody2D").visible = true;
		return;

	adjust_odds(hook_rarity);
	randomize();
	rarity.shuffle();
	await get_tree().process_frame;

	for n in 4:
		bar.move_child(bar.get_node(rarity[n]), n);

	var tween = get_tree().create_tween();
	tween.set_loops();
	tween.tween_property(texture, "position", Vector2(294, 143), 0.35);
	tween.parallel().tween_property(texture_position, "position", Vector2(199,103), 0.35);
	tween.tween_property(texture, "position", Vector2(294, 522), 0.35);
	tween.parallel().tween_property(texture_position, "position", Vector2(199,482), 0.35);
	await stop_fishing_button;
	tween.kill();

	var selected_rarity;
	for n in self.get_node("ProgressBar").get_node("RarityHolder").get_children():
		if texture_position.global_position.y >= n.global_position.y:
			if texture_position.global_position.y < (n.global_position.y + n.size.y):
				selected_rarity = n.name;
	if selected_rarity == null:
		selected_rarity = self.get_node("ProgressBar").get_node("RarityHolder").get_children()[0].name;
		print(texture_position.global_position.y);
		print("Could not detect a rarity");

	var selected_fish = data.fish_rarity[selected_rarity].pick_random();
	_on_game_add_score(plr_id, data.fish_score[selected_rarity]);

	self.get_node("FishResult").visible = true;
	self.get_node("FishResult").get_node("VBoxContainer").get_node("Name").text = "[center] You caught a " + selected_rarity + " [/center]"
	self.get_node("FishResult").get_node("VBoxContainer").get_node("FishResult").text = "[center]" + selected_fish + "![/center]";

	await get_tree().create_timer(1).timeout;

	player.get_node("CharacterBody2D").visible = true;
	self.get_node("FishResult").visible = false;
	is_run_fishing_running = false;


func _on_game_start_fishing(id) -> void:
	if (id != plr_id):
		return;
		
	currently_fishing = true;

func _on_game_stop_fishing(id:Variant) -> void:
	if (id != plr_id):
		return;
		
	currently_fishing = false;
	self.get_node("ArrowStart").queue_free();
	self.get_node("ArrowPosition").queue_free();

func hook_fish():
	var collision_array = hook.get_node("Area2D").get_overlapping_bodies();
	if collision_array:
		var collision = collision_array[0];
		collision.owner.destroy_fish();
		return collision.owner.get_rarity();
	else:
		return "Nothing";

func adjust_odds(hooked_rarity):
	var bar = self.get_node("ProgressBar").get_node("RarityHolder");
	
	for key in data.fish_bar_odds[hooked_rarity]:
		bar.get_node(key).size_flags_stretch_ratio = data.fish_bar_odds[hooked_rarity][key];
