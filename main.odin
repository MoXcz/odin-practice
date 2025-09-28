package game

import rl "vendor:raylib"

Animation :: struct {
  texture: rl.Texture2D,
  num_frames: int,
  frame_timer: f32,
  current_frame: int,
  frame_length: f32,
}

main :: proc() {
  rl.InitWindow(1280, 720, "Odin!")
  rl.SetExitKey(.Q)

  player_pos := rl.Vector2 { 640, 320 }
  player_vel: rl.Vector2
  player_grounded: bool
  player_flip: bool

  player_run := Animation {
    texture = rl.LoadTexture("cat_run.png"),
    num_frames = 4,
    frame_length = 0.1
  }

  for !rl.WindowShouldClose() { // exit when window is, well, closed
    rl.BeginDrawing()           // start new frame
    rl.ClearBackground({110, 184, 168, 255}) // make it blue

    if rl.IsKeyDown(.A) { // left
      player_vel.x = -400
      player_flip = true
    } else if rl.IsKeyDown(.D) { // right
      player_vel.x = 400
      player_flip = false
    } else { // stationary
      player_vel.x = 0
    }

    player_vel.y += 2000 * rl.GetFrameTime() // "gravity"
    if player_grounded && rl.IsKeyPressed(.SPACE) {
      player_vel.y = -600
      player_grounded = false
    }

    player_pos += player_vel * rl.GetFrameTime()

    // prevent player from disappearing from the window
    if player_pos.y > f32(rl.GetScreenHeight()) - 64 {
      player_pos.y = f32(rl.GetScreenHeight()) - 64
      player_grounded = true
    }

    if player_pos.x > f32(rl.GetScreenWidth() - 64) {
      player_pos.x = f32(rl.GetScreenWidth()) - 64
    }

    player_run_width := f32(player_run.texture.width)
    player_run_height := f32(player_run.texture.height)

    player_run.frame_timer += rl.GetFrameTime()

    if player_run.frame_timer > player_run.frame_length {
      player_run.current_frame += 1
      player_run.frame_timer = 0

      if player_run.current_frame == player_run.num_frames {
        player_run.current_frame = 0
      }
    }

    // source area from image (which is a rectangle)
    draw_player_source := rl.Rectangle {
      x = f32(player_run.current_frame) * player_run_width / f32(player_run.num_frames),
      y = 0,
      width = player_run_width / f32(player_run.num_frames),
      height = player_run_height
    }

    if player_flip {
      draw_player_source.width = -draw_player_source.width
    }

    // to where the image will be placed (destionation)
    draw_player_dest := rl.Rectangle {
      x = player_pos.x,
      y = player_pos.y,
      // times 4 to scale time image
      width = player_run_width * 4 / f32(player_run.num_frames),
      height = player_run_height * 4
    }

    rl.DrawTexturePro(player_run.texture, draw_player_source, draw_player_dest, 0, 0, rl.WHITE)
    rl.EndDrawing() // and, show to user
  }

  rl.CloseWindow()  // close window
}
