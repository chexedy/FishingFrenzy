# Main Menu controller
extends Node2D
var data_array;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var buttons = self.get_node("MenuNode").get_node("MainMenuContainer").get_node("HBoxContainer").get_node("RightSide").get_node("MarginContainer").get_node("Buttons");

	buttons.get_node("FishLibrary").pressed.connect(open_fishing_library);
	self.get_node("FishLibraryNode").get_node("Close").pressed.connect(close_fishing_library);
	buttons.get_node("Rules").pressed.connect(open_rules);
	self.get_node("RulesNode").get_node("Close").pressed.connect(close_rules);
	buttons.get_node("StartGame").pressed.connect(start_the_game);
	buttons.get_node("StartGame").grab_focus();

	MinigameManager.game_started.connect(game_started_func)

func _input(event: InputEvent) -> void:
	var buttons = self.get_node("MenuNode").get_node("MainMenuContainer").get_node("HBoxContainer").get_node("RightSide").get_node("MarginContainer").get_node("Buttons");

	if event.device == 0:
		if Input.is_action_just_pressed("back_button"):
			if self.get_node("RulesNode").visible:
				close_rules();
			elif self.get_node("FishLibraryNode").visible:
				close_fishing_library();
		elif Input.is_action_just_pressed("select_button") or Input.is_action_just_pressed("select_button1"):
			if buttons.get_node("Rules").has_focus():
				open_rules();
			elif buttons.get_node("FishLibrary").has_focus():
				open_fishing_library();
			elif buttons.get_node("StartGame").has_focus():
				start_the_game();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass;

func game_started_func(player_data_array):	
	data_array = player_data_array;

func start_the_game() -> void:
	var buttons = self.get_node("MenuNode").get_node("MainMenuContainer").get_node("HBoxContainer").get_node("RightSide").get_node("MarginContainer").get_node("Buttons");

	buttons.get_node("StartGame").disabled = true;
	var game_scene = preload("res://FishGame.tscn");
	var game = game_scene.instantiate();

	self.get_node("MenuNode").get_node("MainMenuContainer").get_node("HBoxContainer").get_node("RightSide").get_node("MarginContainer").get_node("Buttons").get_node("StartGame").text = "Loading...";
	var tween = get_tree().create_tween();
	tween.tween_property(self.get_node("MenuAudio"), "volume_db", -80, 3)
	await tween.finished;
	self.get_node("MenuAudio").playing = false;
	
	self.add_child(game);
	if data_array:
		game.setup(data_array);

	game.visible = true;
	self.get_node("MenuNode").visible = false;
	self.get_node("FishLibraryNode").visible = false;
	self.get_node("RulesNode").visible = false;
	self.get_node("MenuNode").get_node("MainMenuContainer").get_node("HBoxContainer").get_node("RightSide").get_node("MarginContainer").get_node("Buttons").get_node("StartGame").text = "Start Game";

	await game.controller();
	MinigameManager.end_game();
	self.get_node("MenuNode").visible = true;
	self.get_node("MenuNode").get_node("MainMenuContainer").get_node("HBoxContainer").get_node("RightSide").get_node("MarginContainer").get_node("Buttons").get_node("StartGame").grab_focus();
	game.queue_free();

	buttons.get_node("StartGame").disabled = false;
	self.get_node("MenuAudio").playing = true;
	var tween2 = get_tree().create_tween();
	tween2.tween_property(self.get_node("MenuAudio"), "volume_db", 5, 5)

func open_fishing_library() -> void:
	self.get_node("FishLibraryNode").visible = true;

func close_fishing_library() -> void:
	self.get_node("FishLibraryNode").visible = false;
	self.get_node("MenuNode").get_node("MainMenuContainer").get_node("HBoxContainer").get_node("RightSide").get_node("MarginContainer").get_node("Buttons").get_node("FishLibrary").grab_focus();

func open_rules() -> void:
	self.get_node("RulesNode").visible = true;

func close_rules() -> void:
	self.get_node("RulesNode").visible = false;
	self.get_node("MenuNode").get_node("MainMenuContainer").get_node("HBoxContainer").get_node("RightSide").get_node("MarginContainer").get_node("Buttons").get_node("Rules").grab_focus();
