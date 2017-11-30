extends KinematicBody2D

var speed = 200
const lifeTime = 5
var pierce = 2
var bounce = 5
var bounceCD = 0.1

onready var timeLeft
var projVelocity = Vector2()
onready var world = get_parent()
onready var animSprite = get_node("AnimatedSprite")
func _ready():
    timeLeft = lifeTime
    set_fixed_process(true)
    projVelocity = Vector2(0,0)

func _fixed_process(delta):
    delta = delta * world.timeScale;

    if(world.freezeFrames > 1):
        delta = 0;
        animSprite.stop()
    else:
        animSprite.play()
    speed *= 0.997
    if(bounceCD > 0):
        bounceCD-= delta
    var motion = projVelocity.normalized() * speed * delta
    move(motion)
    if (is_colliding()):
        var n = get_collision_normal()
        var colliderObject = get_collider()
        if(colliderObject.has_meta("type")):
             if(colliderObject.get_meta("type") == "enemy"):
             	world.get_node("Sound").play("hit", true)
             	colliderObject._die()
             	pierce -= 1
             	world.freezeFrames = 0.1
             	world.get_node("Camera2D").shake(0.5, 10, 1.5)
        elif(bounceCD < 0):
             bounce -= 1
             bounceCD = 0.1
             motion = n.reflect(motion)
             projVelocity = n.reflect(projVelocity)
        move(motion)

    if(timeLeft + 0.1< lifeTime):
        remove_collision_exception_with(world.get_node("Player"))
    if(timeLeft <= 0 || pierce == 0 || bounce == 0):
        queue_free()
        pass
    if(speed < 50):
        timeLeft -= delta * 10
    if(motion == Vector2(0,0)):
        set_pos(Vector2(round(get_pos().x),round(get_pos().y)))
    timeLeft -= delta

func _on_VisibilityNotifier2D_exit_screen():
	#queue_free()
	pass
