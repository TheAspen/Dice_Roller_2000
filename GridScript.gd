extends GridContainer


var animationTimer = null
var generator = RandomNumberGenerator.new()

func _ready():
	# Initialize generator
	generator.randomize()
	
	# Create and initialize timer
	animationTimer = Timer.new()
	animationTimer.wait_time = 1
	add_child(animationTimer)
	pass 

# Set color to the result
func _setColorToResult(node: Label, i: int, failureValues: PoolIntArray, successValues: PoolIntArray, results: PoolIntArray):
	if(node.has_color_override("font_color")):
		node.add_color_override("font_color", Color(1,1,1))
	if(failureValues.has(results[i])):
		node.add_color_override("font_color", Color(1,0,0))
		return
	if(successValues.has(results[i])):
		node.add_color_override("font_color", Color(0,1,0))
		return

# Create a random number during "animation"
func randomizer(maxNumber: int):
	return generator.randi_range(1, maxNumber)
	pass

func doAnimation(maxNumber: int):
	
	pass

# Core function, called from MainScript
func temp(results: PoolIntArray, failureValues: PoolIntArray, successValues: PoolIntArray): 
	for i in range(results.size()):
		var node = Label.new()
		if(i == 0):
			var defaultText = get_child(0)
			defaultText.replace_by(node)
			defaultText.queue_free()
			node.text = var2str(results[i])
			_setColorToResult(node, i, failureValues, successValues, results)
			continue
		node.text = var2str(results[i]) # <----
		_setColorToResult(node, i, failureValues, successValues, results)
		add_child(node)
		
