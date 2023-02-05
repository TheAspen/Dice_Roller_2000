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

# Create a random number during "animation"
func randomizer(maxNumber: int):
	return generator.randi_range(1, maxNumber)
	pass

func doAnimation(maxNumber: int):
	
	pass

func temp(results): 
	for i in range(results.size()):
		var node = Label.new()
		if(i == 0):
			var defaultText = get_child(0)
			defaultText.replace_by(node)
			defaultText.queue_free()
			node.text = var2str(results[i])
			#_setColorToResult(node,i)
			continue
		node.text = var2str(results[i]) # <----
		#_setColorToResult(node,i)
		add_child(node)
		
