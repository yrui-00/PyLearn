class_name Quest extends QuestManager

#starting the quest
func start_quest() -> void:
	#make sure availbe yung quest
	if quest_status == QuestStatus.available:
		#update quest status
		quest_status = QuestStatus.started
		#update ui
		QuestBox.visible = true
		QuestTitle.text = quest_name
		QuestDescription.text = quest_description
		
#marking if the player reached the goal
func reached_goal() -> void:
	if quest_status == QuestStatus.started:
		#update quest status
		quest_status = QuestStatus.goal
		#update ui
		QuestDescription.text = goal
		
#finish the quest
func finish_quest() -> void:
	if quest_status == QuestStatus.goal:
		#update quest status 
		quest_status = QuestStatus.finished
		#update ui
		QuestBox.visible = false
		#player rewards
		GameQuestManager.gold += reward_amount
		GameQuestManager.xp += xp_amount
