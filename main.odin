package game

import rl "vendor:raylib"

main :: proc() {
  rl.InitWindow(1280, 720, "Odin!")
  player_pos := rl.Vector2 { 640, 320 }
  player_vel: rl.Vector2
  player_grounded: bool

  for !rl.WindowShouldClose() { // exit when window is, well, closed
    rl.BeginDrawing()           // start new frame
    rl.ClearBackground(rl.BLUE) // make it blue

    if rl.IsKeyDown(.A) { // left
      player_vel.x = -400
    } else if rl.IsKeyDown(.D) { // right
      player_vel.x = 400
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

    rl.DrawRectangleV(player_pos, {64, 64}, rl.GREEN)
    rl.EndDrawing() // and, show to user
  }

  rl.CloseWindow()  // close window
}
