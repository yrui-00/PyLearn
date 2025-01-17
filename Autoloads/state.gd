extends Node

var player_name = ""

signal editor_state_changed(is_editor_open: bool)

var is_editor_open: bool = false

func set_editor_state(state: bool):
	is_editor_open = state
	editor_state_changed.emit(is_editor_open)


#NPC STATES 
#tutorial stage
var ashanti: String = "false"
var cluey: String = "false"
var mentora: String = "false"
var guideon: String = "false"
var master: String = "false"

#if player failed the master quiz
var repeater: String = "false"
var repeat: String = "false"
var correct_answers: int = 0
var score: int = 0

#barrier values + assessment
var forestkey: String = "false"
var snowkey: String = "false"
var desertkey: String = "false"
var lastkey: String = "false"

var assessment1: String = "false"
var assessment2: String = "false"
var assessment3: String = "false"

var cedar: String = "false" #stage1last
var crystal: String = "false" #stage2last
var sultan: String = "false" #stage3last

#stage1
var game_master: String = "false"
var brambly: String = "false" #1
var oakly: String = "false" #2
var rustle: String = "false" #3
var berry: String = "false" #4
var sam: String = "false" #5
var thistle: String = "false" #6
var blossom: String = "false" #7
var twiggy: String = "false" #8
var fern: String = "false" #9
var shadewalker: String = "false"

#stage2
var blizz: String = "false" #1
var flurry: String = "false" #2
var chillington: String = "false" #3
var snowbert: String = "false" #4
var snowivy: String = "false" #5

#stage3
var scorchi: String = "false" #1
var pebble: String = "false" #2
var cactusjack: String = "false" #3
var dunehopper: String = "false" #4
var zahara: String = "false" #5

#last
var glimmer: String = "false"
var cairn: String = "false"
var eclipse: String = "false"
var duskveil: String = "false"
var holloway: String = "false"
var rune: String = "false"
var mystra: String = "false"
var willow: String = "false"















#make new ones and ignore this
#questions variables
var masterquest: String = "false"
#tutorial completion
var tutorialmaster: String = "false"
var tutorialcomplete: String = "true"
#tutorial stage npc variables
var master_npc: String = "false" #set to true if done
var tutorial_npc_1 = false
var tutorial_npc_2 = false
var tutorial_npc_3 = false
var tutorial_npc_4 = false
var master_npc_talk: String = "false" #if done
var tutorial_npc_1_talk = false
var tutorial_npc_2_talk = false
var tutorial_npc_3_talk = false
var tutorial_npc_4_talk = false
#questions
var tutorial_complete: String = "true"
var tutorial_master: String = "false"
var master_npc_q1: String = "false"
var master_npc_q2: String = "false"
var master_npc_q3: String = "false"
#tsage 1 
var stage_1_start: String = "false"
var level_1_npc_1: String = "false"
var level_1_npc_2: String = "false"
var level_1_npc_3: String = "false"
var level_1_npc_4: String = "false"
var level_1_npc_5: String = "false"
var level_1_npc_6: String = "false"
var level_1_npc_7: String = "false"
var level_1_npc_8: String = "false"
var level_1_npc_9: String = "false"
var level_1_npc_10: String = "false"
#stage_1 npcq variables
var npc_6_fail: String = "false"
var npc_6_mistake: String = "false"

