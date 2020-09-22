extends Spatial

var inputMap = {} # inputMap maps all assigned actions
var keyAnimPlayers = {}
var needleAnimPlayers = {}

# if "tool" at line 1 is not commented it means this script runs in the editor
func _ready():
	# maps all assigned "player_block_control"s to inputMap
	var i = 0
	for action in InputMap.get_actions():
		if action.substr(0, len(action) - 1) == "player_key_control_":
			for key in InputMap.get_action_list(action):
				inputMap[OS.get_scancode_string(key.scancode)] = action
			get_child(i).translate(Vector3(0, 0.801, 0))
			keyAnimPlayers[action] = get_child(i).get_child(0)
			needleAnimPlayers[action] = get_child(i).get_child(1).get_child(0).get_child(0)
			needleAnimPlayers[action].set_assigned_animation("beat")
			i += 1
	get_parent().activeKeys = i

#Yay got it up from 4 to 6... somehow...

func _input(event):
	# the "not" operator returns true if the "event is InputEventMouseMotion" condition is false
	if not event is InputEventMouseMotion:
		if event is InputEventKey and inputMap.get(OS.get_scancode_string(event.scancode)):
			if Input.is_action_just_pressed(inputMap.get(OS.get_scancode_string(event.scancode))):
				keyAnimPlayers.get(inputMap.get(OS.get_scancode_string(event.scancode))).play("key_press")
				
				var needleAnim = needleAnimPlayers.get(inputMap.get(OS.get_scancode_string(event.scancode)))
				
				get_parent().key_pressed(inputMap.get(OS.get_scancode_string(event.scancode))[int(len(inputMap.get(OS.get_scancode_string(event.scancode))) - 1)], needleAnim)
				
				if(needleAnim.get_current_animation_position() == needleAnim.get_current_animation_length()):
					needleAnim.play_backwards("beat")
				
			if Input.is_action_just_released(inputMap.get(OS.get_scancode_string(event.scancode))):
				keyAnimPlayers.get(inputMap.get(OS.get_scancode_string(event.scancode))).play_backwards("key_press")
