extends Label

var maxValue = 0
var realValue = 0
var timer = 0
var zero = 0
var valueSet = true
var generator = RandomNumberGenerator.new()
var index = 0
var failures = []
var successes = []
var allResults = []
var animTimer = null



# Set color to the result
func _setColorToResult():
	if(has_theme_color_override("font_color")):
		add_theme_color_override("font_color", Color(1,1,1))
	if(failures.has(realValue)):
		add_theme_color_override("font_color", Color(1,0,0))
		return
	if(successes.has(realValue)):
		add_theme_color_override("font_color", Color(0,1,0))
		return


func _ready():
	self.hide()
	# Set min size to 20, prevent "shaking" effect.
	self.custom_minimum_size = Vector2(20,0)
	# Randomize
	generator.randomize()
	animTimer = Timer.new()
	animTimer.wait_time = 0.07
	animTimer.one_shot = true
	add_child(animTimer)

func _starTimer():
	if(animTimer.is_stopped()):
		animTimer.start()
		_setNewRandomValue()

func _setNewRandomValue():
	text = var_to_str(generator.randi_range(0, maxValue))

# Call this from Grid
# Initialize label
func _initLabel(pMaxValue: int, pRealValue: int, pTimer: int, pIndex: int, pFailures, pSuccesses, pAllResults):
	maxValue = pMaxValue
	realValue = pRealValue
	timer = pTimer
	index = pIndex
	failures = pFailures
	successes = pSuccesses
	allResults = pAllResults

# Set true values
func _setValues():
	text = var_to_str(realValue)
	# Set min size to 10
	if(allResults.size() > 1):
		self.custom_minimum_size = Vector2(10,0)
	# Value is set, do not show "animations" anymore.
	valueSet = true
	zero = 0
	# Set color
	_setColorToResult()
	# Launch the second label
	# _showLabel handles situation when index goes over child count
	get_parent()._showLabel(index + 1)

# Do the "animation"
func _process(delta):
	if(valueSet):
		return
	if(animTimer.is_stopped()):
		_starTimer()
	if(zero < timer):
		zero = zero + 1 * delta
		return
	_setValues()
	pass

# Start label animation or show label
func _start(doAnimation: bool):
	self.show()
	if(doAnimation):
		valueSet = false
	else:
		_setValues()
