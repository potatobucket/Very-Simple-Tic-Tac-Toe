extends Node2D

var xIterations = 0
var yIterations = 0

var numberOfCells = 9
var cellScene = load("res://board_cell.tscn")
var cellSize = 256
var cells = []

var player = 0

func _ready():
	var textureRect = TextureRect.new()
	add_child(textureRect)
	textureRect.set_texture(load("res://Untitled.png"))
	textureRect.set_size(Vector2(800, 800))
	for cell in numberOfCells:
		var cellInstance = cellScene.instantiate()
		add_child(cellInstance)
		cellInstance.selfIndex = cell
		cellInstance.cellClicked.connect(_on_cell_clicked.bind())
		cellInstance.set_position(Vector2((cellSize * xIterations) + 20, (cellSize * yIterations) + 20))
		if xIterations == 2:
			yIterations += 1
		xIterations = (xIterations + 1) % 3
	for child in get_children():
		cells.append(child)
	cells.pop_front()

func check_for_winning_row():
	var rows = [[cells[0], cells[1], cells[2]],
				[cells[3], cells[4], cells[5]],
				[cells[6], cells[7], cells[8]]]
	for row in rows:
		if row[0].value != null or row[1].value != null or row[2].value != null:
			if row[0].value == row[1].value && row[0].value == row[2].value:
				row[0].background.set_modulate(Color(0, 155, 0))
				row[1].background.set_modulate(Color(0, 155, 0))
				row[2].background.set_modulate(Color(0, 155, 0))
				return true

func check_for_winning_column():
	var columns = [[cells[0], cells[3], cells[6]],
				[cells[1], cells[4], cells[7]],
				[cells[2], cells[5], cells[8]]]
	for column in columns:
		if column[0].value != null or column[1].value != null or column[2].value != null:
			if column[0].value == column[1].value && column[0].value == column[2].value:
				column[0].background.set_modulate(Color(0, 155, 0))
				column[1].background.set_modulate(Color(0, 155, 0))
				column[2].background.set_modulate(Color(0, 155, 0))
				return true

func check_for_winning_diagonal():
	var diagonals = [[cells[0], cells[4], cells[8]],
					[cells[2], cells[4], cells[6]]]
	for diagonal in diagonals:
		if diagonal[0].value != null or diagonal[1].value != null or diagonal[2].value != null:
			if diagonal[0].value == diagonal[1].value && diagonal[0].value == diagonal[2].value:
				diagonal[0].background.set_modulate(Color(0, 155, 0))
				diagonal[1].background.set_modulate(Color(0, 155, 0))
				diagonal[2].background.set_modulate(Color(0, 155, 0))
				return true

func check_for_stalemate():
	var fullCells = 0
	for cell in cells:
		if cell.isEmpty == false:
			fullCells += 1
	if fullCells >= 9:
		for cell in cells:
			cell.background.set_modulate(Color(155, 0, 0))
		return true

func is_game_over():
	if check_for_winning_row():
		print("You won the game!")
		reset_game()
	elif check_for_winning_column():
		print("You won the game!")
		reset_game()
	elif check_for_winning_diagonal():
		print("You won the game!")
		reset_game()
	elif check_for_stalemate():
		print("You tied the game!")
		reset_game()

func _on_cell_clicked(selfIndex):
	if cells[selfIndex].isEmpty == true:
		cells[selfIndex].sprite.set_frame(player)
		cells[selfIndex].sprite.show()
		cells[selfIndex].isEmpty = false
		if player == 0:
			cells[selfIndex].value = "x"
		elif player == 1:
			cells[selfIndex].value = "o"
		is_game_over()
		player = (player + 1) % 2
	else:
		print("That's already taken, man!")

func reset_game():
	await get_tree().create_timer(2.5).timeout
	cells.clear()
	for child in get_children():
		child.free()
	xIterations = 0
	yIterations = 0
	_ready()
