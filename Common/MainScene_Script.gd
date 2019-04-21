extends Control


var CurrentDie = null

func _ready():
	get_node("DiceMenu").popup()
	pass 

#Rolling button:
func _on_RollDice_Button_pressed():
	if(CurrentDie == null):
		print("No die seleceted!")
	Roll_Die()
	pass 

#Activated when die is selected from dice menu.
func _on_PopupMenu_id_pressed(ID):
	var DiceMenu = get_node("DiceMenu")
	
	#If clicked item is already checked, uncheck it:
	if(DiceMenu.is_item_checked(ID)):
		DiceMenu.set_item_checked(ID,false)
		return
	
	#Uncheck every other items, expect ID item:
	for i in range(DiceMenu.get_item_count()):
		if( i == ID):
			continue
		DiceMenu.set_item_checked(i,false)
	
	#Check item:
	DiceMenu.set_item_checked(ID,true)
	
	CurrentDie = DiceMenu.get_item_text(ID)
	
	pass 

func Roll_Die():
	var result = null
	match CurrentDie:
		"D4":
			result = rand_range(1,5)
			pass
		"D6":
			result = rand_range(1,7)
			pass
		"D8":
			result = rand_range(1,8)
			pass
	result = int(result)
	get_node("DiceRollResult").text = str(result)
	
	pass

func _on_ShowDice_pressed():
	get_node("DiceMenu").popup()
	pass # Replace with function body.
