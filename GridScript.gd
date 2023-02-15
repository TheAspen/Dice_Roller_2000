extends GridContainer

var labelScript = preload("res://LabelScript.gd")

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

# Core function, called from MainScript
func _createLabels(results: PoolIntArray, failureValues: PoolIntArray, successValues: PoolIntArray): 
	for i in range(results.size()):
		var node = Label.new()
		node.set_script(labelScript)
		node._initLabel(10,results[i], 1, i)
		add_child(node)
	_showLabel(0)
pass

func _showLabel(index: int):
	if(get_child(index)):
		get_child(index)._start()
	pass