extends Node

var labelScript = preload("res://Scripts/Components/LabelScript.gd")


# Get color to the result
func _getColorToResult(i: int,  failureValues: PoolIntArray, successValues: PoolIntArray, results: PoolIntArray):
	if(failureValues.has(results[i])):
		return Color(1,0,0)
	if(successValues.has(results[i])):
		return  Color(0,1,0)
	return null

# Core function, called from MainScript
func _createLabels(maxValue: int, waitTime: float, results: PoolIntArray, failureValues: PoolIntArray, successValues: PoolIntArray, showAnimations: bool ): 
	for i in range(results.size()):
		var node = Label.new()
		node.set_script(labelScript)
		node._initInstantLabel(results[i],_getColorToResult(i,failureValues,successValues,results))
		add_child(node)
pass
