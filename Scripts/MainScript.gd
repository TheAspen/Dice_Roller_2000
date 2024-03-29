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
var sorter = null
var resultTotal = 0
var showAnimations = false

onready var resultGrid = $App/VBoxContainer/RolledDicesArray/ScrollContainer/GridContainer
onready var resultLabel = $App/VBoxContainer/HBoxContainer/VBoxContainer/CenterContainer/CenterMargin/CenterHBox/Container/Results/Result
onready var rollsTable = $App/VBoxContainer/RolledDicesArray/RollsTable
onready var failureResultValue = $App/OptionalSettingsMain/OptionalSettings/OptionalResultHBox/FailureVBox/FailureResultValue
onready var successResultValue = $App/OptionalSettingsMain/OptionalSettings/OptionalResultHBox/SuccessVBox/SuccessResultValue
onready var diceSpinBox = $App/VBoxContainer/HBoxContainer/VBoxContainer/CenterContainer/CenterMargin/CenterHBox/Container/HBoxContainer/Options/DiceSettings/Dice
onready var amountSpinBox =  $App/VBoxContainer/HBoxContainer/VBoxContainer/CenterContainer/CenterMargin/CenterHBox/Container/HBoxContainer/Options/AmountSettings/Amount
onready var failureValuesArray = $App/OptionalSettingsMain/OptionalSettings/FailureSettings/HBoxContainer2/FailureValuesArray
onready var successValuesArray = $App/OptionalSettingsMain/OptionalSettings/SuccessSettings/HBoxContainer/SuccessValuesArray
onready var sortButton = $App/VBoxContainer/RolledDicesArray/HBoxContainer/SortButton
onready var animTime = $App/VBoxContainer/RolledDicesArray/AnimationSettings/AnimTime
onready var themeSwitch = $App/ThemeSwitch
onready var diceList = $App/VBoxContainer/HBoxContainer/VBoxContainer/CenterContainer/CenterMargin/CenterHBox/QuickSelection/DiceList
onready var quickSelectionHeader = $App/VBoxContainer/HBoxContainer/VBoxContainer/CenterContainer/CenterMargin/CenterHBox/QuickSelection/Header
onready var decreaseButtonFailure = $App/OptionalSettingsMain/OptionalSettings/FailureSettings/HBoxContainer/DecreaseButtonFailure
onready var addButtonFailure = $App/OptionalSettingsMain/OptionalSettings/FailureSettings/HBoxContainer/AddButtonFailure
onready var decreaseButtonSuccess = $App/OptionalSettingsMain/OptionalSettings/SuccessSettings/HBoxContainer2/DecreaseButtonSuccess
onready var addButtonSuccess = $App/OptionalSettingsMain/OptionalSettings/SuccessSettings/HBoxContainer2/AddButtonSuccess


var mainTheme = preload("res://assets/themes/main_theme.tres")
var defaultTheme = preload("res://assets/themes/default_theme.tres")

class CustomSorter:
	static func customSorter(a, b):
			if(a > b):
				return false
			if(a < b ):
				return true
			return 0

func _ready():
	total = 0
	roller.randomize()
	var defaultGridText = Label.new()
	defaultGridText.text = "No rolled dice!"
	resultGrid.add_child(defaultGridText)
	sorter = CustomSorter.new()
	
	pass 

func _rolldice(dice, amount):
		if(typeof(dice) != TYPE_INT || dice == null):
			return "error"
		roller.randomize()
		for _i in range(amount):
			# Maybe a bit overkill?
			# roller.randomize()
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
	failureResultValue.text = "..."
	successResultValue.text = "..."
	totalFailures = 0
	totalSuccess = 0
	allowRoll = false
	sortButton.disabled = true
	sortButton.mouse_default_cursor_shape = Control.CURSOR_ARROW
	sortButton.focus_mode = Control.FOCUS_NONE
	resultTotal = 0
	
func _setRollingTextToGrid():
	var gridText = Label.new()
	gridText.text = "Rolling..."
	resultGrid.add_child(gridText)
	

func _hideResultLabels(): 
	failureResultValue.text = "???"
	successResultValue.text = "???"
	resultLabel.text = "???"

func _showResultLabels():
	failureResultValue.text = var2str(totalFailures)
	successResultValue.text = var2str(totalSuccess)
	resultLabel.text = var2str(resultTotal)
	# Enable sort button
	sortButton.disabled = false

func _on_Roll_pressed():
	if(allowRoll == false):
		return
	# Clear everything
	_clearAll()
	#_setRollingTextToGrid()
	# Wait a bit
	yield(get_tree().create_timer(0.5), "timeout")
	var dice = int(diceSpinBox.value)
	var amount = int(amountSpinBox.value)
	# Hide total labels
	_hideResultLabels()
	# Roll
	resultTotal = _rolldice(dice, amount)
	# Start createing result labels
	resultGrid._createLabels(dice, animTime.value, results, failureValues, successValues, showAnimations)
	# Check failure and success values (Only for total sums)
	_checkFailures()
	_checkSuccess()
	# If animations are set to false, show total results instantly
	if(!showAnimations):
		_showResultLabels()
	if(showAnimations):
		sortButton.disabled = true
	# Set some general values
	allowRoll = true
	sortButton.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	sortButton.focus_mode = Control.FOCUS_ALL
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

# Sort rolled values
func _on_SortButton_pressed():
	var children = resultGrid.get_children()
	results.sort_custom(sorter,"customSorter")
	for i in children.size():
		children[i].text = var2str(results[i])
		resultGrid._setColorToResult(children[i], i, failureValues, successValues, results)
	pass

# Enable rolling animations
func _on_AnimToggle_toggled(button_pressed):
	showAnimations = button_pressed
	pass

# Theme switch
func _on_ThemeSwitch_toggled(button_pressed):
	if(button_pressed):
		theme = mainTheme
		VisualServer.set_default_clear_color(Color.white)
	else:
		theme = defaultTheme
		VisualServer.set_default_clear_color("#4d4d4d")
	pass

# Open and close quick selection list
func _on_QuickSelectOpenButton_pressed():
	if(diceList.is_visible_in_tree()):
		diceList.hide()
		$App/VBoxContainer/HBoxContainer/VBoxContainer/CenterContainer/CenterMargin/CenterHBox/QuickSelection/Header/OpenButton.text = "Open"
	else:
		diceList.show()
		$App/VBoxContainer/HBoxContainer/VBoxContainer/CenterContainer/CenterMargin/CenterHBox/QuickSelection/Header/OpenButton.text = "Close"
	pass

# Quick selection list
func _on_DiceList_item_selected(index):
	var item: String = diceList.get_item_text(index)
	match(item):
		"D4":
			diceSpinBox.value = 4
		"D6":
			diceSpinBox.value = 6
		"D8":
			diceSpinBox.value = 8
		"D10":
			diceSpinBox.value = 10
		"D12":
			diceSpinBox.value = 12
		"D20":
			diceSpinBox.value = 20
	yield(get_tree().create_timer(0.1), "timeout")
	diceList.unselect(index)
	pass 
