extends Node
@export var mob_scene: PackedScene
@export var boost_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func increase_health():
	var tmpHealth = $HUD.get_score()
	print("Starting Health:" + str(tmpHealth))
	if tmpHealth <= 10:
		tmpHealth += 1
		$HUD.update_score(tmpHealth)
		$Player.update_animation(tmpHealth)
		print("Ending Health:" + str(tmpHealth))
	

func decrease_health():
	var tmpHealth = $HUD.get_score()
	print("Starting Health:" + str(tmpHealth))
	if tmpHealth > 0:
		tmpHealth -= 1
		$HUD.update_score(tmpHealth)
		$Player.update_animation(tmpHealth)
		print("Ending Health:" + str(tmpHealth))
	if tmpHealth == 0:
		$HUD.update_score(tmpHealth)
		$Player.update_animation(tmpHealth)
		game_over()

func update_health(x):
	# https://www.youtube.com/watch?v=vkHT5rziNMk
	$HUD.update_score(x)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func game_over():
	$MobTimer.stop()
	$HUD.show_game_over()
	
func new_game():
	score = 5
	$Player.update_animation(score)
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$HUD.update_score(score)

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	var boost = boost_scene.instantiate()
	
	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	var boost_spawn_location = get_node("MobPath/MobSpawnLocation")
	boost_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var mob_direction = mob_spawn_location.rotation + PI / 2
	var boost_direction = boost_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position
	boost.position = boost_spawn_location.position
	
	# Add some randomness to the direction.
	var test_val = 8
	mob_direction += randf_range(-PI / test_val, PI / test_val)
	mob.rotation = mob_direction
	boost_direction += randf_range(-PI / test_val, PI / test_val)
	boost.rotation = boost_direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(mob_direction)
	boost.linear_velocity = velocity.rotated(boost_direction)
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	add_child(boost)



func _on_start_timer_timeout():
	$MobTimer.start()
