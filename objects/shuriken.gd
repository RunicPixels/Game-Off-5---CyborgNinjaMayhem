extends KinematicBody2D

var speed = 200
const lifeTime = 10

var timeLeft
var projVelocity = Vector2()

func _ready():
    timeLeft = lifeTime
    set_fixed_process(true)
    projVelocity = Vector2(0,0)

func _fixed_process(delta):
    timeLeft -= delta
    speed *= 0.995
    var motion = projVelocity * speed * delta
    move(motion)
    if (is_colliding()):
        var n = get_collision_normal()
        motion = n.slide(motion)
        projVelocity = n.reflect(projVelocity)
        move(motion)
    if(timeLeft+0.25 < lifeTime):
        remove_collision_exception_with(get_parent().get_node("Player"))
    if(timeLeft <= 0):
        queue_free()
        pass
    if(motion == Vector2(0,0)):
        timeLeft-= delta * 10

func _on_VisibilityNotifier2D_exit_screen():
	queue_free()
