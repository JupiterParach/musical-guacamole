extends Spatial
# TODO: Change this in the future to path to a player setting
var player = preload("res://Assets/Entities/Player/player_cube_1/player_cube.glb")
# TODO: Chane in the future so enemy model is queried from an enemy list instead of having scene specific enemies
var enemy = preload("res://Assets/Entities/Enemies/Enemy 1 - Ico/enemy_icosphere.glb")

var needle = preload("res://Assets/Indicators/rythm_needle/rythm_needle.tscn")

var activeKeys = 0 # key manager edits this value to the correct one

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("main_stage/basic_1_player_spawnpoint").add_child(player.instance())
	get_node("main_stage/basic_1_enemy_spawnpoint").add_child(enemy.instance())
	
	get_node("key_manager").get_child(randi() % activeKeys).get_child(1).get_child(0).get_child(0).play("beat")

func key_pressed(key, prevAnim):
	if(prevAnim.get_current_animation_position() == prevAnim.get_current_animation_length()):
		var randomInt = randi() % activeKeys
		
		while randomInt == int(key):
			randomInt = randi() % activeKeys
		
		get_node("key_manager").get_child(randomInt).get_child(1).get_child(0).get_child(0).play("beat")

func _process(delta):
	if get_node("UI/ProgressBar").value >= get_node("UI/ProgressBar").max_value:
		get_node("UI/ProgressBar").value = 0
	
	get_node("UI/ProgressBar").value += delta*10
