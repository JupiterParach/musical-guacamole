tool
extends Spatial

onready var Basic_block = preload("res://Assets/Beat Block Types/Basic Beat Block/basic_beat_block.tscn")
onready var Blocker_block = preload("res://Assets/Beat Block Types/Beat Block Blocker/beat_block_blocker.tscn")

# var capacity is used in _ready() and _input()
var capacity = 20 # the mesh made to hold the blocks has been measured to fit exactly 20 blocks

var inputMap = {} # inputMap maps all assigned actions
var blocks = 0 # blocks will be assigned length of inputMap - 1 to match number of active blocks to assigned actions

# if "tool" at line 1 is not commented it means this script runs in the editor
func _ready():
	var block_width = 0.5 # exact width of blocks in meters used to determine offset
	var block_offset = 0
	
	# maps all assigned "player_block_control"s to inputMap
	for action in InputMap.get_actions():
		if action.substr(0, len(action) - 1) == "player_block_control_":
			inputMap[action] = int(action.substr(len(action) - 1))
	
	blocks = len(inputMap)
	
	var n = 0 # variable n keeps track of the index for the current block. Also the while loop fills in the container from left to right
	var holder = null
	while n < blocks:
		add_child(Basic_block.instance())
		get_child(n).translate(Vector3(block_offset,0,0))
		n += 1
		block_offset = n * block_width
	
	# if there are empty slots left in the container they will be filled by inactive blockers by default
	if(blocks < capacity):
		while n < capacity:
			add_child(Blocker_block.instance())
			get_child(n).translate(Vector3(block_offset,0,0))
			n += 1
			block_offset = n * block_width

func _input(event: InputEvent) -> void:
	# the "not" operator converts the "event is InputEventMouseMotion" condition to oposite bool value
	if not event is InputEventMouseMotion:
		# the loop runs through all blocks to check if one is activated
		for action in inputMap:
			if Input.is_action_pressed(action):
				print(get_child(inputMap[action]).get_child(0).get_child(0))
				if not get_child(inputMap[action]).get_child(0).get_child(0).is_playing():
					get_child(inputMap[action]).get_child(0).get_child(0).queue("block_up")
					get_child(inputMap[action]).get_child(0).get_child(0).queue("block_down")
		pass
