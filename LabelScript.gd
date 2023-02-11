extends Label

var maxValue = 0
var realValue = 0
var timer = 0
var zero = 0
var valueSet = true
var generator = RandomNumberGenerator.new()
var index = 0

# Randomize
func _ready():
	self.hide()
	generator.randomize()

# Call this from Grid
# Initialize label
func _initLabel(pMaxValue: int, pRealValue: int, pTimer: int, pIndex: int):
	maxValue = pMaxValue
	realValue = pRealValue
	timer = pTimer
	index = pIndex

# Set true values
func _setValues():
	text = var2str(realValue)
	valueSet = true
	zero = 0
	get_parent()._showLabel(index + 1)

# Do the "animation"
func _process(delta):
	if(valueSet):
		return
	if(zero < timer):
		text = var2str(generator.randi_range(0, maxValue))
		zero = zero + 1 * delta
		return
	_setValues()
	pass


func _start():
	self.show()
	valueSet = false
