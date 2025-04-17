#full game controller

extends Node2D
var plr_count = 2;
var timer_status = 0;
var scores = {
	"Player 1" = 0,
	"Player 2" = 0,
	"Player 3" = 0,
	"Player 4" = 0,
}

var fish_scene = preload("res://FishGame.tscn");

@onready var stats = self.get_node("Stats");
@onready var players = self.get_node("Player");
@onready var timer = stats.get_node("Timer").get_node("PanelContainer").get_node("Name");
@onready var highest = stats.get_node("CurrentLeader").get_node("PanelContainer").get_node("Name");

signal add_score(id, score);
signal remove_score(id, score);

signal start_fishing(id);
signal stop_fishing(id);

signal close_the_game();

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.get_node("Results").get_node("MainMenuContainer").get_node("MarginContainer").get_node("VBoxContainer").get_node("HBoxContainer").get_node("ExitToMenu").pressed.connect(close_the_game_button);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer_status == 1:
		var time_left = stats.get_node("TimeRemaining").time_left;
		var minute = floor(time_left / 60);
		var second = int(time_left) % 60;
		var time = "%02d:%02d" % [minute, second];
		timer.text = "[center] Time Remaining: " + time + " [/center]";

		var highest_name = "Player 1"
		for key in scores:
			if scores[key] > scores[highest_name]:
				highest_name = key;
		highest.text = "[center] Current Leader: " + highest_name + " [/center]";

func controller() -> void:
	for n in range(5, -0, -1):	
		timer.text = "[center] " + str(n) + "... [/center]";
		await get_tree().create_timer(1).timeout;

	timer.text = "[center] Get Ready... [/center]";
	await get_tree().create_timer(1).timeout;
	timer.text = "[center] GO!!! [/center]";
	await get_tree().create_timer(1).timeout;
	stats.get_node("TimeRemaining").start();
	timer_status = 1;

	for n in range(1, plr_count + 1):
		start_fishing.emit(n);

	await stats.get_node("TimeRemaining").timeout;
	print("Time's up!");

	for n in range(1, plr_count + 1):
		stop_fishing.emit(n);

	await get_tree().create_timer(6).timeout;

	var results = self.get_node("Results");
	var placements = results.get_node("MainMenuContainer").get_node("MarginContainer").get_node("VBoxContainer");

	var scores_copy = scores.duplicate();
	var sorted_scores = {};
	for n in scores.size():
		var highest_name = scores_copy.keys()[0];
		for key in scores_copy:
			if scores_copy[key] > scores_copy[highest_name]:
				highest_name = key;
		sorted_scores[highest_name] = scores[highest_name];
		scores_copy.erase(highest_name);

	placements.get_node("FirstPlace").text = "1st: " + sorted_scores.keys()[0] + " with " + str(sorted_scores.values()[0]) + " Coins!";
	placements.get_node("SecondPlace").text = "2nd: " + sorted_scores.keys()[1] + " with " + str(sorted_scores.values()[1]) + " Coins!";		

	for plr in players.get_children():
		plr.get_node("CharacterBody2D").visible = false;
		results.visible = true;
		results.get_node("MainMenuContainer").get_node("MarginContainer").get_node("VBoxContainer").get_node("HBoxContainer").get_node("ExitToMenu").grab_focus();
	await close_the_game;

func _on_time_remaining_timeout():
	timer_status = 0;
	timer.text = "[center] Game Over! [/center]";
	await get_tree().create_timer(3).timeout;
	timer.text = "[center] And the winner is... [/center]";
	await get_tree().create_timer(3).timeout;

func close_the_game_button():
	close_the_game.emit();

func _on_player_1_send_score_to_main(score) -> void:
	scores["Player 1"] = score;

func _on_player_2_send_score_to_main(score) -> void:
	scores["Player 2"] = score;