# Markdown 快捷键速查表

## 侧边栏 & 预览

| 快捷键 | 功能 | 来源 |
|---|---|---|
| `<space>mo` | 打开/关闭 TOC 目录侧边栏 | outline.nvim |
| `<space>cp` | 浏览器预览 Markdown | markdown-preview |
| `<space>um` | 开关渲染模式（所见即所得） | render-markdown |
| `<space>uz` | 禅模式（无干扰写作） | zen-mode |

## TOC 侧边栏内（光标在侧边栏时）

| 快捷键 | 功能 |
|---|---|
| `<CR>` | 跳转到该标题 |
| `o` | 预览该标题（不跳转） |
| `h` | 折叠 |
| `l` | 展开 |
| `<Tab>` | 切换折叠/展开 |
| `<S-Tab>` | 全部切换折叠/展开 |
| `zM` | 全部折叠 |
| `zR` | 全部展开 |
| `q` / `<Esc>` | 关闭侧边栏 |

## 正文编辑

| 快捷键 | 功能 | 来源 |
|---|---|---|
| `gsb` | **加粗** / 取消加粗 | markdown.nvim |
| `gsi` | *斜体* / 取消斜体 | markdown.nvim |
| `gss` | ~~删除线~~ / 取消删除线 | markdown.nvim |
| `gsc` | `行内代码` / 取消代码 | markdown.nvim |
| `gl` | 添加链接 | markdown.nvim |
| `gx` | 打开/跟随链接 | markdown.nvim |
| `<space>mx` | 切换 checkbox ☑️ | markdown.nvim |
| `<space>mt` | 插入目录（文内 TOC） | markdown.nvim |

## 标题导航

| 快捷键 | 功能 |
|---|---|
| `]]` | 跳转到下一个标题 |
| `[[` | 跳转到上一个标题 |

## 提示

- `gs` 系列快捷键支持 Visual 模式 — 先选中文字再按 `gsb` 可以给选中内容加粗
- `<space>` 即 Leader 键（默认空格）
