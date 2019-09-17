--syntax: content_by_lua_file <path-to-lua-script-file>
--context: location, location if
--phase: content
--充当内容处理程序，并为每个请求执行此文件中的Lua代码。
--可以进行API调用，并在独立的全局环境(即沙箱)中作为一个新生成的协程执行。
--不要在同一位置使用此指令和其他内容处理程序指令。例如，这个指令和proxy_pass指令不应该在同一个位置使用。
--可以在<path-to-lua-script-file>字符串中使用Nginx变量来提供灵活性。然而，这有一些风险，通常不建议这样做。
--当给定一个相对路径 如 foo/bar.lua 时，它们将被转换为绝对路径(拼上启动Nginx服务器时由-p PATH 传入的前缀路径)。
--当打开Lua代码缓存时(默认情况下)，用户代码在第一个请求时加载一次并缓存，每次修改Lua源文件时都必须重新加载Nginx配置。
--可以在开发期间暂时禁用Lua代码缓存， 以避免每次都要重新加载Nginx配置。可在 nginx.conf 中关闭 lua_code_cache。
--Nginx变量在文件路径中支持动态调度，但是要非常小心恶意用户输入，并始终仔细验证或过滤掉用户提供的路径组件。

--------------------------------------------------------------------------

require("app.test.request_arg"):test()
require("app.test.pb"):test()
require("app.test.mysql"):test()
-- require("app.test.redis"):test()