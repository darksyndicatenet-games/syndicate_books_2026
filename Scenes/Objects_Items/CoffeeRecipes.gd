extends Node

var recipes = {
	"espresso": ["beans", "water"],
	"latte": ["beans", "water", "milk","milk"],
	"americano": ["beans", "water", "water"],
	"flat_white": ["beans", "water", "milk", "milk"],
}

func _ready():
	self.set_meta("display_name", "Coffee Machine")

func check_recipe(ingredients: Array) -> String:
	var sorted_input = ingredients.duplicate()
	sorted_input.sort()

	for coffee in recipes.keys():
		var recipe_sorted = recipes[coffee].duplicate()
		recipe_sorted.sort()

		if sorted_input == recipe_sorted:
			return coffee

	return ""
