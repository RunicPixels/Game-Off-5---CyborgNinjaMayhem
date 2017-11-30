extends KinematicBody2D
var speed = 50
var alive = true
var fadeSpeed = 5
var spider = self
var spawnPoint = Vector2(0,0)
var deadTexture = preload("res://sprites/spiderdead.png")
var aliveTexture = preload("res://sprites/spider.png")

onready var world = get_parent()
onready var target = get_parent().get_node("Player")
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_meta("type", "enemy")    # set myNode type to "enemy"
	set_fixed_process(true)
	_spawn()
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _fixed_process(delta):
	target = get_parent().get_node("Player")
	if(world.level == 0):
		queue_free()
	delta = delta * world.timeScale;
	if(world.freezeFrames > 1):
        delta = 0;
	if(speed< 125):
		speed = 50 + world.level
	if(alive && target != null):
		var direction = (target.get_global_pos() - spider.get_global_pos()).normalized()
		set_rot(direction.angle_to_point(Vector2(0,0)));
		move(direction*speed*delta) 
		if (is_colliding()):
			var colliderObject = get_collider()
			if(colliderObject == target):
				world.freezeFrames = 1000
				colliderObject._die()
	else:
		get_node("Sprite").set_opacity(get_node("Sprite").get_opacity()-delta / fadeSpeed)
		if(get_node("Sprite").get_opacity() == 0):
			queue_free()
			pass
func _spawn():
	get_node("Sprite").set_opacity(1)
	get_node("CollisionShape2D").set_trigger(false)
	get_node("Sprite").set_texture(aliveTexture)
	set_pos(spawnPoint)
	alive = true

func _die():
	if(alive == true):
		alive = false
		get_parent().monsters -= 1
		get_node("CollisionShape2D").set_trigger(true)
		get_node("Sprite").set_texture(deadTexture)  