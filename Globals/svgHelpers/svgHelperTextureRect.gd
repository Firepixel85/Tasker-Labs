extends TextureRect

# Configurable Variables
@export var SVGPath:String = "res://Icons/Home.svg"#Path to SVG File to be used
@export var Scale:float = 1 # Size Multiplier (Increasing this makes the final image bigger)

# Buffer Variables
var DevelopmentResolution:Vector2 # Original resolution (auto-detected on _ready()); typically this is 1152x648
var ActiveResolution:Vector2 # Buffer to store the last resolution used for scaling, it is needed to check whether or not the window size has changed
var SVGBuffer:PackedByteArray # A buffer for storing the SVG
var Bitmap:Image = Image.new() # Bitmap for SVG->Bitmap conversion

func _ready() -> void:
	DevelopmentResolution = get_window().content_scale_size # Detect Original Resolution
	ActiveResolution = get_window().size # Initialize Active Resolution Variable
	SVGBuffer = FileAccess.get_file_as_bytes(SVGPath) # Load SVG to buffer
	update_scale()  # Load SVG and apply initial scaling
	anchor_bottom() # Position the sprite at the bottom of the window.

func _process(_delta: float) -> void:
	texture = load(SVGPath)
	if Vector2i(ActiveResolution) != get_window().size: # If the window size has changed
		position.x /=ActiveResolution.x / DevelopmentResolution.x # Unscale X Position using the X scaling of the last resolution (needed for the anchor X position scaling logic)
		ActiveResolution = get_window().size # Update Active Resolution
		update_scale() # Rescale SVG
		anchor_bottom() # Update sprite position based on new screen resolution
		scale = Vector2(1,1)/Scale
func update_scale(desired_scale: float = ActiveResolution.y / DevelopmentResolution.y) -> void: # Accepts scale parameter, defaults to scaling based on difference between development resolution and currently active resolution.
	Bitmap.load_svg_from_buffer(SVGBuffer, desired_scale * Scale) # Scale SVG and convert from buffer to bitmap
	texture = ImageTexture.create_from_image(Bitmap) # Apply the bitmap as a texture

func anchor_bottom() -> void: 
	position.y = ActiveResolution.y * 0.5 - texture.get_height() * 0.5 # Calculates the coordinate for the bottom of the screen offset by the height of the bitmap
	position.x *= ActiveResolution.x / DevelopmentResolution.x # Scale X Position according to X window scaling
