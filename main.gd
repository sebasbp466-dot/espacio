extends Node3D

var nave: Node3D
var fondo: Node3D
var vel := Vector3.ZERO
var dedos := {}

func _ready():
    nave = Node3D.new()
    add_child(nave)
    var cam = Camera3D.new()
    cam.far = 100000
    nave.add_child(cam)

    var luz = DirectionalLight3D.new()
    luz.rotation_degrees = Vector3(-30, 40, 0)
    add_child(luz)

    var env = WorldEnvironment.new()
    env.environment = Environment.new()
    env.environment.background_mode = Environment.BG_COLOR
    env.environment.background_color = Color(0, 0, 0.02)
    add_child(env)

    fondo = Node3D.new()
    add_child(fondo)
    _estrellas()
    _planetas_prueba()

func _estrellas():
    var mat = StandardMaterial3D.new()
    mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
    mat.albedo_color = Color.WHITE
    var m = SphereMesh.new()
    m.radius = 0.5
    m.height = 1.0
    m.radial_segments = 4
    m.rings = 2
    m.material = mat
    var mm = MultiMesh.new()
    mm.transform_format = MultiMesh.TRANSFORM_3D
    mm.instance_count = 800
    mm.mesh = m
    for i in 800:
        var dir = Vector3(randf() - 0.5, randf() - 0.5, randf() - 0.5).normalized()
        mm.set_instance_transform(i, Transform3D(Basis(), dir * randf_range(300, 400)))
    var inst = MultiMeshInstance3D.new()
    inst.multimesh = mm
    fondo.add_child(inst)

func _planetas_prueba():
    for i in 5:
        var r = randf_range(20, 80)
        var s = SphereMesh.new()
        s.radius = r
        s.height = r * 2.0
        s.radial_segments = 48
        s.rings = 24
        var mat = StandardMaterial3D.new()
        mat.albedo_color = Color.from_hsv(randf(), 0.6, 0.9)
        s.material = mat
        var p = MeshInstance3D.new()
        p.mesh = s
        var dir = Vector3(randf() - 0.5, randf() - 0.5, -randf() - 0.2).normalized()
        p.position = dir * randf_range(300, 1500)
        add_child(p)

func _input(e):
    var w = get_viewport().get_visible_rect().size.x
    if e is InputEventScreenTouch:
        if e.pressed:
            dedos[e.index] = e.position
        else:
            dedos.erase(e.index)
    elif e is InputEventScreenDrag:
        dedos[e.index] = e.position
        if e.position.x < w * 0.5:
            nave.rotate_object_local(Vector3.UP, -e.relative.x * 0.004)
            nave.rotate_object_local(Vector3.RIGHT, -e.relative.y * 0.004)

func _process(d):
    var w = get_viewport().get_visible_rect().size.x
    var empuje = false
    for p in dedos.values():
        if p.x > w * 0.5:
            empuje = true
    if empuje:
        vel += -nave.global_transform.basis.z * 120.0 * d
        vel = vel.limit_length(1500.0)
    else:
        vel *= (1.0 - 0.4 * d)
    nave.position += vel * d
    fondo.global_position = nave.global_position
