extends MarginContainer
var results = []
var total = 0
var roller = RandomNumberGenerator.new()
var allowRoll = true
var failureValues = []
var successValues = []
var totalFailures = 0
var totalSuccess = 0

func _ready():
	total = 0
	roller.randomize()
	pass # Replace with function body.

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
	get_node("CenterContainer/HBoxContainer/Results/Result").text = "..."
	get_node("CenterContainer/HBoxContainer/RolledDicesArray/RollsTable").text = "Rolling..."
	get_node("CenterContainer/HBoxContainer/OptionalSettings/OptionalResultHBox/FailureVBox/FailureResultValue").text = "..."
	get_node("CenterContainer/HBoxContainer/OptionalSettings/OptionalResultHBox/SuccessVBox/SuccessResultValue").text = "..."
	totalFailures = 0
	totalSuccess = 0
	allowRoll = false
	

func _on_Roll_pressed():
	if(allowRoll == false):
		return
	_clearAll()
	yield(get_tree().create_timer(0.5), "timeout")
	var dice = int(get_node("CenterContainer/HBoxContainer/Options/DiceSettings/Dice").value)
	var amount = int(get_node("CenterContainer/HBoxContainer/Options/AmountSettings/Amount").value)
	
	var result = _rolldice(dice, amount)
	
	get_node("CenterContainer/HBoxContainer/Results/Result").text = var2str(result)
	
	for i in range(results.size()):
		if(i == 0):
			get_node("CenterContainer/HBoxContainer/RolledDicesArray/RollsTable").text = var2str(results[i])
			continue
		get_node("CenterContainer/HBoxContainer/RolledDicesArray/RollsTable").text = get_node("CenterContainer/HBoxContainer/RolledDicesArray/RollsTable").text + ", " + var2str(results[i])
	
	_checkFailures()
	_checkSuccess()
	get_node("CenterContainer/HBoxContainer/OptionalSettings/OptionalResultHBox/FailureVBox/FailureResultValue").text = var2str(totalFailures)
	get_node("CenterContainer/HBoxContainer/OptionalSettings/OptionalResultHBox/SuccessVBox/SuccessResultValue").text = var2str(totalSuccess)
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
	 get_node("CenterContainer/HBoxContainer/OptionalSettings/OptionalResultHBox/FailureVBox/FailureResultValue").text = "..."
	 get_node("CenterContainer/HBoxContainer/OptionalSettings/OptionalResultHBox/SuccessVBox/SuccessResultValue").text = "..."
	 get_node("CenterContainer/HBoxContainer/OptionalSettings/FailureSettings/HBoxContainer/FailureValuesArray").text = "..."
	 get_node("CenterContainer/HBoxContainer/OptionalSettings/SuccessSettings/HBoxContainer2/SuccessValuesArray").text = "..."
	
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
	pass # Replace with function body.


func _on_AddButtonFailure_pressed():
	var value = get_node("CenterContainer/HBoxContainer/OptionalSettings/FailureSettings/HBoxContainer/FailureValue").value
	_addFailureValue(int(value))
	pass # Replace with function body.


func _on_DecreaseButtonSuccess_pressed():
	_removeSuccessValue()
	_updateSuccessValues()
	pass # Replace with function body.


func _on_AddButtonSuccess_pressed():
	var value = get_node("CenterContainer/HBoxContainer/OptionalSettings/SuccessSettings/HBoxContainer2/SuccessValue").value
	_addSuccessValue(int(value))
	pass # Replace with function body.


func _on_ClearOptionalValues_pressed():
	_clearOptionalSettings()
	pass # Replace with function body.


func _updateFailureValues():
	if(failureValues.size() == 0):
		get_node("CenterContainer/HBoxContainer/OptionalSettings/FailureSettings/HBoxContainer/FailureValuesArray").text = "..."
		return
	for i in range(failureValues.size()):
		if(i == 0):
			get_node("CenterContainer/HBoxContainer/OptionalSettings/FailureSettings/HBoxContainer/FailureValuesArray").text = var2str(failureValues[i])
			continue
		get_node("CenterContainer/HBoxContainer/OptionalSettings/FailureSettings/HBoxContainer/FailureValuesArray").text = get_node("CenterContainer/HBoxContainer/OptionalSettings/FailureSettings/HBoxContainer/FailureValuesArray").text + ", " + var2str(failureValues[i])

func _updateSuccessValues():
	if(successValues.size() == 0):
		get_node("CenterContainer/HBoxContainer/OptionalSettings/SuccessSettings/HBoxContainer2/SuccessValuesArray").text = "..."
		return
	for i in range(successValues.size()):
		if(i == 0):
			get_node("CenterContainer/HBoxContainer/OptionalSettings/SuccessSettings/HBoxContainer2/SuccessValuesArray").text = var2str(successValues[i])
			continue
		get_node("CenterContainer/HBoxContainer/OptionalSettings/SuccessSettings/HBoxContainer2/SuccessValuesArray").text = get_node("CenterContainer/HBoxContainer/OptionalSettings/SuccessSettings/HBoxContainer2/SuccessValuesArray").text + ", " + var2str(successValues[i])
