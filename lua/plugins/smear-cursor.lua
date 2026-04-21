return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  opts = {
    -- 拖尾动画参数
    stiffness = 0.9,
    trailing_stiffness = 0.7,
    trailing_exponent = 0.1,
    distance_stop_animating = 0.5,

    -- 跨 buffer / 相邻行也启用拖尾
    smear_between_buffers = true,
    smear_between_neighbor_lines = true,

    -- 终端兼容性
    hide_target_hack = true,
  },
}
