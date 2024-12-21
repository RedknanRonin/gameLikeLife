extends Node2D

const GRID_SIZE = 80
const CELL_SIZE = 20
var is_running = true  # Tracks if the simulation is running
var grid = []

var player_pos = Vector2(1, 0)  # Start at the top-left corner

# Snake variables
var snake_segments = []  # Array of Vector2 positions
var snake_direction = Vector2(1, 0)  # Start moving right
var snake_length = 5  # Initial snake length
var snake_move_timer = 0.0
var snake_move_interval = 0.2  # How often the snake moves


func _ready():
	initialize_grid()
	initialize_snake()

func initialize_grid():
	grid = []
	for y in range(GRID_SIZE):
		var row = []
		for x in range(GRID_SIZE):
			if randi()% 5 == 1:
				row.append(randi() % 2) # Randomly set alive or dead
			else: row.append(0)
		grid.append(row)
		
func initialize_snake():
	snake_segments.clear()
	# Start snake in the middle of the grid
	var start_pos = Vector2(GRID_SIZE / 2, GRID_SIZE / 2)
	for i in range(snake_length):
		snake_segments.append(Vector2(start_pos.x - i, start_pos.y))
	

		
func _draw():
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			var color = Color(0.333,0.4,0.5) if grid[y][x] == 0 else Color(0, 0, 0)
			draw_rect(Rect2(x * CELL_SIZE, y * CELL_SIZE, CELL_SIZE, CELL_SIZE), color)
			
# Draw the player tile in a different color (e.g., red)
	draw_rect(Rect2(player_pos.x * CELL_SIZE, player_pos.y * CELL_SIZE, CELL_SIZE, CELL_SIZE), Color(1, 0, 0))		
	# Draw snake
	for i in range(snake_segments.size()):
		var segment = snake_segments[i]
		# Gradient from green to yellow for snake body
		var t = float(i) / snake_segments.size()
		var snake_color = Color(0.2 + t * 0.8, 0.8 - t * 0.3, 0.2)
		draw_rect(Rect2(segment.x * CELL_SIZE, segment.y * CELL_SIZE, CELL_SIZE, CELL_SIZE), snake_color)


func get_neighbors(x, y):
	var count = 0
	for dx in [-1,0,1] :
		for dy in [-1,0,1] :
			if dx == 0 and dy == 0:
				continue
			var nx = x + dx 
			var ny = y + dy
			if ny >= 0 and ny < GRID_SIZE and nx >= 0 and nx < GRID_SIZE:
				if grid[ny][nx]==1: count+=1

	return count

func step():
	
	var new_grid = []
	for y in range(GRID_SIZE):
		var row = []
		for x in range(GRID_SIZE):
			if player_pos == Vector2(x,y):
				row.append(1)    #player is a dead cell
			if is_snake_at_position(Vector2(x,y)):
				row.append(0)  # snake is alive for now
			else:
				var neighbors = get_neighbors(x, y)
				if grid[y][x] == 1:
					row.append(1 if neighbors == 2 or neighbors == 3 else 0)
				else:
					row.append(1 if neighbors == 3 else 0)
		new_grid.append(row)
	grid = new_grid
	
	queue_redraw()
func is_snake_at_position(pos):
	return snake_segments.has(pos)

func move_snake():
	var head = snake_segments[0]
	
	# Generate a random direction, but avoid reversing
	var possible_directions = [
		Vector2(1, 0),   # right
		Vector2(-1, 0),  # left
		Vector2(0, 1),   # down
		Vector2(0, -1)   # up
	]
	
	# Remove the opposite of current direction to prevent reversing
	possible_directions.erase(-snake_direction)
	
	# 70% chance to keep current direction, 30% chance to change
	if randf() > 0.6:
		snake_direction = possible_directions[randi() % possible_directions.size()]
	
	var new_head = head + snake_direction
	
	# Wrap around grid edges
	new_head.x = wrapi(new_head.x, 0, GRID_SIZE)
	new_head.y = wrapi(new_head.y, 0, GRID_SIZE)
	
	snake_segments.push_front(new_head)
	if snake_segments.size() > snake_length:
		snake_segments.pop_back()


var timer = 0.0
var step_interval = 0.1

func _process(delta):
	if is_running:
		timer += delta
		if timer >= step_interval:
			timer = 0.0
			step()
			
	snake_move_timer += delta
	if snake_move_timer >= snake_move_interval:
			snake_move_timer = 0.0
			move_snake()
			queue_redraw()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var x = int(event.position.x / CELL_SIZE)
		var y = int(event.position.y / CELL_SIZE)
	
		grid[y][x] = 1 - grid[y][x] # Toggle cell state
		queue_redraw()
		
		
	if Input.is_key_pressed(KEY_SPACE):
		step()
		
	if Input.is_key_pressed(KEY_R):
		initialize_grid()
		queue_redraw()
		
	 # Handle player movement with WASD
	
	if Input.is_key_pressed(KEY_W):
		player_pos.y = max(player_pos.y - 1, 0)  # Move up
	if Input.is_key_pressed(KEY_S):
		player_pos.y = min(player_pos.y + 1,  GRID_SIZE - 1)
	if Input.is_key_pressed(KEY_D):
		player_pos.x = min(player_pos.x + 1, GRID_SIZE - 1)
	if Input.is_key_pressed(KEY_A):
		player_pos.x = max(player_pos.x - 1, 0)
						
	

		
	if Input.is_key_pressed(KEY_ESCAPE): 
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")  
		
		
	
	

# Button signal handlers
func _on_StartButton_pressed():
	is_running = true  # Start the simulation

func _on_StopButton_pressed():
	is_running = false  # Stop the simulationeplace with function body.
	
	
