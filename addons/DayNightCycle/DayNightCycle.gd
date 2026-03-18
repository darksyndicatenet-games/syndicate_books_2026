extends DirectionalLight3D

@export var worldEnvironment: WorldEnvironment
@export var nightLight: DirectionalLight3D

@export_group("Night Settings")
@export var nightLightEnergy: float = 0.1
@export var nightStarIntensity: float = 0.5

@export_group("Colors")
@export var nightColor := Color("000214")
@export var nightCloudColor := Color("0a0b18")
@export var nightSunScatter := Color("0e0929")

var sky: ShaderMaterial

func _ready():
	# Get sky material safely
	if worldEnvironment and worldEnvironment.environment and worldEnvironment.environment.sky:
		sky = worldEnvironment.environment.sky.sky_material
	
	# Turn OFF main sun light
	light_energy = 0.0
	
	# Turn ON moon light
	if nightLight:
		nightLight.light_energy = nightLightEnergy
	
	# Apply night visuals
	if sky:
		sky.set_shader_parameter("top_color", nightColor)
		sky.set_shader_parameter("bottom_color", nightColor)
		sky.set_shader_parameter("stars_intensity", nightStarIntensity)
		sky.set_shader_parameter("clouds_light_color", nightCloudColor)
		sky.set_shader_parameter("sun_scatter", nightSunScatter)

func _physics_process(delta):
	# Do nothing (keeps it permanently night)
	pass
