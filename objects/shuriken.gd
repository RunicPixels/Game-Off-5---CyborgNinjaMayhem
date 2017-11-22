extends KinematicBody2D

var speed = 200
const lifeTime = 5
var pierce = 2
var bounce = 4

var timeLeft
var projVelocity = Vector2()

func _ready():
    timeLeft = lifeTime
    set_fixed_process(true)
    projVelocity = Vector2(0,0)

func _fixed_process(delta):
    timeLeft -= delta
    speed *= 0.9975
    var motion = projVelocity.normalized() * speed * delta
    move(motion)
    if (is_colliding()):
        var n = get_collision_normal()
        var colliderObject = get_collider()
        if(colliderObject.get_meta("type") == "enemy"):
             colliderObject._die()
             pierce -= 1
        else:
             bounce -= 1
             motion = n.reflect(motion)
             projVelocity = n.reflect(projVelocity)
        move(motion)
    if(timeLeft+0.25 < lifeTime):
        remove_collision_exception_with(get_parent().get_node("Player"))
    if(timeLeft <= 0 || pierce == 0 || bounce == 0):
        queue_free()
        pass
    if(speed < 5):
        timeLeft-= delta * 10
    if(motion == Vector2(0,0)):
	    set_pos(Vector2(round(get_pos().x),round(get_pos().y)))

func _on_VisibilityNotifier2D_exit_screen():
	#queue_free()
	pass
