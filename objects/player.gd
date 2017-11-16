extends KinematicBody2D

const speed = 200

var velocity = Vector2()
var shuriken = preload("res://objects/shuriken.xml");
var shurikenCount = 0;
func _ready():
    set_fixed_process(true)

func _fixed_process(delta):
    var shurikenScript;
    velocity = Vector2(0,0)

    var upButton = Input.is_action_pressed("ui_up")
    var downButton = Input.is_action_pressed("ui_down")
    var rightButton = Input.is_action_pressed("ui_right")
    var leftButton = Input.is_action_pressed("ui_left")

    var upShootButton = Input.is_action_pressed("ui_shoot_up")
    var downShootButton = Input.is_action_pressed("ui_shoot_down")
    var rightShootButton = Input.is_action_pressed("ui_shoot_right")
    var leftShootButton = Input.is_action_pressed("ui_shoot_left")

    if(leftButton):
        velocity.x = -1
    elif(rightButton):
        velocity.x = 1
    if(upButton):
        velocity.y = -1
    elif(downButton):
        velocity.y = 1

    if(leftShootButton || rightShootButton || upShootButton || downShootButton):
        shurikenCount += 1;
        var shuriken_instance = shuriken.instance()
        shuriken_instance.set_name("Shuriken"+str(shurikenCount))
        add_child(shuriken_instance)
        shuriken_instance.set_owner(self)
        #use below variable for individual node access.
        var shuriken_instance_node = get_node("Shuriken"+str(shurikenCount))
        if(leftShootButton):
            shuriken_instance_node.projVelocity.x = -1
        elif(rightShootButton):
            shuriken_instance_node.projVelocity.x = 1
        if(upShootButton):
            shuriken_instance_node.projVelocity.y = -1;
        elif(downShootButton):
            shuriken_instance_node.projVelocity.y = 1;        

    var motion = velocity.normalized() * speed * delta
    move(motion)
    if (is_colliding()):
        var n = get_collision_normal()
        motion = n.slide(motion)
        velocity = n.slide(velocity)
        move(motion)