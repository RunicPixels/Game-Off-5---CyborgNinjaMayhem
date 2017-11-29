extends Node2D

#motion
var timeScale = 1
var freezeFrames = 0

#monsters
var monstersToSpawn = 0
var monsters = 0
const defaultMonsters = 5
const baseLevelMonsters = 5
const monsterPerLevelMultiplyer = 0.1

#spawning
const maxMonstersBase = 8
var maxMonsters = maxMonstersBase
const monstersPerSecondBase = 1
var monstersPerSecond = monstersPerSecondBase

var spawnPoints
var spawnChancePerFrame

#monsters
var spider = preload("res://objects/spider.xml");

#level
var level = 0
const levelCountDown = 5
var startLevel = false
var levelTimer = levelCountDown

#viewport
onready var root = get_tree().get_root()
onready var base_size = root.get_rect().size

#UI
var levelLabel
var monsterLabel

func _ready():
	get_tree().connect("screen_resized", self, "_on_screen_resized")
	set_fixed_process(true)
	set_process_input(true)
	root.set_as_render_target(true)
	root.set_render_target_update_mode(root.RENDER_TARGET_UPDATE_ALWAYS)
	root.set_render_target_to_screen_rect(root.get_rect())
	_on_screen_resized()

	#spawning
	spawnPoints = [] + get_node("SpawnPoints").get_children()
	
	#UI
	levelLabel = get_node("UI/LevelLabel")
	monsterLabel= get_node("UI/MonstersLabel")


func _on_screen_resized():
    var new_window_size = OS.get_window_size()

    var scale_w = max(int(new_window_size.x / base_size.x), 1)
    var scale_h = max(int(new_window_size.y / base_size.y), 1)
    var scale = min(scale_w, scale_h)

    #This offset is needed to keep pixels square
    var offset = ((new_window_size / scale) - (new_window_size / scale).floor()) * scale
    var offsethalf = (offset * 0.5).floor()

    root.set_rect(Rect2(offsethalf, new_window_size / scale))
    root.set_render_target_to_screen_rect(Rect2(offsethalf, new_window_size - offset))

func _input(event):
    if(event.is_action_pressed("ui_fullscreen")):
        if(OS.is_window_fullscreen()):
            OS.set_window_fullscreen(false)
        else:
            OS.set_window_fullscreen(true)

func _fixed_process(delta):
	#FREEZEFRAMES
	if(freezeFrames > 0):
		timeScale = 0
		freezeFrames -= 1 * delta
	else:
		timeScale = 1
	
	if(timeScale < 1 && timeScale != 0):
		timeScale += delta * 0.5
	elif(timeScale == 0):
		timeScale = 0.1
	elif(timeScale > 1):
		timeScale = 1;

	delta *= timeScale
	
	
	#SPAWNING
	monsters = int(monsters)
	monstersToSpawn = int(monstersToSpawn)
	spawnChancePerFrame = delta * monstersPerSecond
	var index = randi()%spawnPoints.size()
	if(rand_range(0,1) < spawnChancePerFrame && monstersToSpawn >= 1 && monsters <= maxMonsters):
		monstersToSpawn -= 1
		monsters += 1
		var spider_instance = spider.instance()
		add_child(spider_instance)
		spider_instance.set_name("Spider"+str(monstersToSpawn)+"l"+str(level))
		#use below variable for individual node access.
		var spider_instance_node = get_node("Spider"+str(monstersToSpawn)+"l"+str(level))
		#shuriken_instance_node.add_collision_exception_with(self)
		spider_instance_node.spawnPoint = spawnPoints[index].get_pos()
		spider_instance_node._spawn()
		
	#SWITCHING LEVELS
	if(startLevel == true):
		monsterLabel.set_text("New level in : " + str(int(levelTimer)))
		levelTimer -= delta
		if(levelTimer <= 0):
			level = level+1
			maxMonsters = maxMonstersBase + level
			monstersPerSecond = (monstersPerSecondBase + level * 0.1)
			startLevel = false
			monstersToSpawn = ((level * baseLevelMonsters) + defaultMonsters) * (1+(monsterPerLevelMultiplyer * level))
	else:
		monsterLabel.set_text("Monsters left : " + str(int(monsters+monstersToSpawn)))
	if(monsters == 0 && monstersToSpawn == 0 && startLevel == false):
		startLevel = true
		levelTimer = levelCountDown
		pass
	#DRAWING ON SCREEN
	levelLabel.set_text("Level : " + str(level))

        
            