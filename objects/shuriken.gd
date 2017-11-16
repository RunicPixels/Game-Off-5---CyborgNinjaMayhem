extends KinematicBody2D

const speed = 200
var projVelocity = Vector2()

func _ready():
    set_fixed_process(true)
    projVelocity = Vector2(0,0)

func _fixed_process(delta):
    var motion = projVelocity.normalized() * speed * delta
    move(motion)
    if (is_colliding()):
        var n = get_collision_normal()
        motion = n.slide(motion)
        projVelocity = n.slide(projVelocity)
        move(motion)