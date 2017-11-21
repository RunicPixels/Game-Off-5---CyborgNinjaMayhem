extends Node2D

onready var root = get_tree().get_root()
onready var base_size = root.get_rect().size

func _ready():
    get_tree().connect("screen_resized", self, "_on_screen_resized")
    
    set_process_input(true)
    root.set_as_render_target(true)
    root.set_render_target_update_mode(root.RENDER_TARGET_UPDATE_ALWAYS)
    root.set_render_target_to_screen_rect(root.get_rect())
    _on_screen_resized()

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
            