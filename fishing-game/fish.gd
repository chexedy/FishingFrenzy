extends Node2D
var data = LibraryData.new();

var rarity;
var speed;
var color;

var is_fishable = false;
var fish_lifespan = 15;
var fish_age = 0;

var random_angle: float;
var direction;

@onready var body = self.get_node("CharacterBody2D");
@onready var sprite = body.get_node("FishSprite");

#give the hook a mask of 2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	random_angle = randf_range(0, TAU);
	direction = Vector2.from_angle(random_angle);
	is_fishable = true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fish_age += delta;

	if fish_age >= fish_lifespan:
		destroy_fish();

func setup(rarity, speed, color):
	self.rarity = rarity;
	self.color = color;
	self.modulate = color;
	self.speed = speed;
	
	body.velocity = speed;
	if rarity == "Rare":
		sprite.speed_scale = 1.5;
	elif rarity == "Epic":
		sprite.speed_scale = 2;
	elif rarity == "Legendary":
		sprite.speed_scale = 3

func _physics_process(delta: float) -> void:
	if is_fishable:
		var collision = body.move_and_collide(direction * speed);
		sprite.rotation = direction.angle();

		if collision:
			if collision.get_collider().is_in_group("pond_edges"):
				random_angle = randf_range(0, TAU);
				direction = Vector2.from_angle(random_angle);

func get_fishable() -> bool:
	return is_fishable;

func get_rarity():
	return rarity;

func destroy_fish():
	is_fishable = false;
	sprite.stop();
	var tween = get_tree().create_tween();
	tween.tween_property(self, "modulate:a", 0, 3);		
	await tween.finished;
	queue_free();
