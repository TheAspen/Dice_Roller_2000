extends Label

var maxValue = 0
var realValue = 0
var timer = 0
var zero = 0
var generator = RandomNumberGenerator.new()
var index = 0
var animTimer = null
var trueColor = null
var resultSize = 0


func _ready():
	# Set min size to 20, prevent "shaking" effect.
	self.rect_min_size = Vector2(20,0)
	self.set_process(false)

func _starTimer():
	if(animTimer.is_stopped()):
		animTimer.start()
		_setNewRandomValue()

func _setNewRandomValue():
	text = var2str(generator.randi_range(0, maxValue))

# Init when animations are set to false
func _initInstantLabel(pRealValue: int, pColor):
	text = var2str(pRealValue)
	if(pColor):
		add_color_override("font_color", pColor)

# Call this from Grid
# Initialize label
# Use with animations only
func _initLabel(pMaxValue: int, pRealValue: int, pTimer: int, pIndex: int, pResultSize: int, pColor) :
	# Set values
	maxValue = pMaxValue
	realValue = pRealValue
	timer = pTimer
	index = pIndex
	resultSize = pResultSize
	# trueColor can be NULL!
	trueColor = pColor

	# Randomize
	generator.randomize()
	# Initialize animation timer
	animTimer = Timer.new()
	animTimer.wait_time = 0.07
	animTimer.one_shot = true
	add_child(animTimer)
	# Hide self
	self.hide()


# Set true values
func _setValues():
	text = var2str(realValue)
	# Set min size to 10
	self.rect_min_size = Vector2(10,0)
	# Value is set, do not show "animations" anymore.
	zero = 0
	# If color is not null, set it
	if(trueColor):
		add_color_override("font_color", trueColor)
	# Launch the second label
	# _showLabel handles situation when index goes over child count
	get_parent()._showLabel(index + 1)
	if(self.is_processing()):
		self.set_process(false)

# Do the "animation"
func _process(delta):
	if(animTimer.is_stopped()):
		_starTimer()
	if(zero < timer):
		zero = zero + 1 * delta
		return
	_setValues()
	pass

# Start label animation or show label
func _start():
	self.show()
	self.set_process(true)
