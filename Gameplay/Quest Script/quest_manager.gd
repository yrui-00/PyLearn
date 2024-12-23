class_name QuestManager extends Node2D


@onready var QuestBox: CanvasLayer = GameQuestManager.get_node('QuestBox')
@onready var QuestTitle: RichTextLabel = GameQuestManager.get_node('QuestBox').get_node('QuestTitle')
@onready var QuestDescription: RichTextLabel = GameQuestManager.get_node('QuestBox').get_node('QuestDescription')

@export_group("Quest Settings") 
@export var quest_name: String #name of quest
@export var quest_description: String #ui quest description text
@export var goal: String #description after reaching goal
#pwede pa mag add ng iba dito banda depende sa pano yung execution ng quests

#all quest status
enum QuestStatus{
	available,
	started,
	goal,
	finished,
}

#quest status
@export var quest_status: QuestStatus = QuestStatus.available


@export_group("Reward_Settings")
@export var reward_amount: int #kung ilan or magkano yung reward 
@export var xp_amount: int #xp gained
