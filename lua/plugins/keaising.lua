return {
  {
    "keaising/im-select.nvim",
    config = function()
      require("im_select").setup({
        -- Mac 下默认的英文输入法 ID，通常不用改，除非你用的是第三方输入法
        default_im_select = "com.apple.keylayout.ABC",

        -- 在这些模式下自动切回英文
        default_command = "im-select",

        -- 设置为 true 可以让它在你切回 Insert 模式时恢复之前的中文状态
        -- 建议先设为 false，因为写代码主要还是英文，偶尔写中文手动切一下更可控
        set_previous_events = {},
      })
    end,
  },
}
