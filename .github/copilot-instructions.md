# Copilot Instructions for Tasker 2.0

This is a Godot 4.6 project (GL Compatibility renderer) for a task/focus management application called "Tasker". The project uses a custom UI component library called "Rose Garden" (RG) for consistent theming.

## Project Structure

### Key Directories

- **`Globals/`** - Global autoload scripts accessible throughout the project:
  - `Data.gd` - JSON file-based persistence system (uses `user://` directory)
  - `Main.gd` - Window state tracking and management
  - `Colors.gd` - Color constants and color lookup
  - `Debugger.gd` - Debugging utilities
  - `svgHelpers/` - SVG rendering helper components

- **`RG/`** - "Rose Garden" custom UI component library with reusable, themeable controls:
  - `Button/` - RGButton component with color variants (Gray, White, Red, Orange, Yellow, Green, Blue, Pink, Purple)
  - `Toggle/` - RGToggle component
  - `Drop Down/` - RGDropDown with menu items
  - `Segment Control/` - RGSegmentControl for multi-option selection
  - `Text Field/` - RGTextField component
  - Each component is self-contained with `.gd` script and `.tscn` scene file

- **`Icons/`** - SVG icon assets used throughout the UI

- **`Themes/`** - Theme resources for consistent visual styling

- **`LoadingScreen/`** - Loading screen scene and script

- **`Rose Garden Demo.tscn`** - Main demo scene showcasing all RG components

## Code Conventions

### GDScript Style

1. **@tool scripts** - UI components (especially RG components) use `@tool` annotation to enable live preview in the editor
2. **@onready** - Heavily used for node references in scripts
3. **@export** - Used for inspector properties (categories with `@export_category` for organization)
4. **Signals** - Components emit signals for state changes (e.g., `button_down`, `button_up`, `pressed`, `toggled`)
5. **Class names** - Use `class_name` declarations for reusable components (e.g., `RGButton`)

### Component Pattern (Rose Garden)

RG components follow a strict pattern:

- **Public methods**: Setter functions like `set_color()`, `set_text()`, `set_icon()` for configuration
- **Private methods**: Start after a comment block `#### STOP #### Here begin private function...`
- **Color variants**: Most components support color strings ("Gray", "White", "Red", "Orange", "Yellow", "Green", "Blue", "Pink", "Purple")
- **Editor hints**: Use `Engine.is_editor_hint()` in `_process()` for live editing support

### Globals as Autoloads

Scripts in `Globals/` are registered as autoloads in `project.godot`:
- Accessed globally without instantiation (e.g., `Data.save_file()`, `Colors.get_color()`, `Main.window.size`)
- `Data` handles persistence using JSON files stored in `user://` directory
- `Colors` provides both constants and a lookup function for color by string name

### Data Persistence

- Uses `Data` global singleton for file I/O
- All data stored as JSON in `user://` directory
- Pattern: `Data.make_file()`, `Data.load_file()`, `Data.save_to()`, `Data.save_file()`
- Example: Window state tracked via `Main.save_window_data()` which runs in background loop

## Window Configuration

From `project.godot`:
- Resolution: 1300×731 (fixed, non-resizable)
- Scaling: 2.0× with integer scaling mode
- Renderer: GL Compatibility (supports older hardware)
- Window extends to title bar (custom title bar support)
- Icon: SVG texture (`icon.svgtex`)

## C++ Extensions

Project includes git submodules for:
- `cpp/godot-cpp` (branch 3.5) - Godot C++ bindings
- `cpp/lunasvg` - SVG rendering library for SVG support

These are used for custom SVG texture rendering (`@svgsprite` shader/texture type).

## Running & Testing

This is a Godot editor project—no build command. To run:
1. Open in Godot 4.6 editor
2. Click play button or press F5 to run main scene
3. Main scene UID: `uid://1bvbrmgxa8n7` (configured in `project.godot`)

## Common Tasks

### Adding a New UI Component

1. Create folder under `RG/` with component name
2. Create `RG[ComponentName].gd` with `@tool` and `class_name`
3. Create `RG[ComponentName].tscn` scene
4. Use `@export_category()` to organize inspector properties
5. Emit relevant signals for state changes
6. Add color support if thematic (use `Colors.get_color()`)

### Adding Persistent Data

1. Use `Data` global: `Data.make_file("filename")`
2. Add/update data: `Data.save_to("key", value, "filename")`
3. Persist: `Data.save_file("filename")`
4. Load on startup: `Data.load_file("filename")`

### Adding Colors

- Define in `Colors.gd` as constants (e.g., `const my_color := Color(0.1, 0.2, 0.3)`)
- Add to `colors` array and `ColorEnum` for consistency
- Use `Colors.get_color("MyColor")` in components

## SVG Assets

- Project supports SVG textures via LunaSSG
- Icons in `Icons/` are `.svg` files
- Use `load("res://Icons/IconName.svg")` to load as textures
- SVG rendering is handled by compiled C++ extensions
