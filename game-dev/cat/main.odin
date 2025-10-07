package game

import "core:encoding/json"
import "core:fmt"
import "core:mem"
import "core:os"
import rl "vendor:raylib"

Animation_Name :: enum {
	Idle,
	Run,
}

Animation :: struct {
	texture:       rl.Texture2D,
	num_frames:    int,
	frame_timer:   f32,
	current_frame: int,
	frame_length:  f32,
	name:          Animation_Name,
}

update_animation :: proc(a: ^Animation) {
	a.frame_timer += rl.GetFrameTime()

	// cycle through available frames by measuring the frame time
	if a.frame_timer > a.frame_length {
		a.current_frame += 1 // go to next frame
		a.frame_timer = 0

		if a.current_frame == a.num_frames {
			a.current_frame = 0
		}
	}
	// note that the 'frame_length' defines how quickly the texture will change
	// (0.1 when running and 0.5 when idle)
}

draw_animation :: proc(a: Animation, pos: rl.Vector2, flip: bool) {
	width := f32(a.texture.width)
	height := f32(a.texture.height)

	// source area from image (which is a rectangle)
	source := rl.Rectangle {
		x      = f32(a.current_frame) * width / f32(a.num_frames),
		y      = 0,
		width  = width / f32(a.num_frames),
		height = height,
	}

	if flip {
		source.width = -source.width
	}

	// to where the image will be placed (destionation)
	dest := rl.Rectangle {
		x      = pos.x,
		y      = pos.y,
		// times 4 to scale time image
		width  = width / f32(a.num_frames),
		height = height,
	}

	rl.DrawTexturePro(a.texture, source, dest, {dest.width / 2, dest.height}, 0, rl.WHITE)
}

PixelWindowHeight :: 180

Level :: struct {
	platforms: [dynamic]rl.Vector2,
}

platform_collider :: proc(pos: rl.Vector2) -> rl.Rectangle {
	return {pos.x, pos.y, 96, 16}
}

main :: proc() {
	track: mem.Tracking_Allocator
	mem.tracking_allocator_init(&track, context.allocator)
	context.allocator = mem.tracking_allocator(&track)

	defer {
		for _, entry in track.allocation_map {
			fmt.eprintf("%v leaked %v bytes\n", entry.location, entry.size)
		}
		for entry in track.bad_free_array {
			fmt.eprintf("%v bad free\n", entry.location)
		}
		mem.tracking_allocator_destroy(&track)
	}

	rl.InitWindow(1280, 720, "Odin!")
	rl.SetWindowState({.WINDOW_RESIZABLE})
	rl.SetTargetFPS(60)
	rl.SetExitKey(.Q)

	player_pos: rl.Vector2
	player_vel: rl.Vector2
	player_grounded: bool
	player_flip: bool

	player_run := Animation {
		texture      = rl.LoadTexture("cat_run.png"),
		num_frames   = 4,
		frame_length = 0.1,
		name         = .Run,
	}

	player_idle := Animation {
		texture      = rl.LoadTexture("cat_idle.png"),
		num_frames   = 2,
		frame_length = 0.5,
		name         = .Idle,
	}

	current_animation := player_idle

	level: Level

	if level_data, ok := os.read_entire_file("level.json", context.temp_allocator); ok {
		if json.unmarshal(level_data, &level) != nil {
			append(&level.platforms, rl.Vector2{-20, 20})
		}
	}


	platform_texture := rl.LoadTexture("platform.png")
	editing := false

	for !rl.WindowShouldClose() { 	// exit when window is, well, closed
		rl.BeginDrawing() // start new frame
		rl.ClearBackground(rl.SKYBLUE) // make it blue

		if rl.IsKeyDown(.A) { 	// left
			player_vel.x = -100
			player_flip = true
			if current_animation.name != .Run {
				current_animation = player_run
			}
		} else if rl.IsKeyDown(.D) { 	// right
			player_vel.x = 100
			player_flip = false
			if current_animation.name != .Run {
				current_animation = player_run
			}
		} else { 	// stationary
			player_vel.x = 0
			if current_animation.name != .Idle {
				current_animation = player_idle
			}
		}

		player_vel.y += 1000 * rl.GetFrameTime() // "gravity"

		if player_grounded && rl.IsKeyPressed(.SPACE) {
			player_vel.y = -300
		}

		player_pos += player_vel * rl.GetFrameTime()

		// a whole player collider can be either divided into a 'top' and 'bottom'
		// collider, or with a 'whole' player collider
		player_feet_collider := rl.Rectangle{player_pos.x - 4, player_pos.y - 4, 8, 4}

		player_grounded = false

		for platform in level.platforms {
			if rl.CheckCollisionRecs(player_feet_collider, platform_collider(platform)) &&
			   player_vel.y > 0 {
				player_vel.y = 0
				player_pos.y = platform.y
				player_grounded = true
			}
		}

		update_animation(&current_animation)

		screen_height := f32(rl.GetScreenHeight())

		camera := rl.Camera2D {
			zoom   = screen_height / PixelWindowHeight,
			// start camera at the middle of the screen
			offset = {f32(rl.GetScreenWidth() / 2), f32(screen_height / 2)},
			target = player_pos, // <-- here! (centered)
		}

		// this makes it seems like there's 'no movement' due to the camera always
		// being centered on the player_pos
		rl.BeginMode2D(camera)
		draw_animation(current_animation, player_pos, player_flip)
		for platform in level.platforms {
			rl.DrawTextureV(platform_texture, platform, rl.WHITE)
		}
		// debug player collision
		// rl.DrawRectangleRec(player_feet_collider, {0, 255, 0, 100})
		if rl.IsKeyPressed(.PERIOD) {
			editing = !editing
		}

		if editing {
			mp := rl.GetScreenToWorld2D(rl.GetMousePosition(), camera)
			rl.DrawTextureV(platform_texture, mp, rl.WHITE)

			if rl.IsMouseButtonPressed(.LEFT) {
				append(&level.platforms, mp)
			}

			if rl.IsMouseButtonPressed(.RIGHT) {
				for p, idx in level.platforms {
					if rl.CheckCollisionPointRec(mp, platform_collider(p)) {
						unordered_remove(&level.platforms, idx)
						break
					}
				}
			}
		}

		rl.EndMode2D()
		rl.EndDrawing() // and, show to user

		// allow usage of the 'temp_allocator' in the main loop by avoiding a
		// memory leak
		free_all(context.temp_allocator)
	}

	rl.CloseWindow() // close window

	if level_data, err := json.marshal(level, allocator = context.temp_allocator); err == nil {
		os.write_entire_file("level.json", level_data)
	}

	free_all(context.temp_allocator)
	// this memory leak does not matter due to the memory occupied by this
	// dynamic array being freed once the program ends, which makes this 'delete'
	// not really necessary
	delete(level.platforms)
}

