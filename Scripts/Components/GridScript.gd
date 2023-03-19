extends GridContainer

var labelScript = preload("res://Scripts/Components/LabelScript.gd")
var animations = false

# Set color to the result
func _setColorToResult(node: Label, i: int, failureValues: PoolIntArray, successValues: PoolIntArray, results: PoolIntArray):
	if(node.has_color_override("font_color")):
		node.remove_color_override("font_color")
	if(failureValues.has(results[i])):
		node.add_color_override("font_color", Color(1,0,0))
		return
	if(successValues.has(results[i])):
		node.add_color_override("font_color", Color(0,1,0))
		return

# Core function, called from MainScript
func _createLabels(maxValue: int, waitTime: float, results: PoolIntArray, failureValues: PoolIntArray, successValues: PoolIntArray, showAnimations: bool): 
	animations = showAnimations
	for i in range(results.size()):
		var node = Label.new()
		node.set_script(labelScript)
		node._initLabel(maxValue,results[i], waitTime, i, failureValues, successValues, results)
		add_child(node)
	# Start showing labels
	_showLabel(0)
pass

func _showLabel(index: int):
	# Index is 0 when child_cout is 1 (Indexing starts from 0)
	# Thats why we need to check index is smaller than get_child_count
	if(index < get_child_count() && get_child(index)):
		get_child(index)._start(animations)
	else:
		# The last label is shown, show the total values from the main script
		get_tree().get_root().get_node("Main")._showResultLabels()
	pass
