extends KinematicBody2D

const speed = 200

var velocity = Vector2()
#var shuriken = shuriken.instance();

func _ready():
    set_fixed_process(true)

func _fixed_process(delta):
    velocity = Vector2(0,0)

    var upButton = Input.is_action_pressed("ui_up")
    var downButton = Input.is_action_pressed("ui_down")
    var rightButton = Input.is_action_pressed("ui_right")
    var leftButton = Input.is_action_pressed("ui_left")

    if(leftButton):
        velocity.x = -1
    elif(rightButton):
        velocity.x = 1
    if(upButton):
        velocity.y = -1
    elif(downButton):
        velocity.y = 1

    var motion = velocity.normalized() * speed * delta
    move(motion)
    if (is_colliding()):
        var n = get_collision_normal()
        motion = n.slide(motion)
        velocity = n.slide(velocity)
        move(motion)