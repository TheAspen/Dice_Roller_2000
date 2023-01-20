extends MarginContainer
var results = []
var total = 0
var roller = RandomNumberGenerator.new()
var allowRoll = true
var failureValues = []
var successValues = []
var totalFailures = 0
var totalSuccess = 0
var settingsOpened = false

onready var resultGrid = $App/VBoxContainer/RolledDicesArray/ScrollContainer/GridContainer
onready var resultLabel = $App/VBoxContainer/HBoxContainer/VBoxContainer/CenterContainer/Container/Results/Result
onready var rollsTable = $App/VBoxContainer/RolledDicesArray/RollsTable
onready var failureResultValue = $App/OptionalSettingsMain/OptionalSettings/OptionalResultHBox/FailureVBox/FailureResultValue
onready var successResultValue = $App/OptionalSettingsMain/OptionalSettings/OptionalResultHBox/SuccessVBox/SuccessResultValue
onready var diceSpinBox = $App/VBoxContainer/HBoxContainer/VBoxContainer/CenterContainer/Container/HBoxContainer/Options/DiceSettings/Dice
onready var amountSpinBox =  $App/VBoxContainer/HBoxContainer/VBoxContainer/CenterContainer/Container/HBoxContainer/Options/AmountSettings/Amount
onready var failureValuesArray = $App/OptionalSettingsMain/OptionalSettings/FailureSettings/HBoxContainer2/FailureValuesArray
onready var successValuesArray = $App/OptionalSettingsMain/OptionalSettings/SuccessSettings/HBoxContainer/SuccessValuesArray



func _ready():
	total = 0
	roller.randomize()
	pass 

func _rolldice(dice, amount):
		if(typeof(dice) != TYPE_INT || dice == null):
			return "error"
		roller.randomize()
		for _i in range(amount):
			roller.randomize()
			results.push_back(roller.randi_range(1, dice))
		for i in range(results.size()):
			total = total + results[i]
		return total

func _clearAll():
	total = 0
	results.clear()
	for i in resultGrid.get_children():
		resultGrid.remove_child(i)
		i.queue_free()
	resultLabel.text = "..."
	rollsTable.text = "Rolling..."
	failureResultValue.text = "..."
	successResultValue.text = "..."
	totalFailures = 0
	totalSuccess = 0
	allowRoll = false
	

func _on_Roll_pressed():
	if(allowRoll == false):
		return
	_clearAll()
	yield(get_tree().create_timer(0.5), "timeout")
	var dice = int(diceSpinBox.value)
	var amount = int(amountSpinBox.value)
	
	var result = _rolldice(dice, amount)
	
	rollsTable.text = ""
	resultLabel.text = var2str(result)
	rollsTable.hide()
	for i in range(results.size()):
		var node = Label.new()
		# Old implementation for result table
		# if(i == 0):
		# 	$RolledDicesArray/RollsTable.text = var2str(results[i])
		# 	continue
		# $RolledDicesArray/RollsTable.text = $RolledDicesArray/RollsTable.text + ", " + var2str(results[i])
		node.text = var2str(results[i])
		resultGrid.add_child(node)
	
	_checkFailures()
	_checkSuccess()
	failureResultValue.text = var2str(totalFailures)
	successResultValue.text = var2str(totalSuccess)
	allowRoll = true
	pass


func _addFailureValue(value):
	for i in range(failureValues.size()):
		if(failureValues[i] == value):
			return
	failureValues.push_back(value)
	_updateFailureValues()
	pass
	
func _addSuccessValue(value):
	for i in range(successValues.size()):
		if(successValues[i] == value):
			return
	successValues.push_back(value)
	_updateSuccessValues()
	pass
	
func _removeFailureValue():
	if(failureValues.size() <= 0):
		return
	failureValues.pop_back()
	pass
	
func _removeSuccessValue():
	if(successValues.size() <= 0):
		return
	successValues.pop_back()
	pass

func _clearOptionalSettings():
	 failureValues = []
	 successValues = []
	 totalFailures = 0
	 totalSuccess = 0
	 failureResultValue.text = "..."
	 successResultValue.text = "..."
	 failureValuesArray.text = "..."
	 successValuesArray.text = "..."
	
func _checkFailures():
	
	for i in range(results.size()):
		for j in range(failureValues.size()):
			if(results[i] == failureValues[j]):
				totalFailures = totalFailures + 1
	pass

func _checkSuccess():
	for i in range(results.size()):
		for j in range(successValues.size()):
			if(results[i] == successValues[j]):
				totalSuccess = totalSuccess + 1
	pass


func _on_DecreaseButtonFailure_pressed():
	_removeFailureValue()
	_updateFailureValues()
	pass 

func _on_AddButtonFailure_pressed():
	var value = $App/OptionalSettingsMain/OptionalSettings/FailureSettings/HBoxContainer/FailureValue.value
	_addFailureValue(int(value))
	pass 


func _on_DecreaseButtonSuccess_pressed():
	_removeSuccessValue()
	_updateSuccessValues()
	pass 


func _on_AddButtonSuccess_pressed():
	var value = $App/OptionalSettingsMain/OptionalSettings/SuccessSettings/HBoxContainer2/SuccessValue.value
	_addSuccessValue(int(value))
	pass 


func _on_ClearOptionalValues_pressed():
	_clearOptionalSettings()
	pass 


func _updateFailureValues():
	if(failureValues.size() == 0):
		failureValuesArray.text = "..."
		return
	for i in range(failureValues.size()):
		if(i == 0):
			failureValuesArray.text = var2str(failureValues[i])
			continue
		failureValuesArray.text = failureValuesArray.text + ", " + var2str(failureValues[i])

func _updateSuccessValues():
	if(successValues.size() == 0):
		successValuesArray.text = "..."
		return
	for i in range(successValues.size()):
		if(i == 0):
			successValuesArray.text = var2str(successValues[i])
			continue
		successValuesArray.text = successValuesArray.text + ", " + var2str(successValues[i])

# Button function for advanced settings
func _on_OpenSettings_pressed():
	if(settingsOpened == true):
		settingsOpened = false
		$App/OptionalSettingsMain/OptionalSettings.hide()
		$App/OptionalSettingsMain/HBoxContainer/OpenSettings.text = "Open"
		return
	settingsOpened = true
	$App/OptionalSettingsMain/OptionalSettings.show()
	$App/OptionalSettingsMain/HBoxContainer/OpenSettings.text = "Close"
	pass 
