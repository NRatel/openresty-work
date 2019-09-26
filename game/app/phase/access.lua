--syntax: access_by_lua_file <path-to-lua-script-file>
--context: http, server, location, location if
--phase: access tail
--充当访问阶段处理程序，并为每个请求执行此文件中的Lua代码。
--可以进行API调用，并在独立的全局环境(即沙箱)中作为一个新生成的协程执行。
--注意，这个处理程序总是在标准 ngx_http_rewrite_module 之后运行。
--注意，ngx_auth_request 模块可以通过使用 access_by_lua 来近似(等价处理)。
--注意，当在 access_by_lua 处理程序中调用 ngx.exit(ngx.OK) 时，Nginx请求处理控制流仍然会继续到内容处理程序。
--要终止 access_by_lua 中的当前请求，应该调用 ngx.exit(status >= 200(ngx.HTTP_OK) 且 status < 300(ngx.HTTP_SPECIAL_RESPONSE)来以成功的方式退出。
--使用 ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR) (or its friends) 来以失败的方式退出。
--可以在<path-to-lua-script-file>字符串中使用Nginx变量来提供灵活性。然而，这有一些风险，通常不建议这样做。
--当给定一个相对路径 如 foo/bar.lua 时，它们将被转换为绝对路径(拼上启动Nginx服务器时由-p PATH 传入的前缀路径)。
--当打开Lua代码缓存时(默认情况下)，用户代码在第一个请求时加载一次并缓存，每次修改Lua源文件时都必须重新加载Nginx配置。
--可以在开发期间暂时禁用Lua代码缓存， 以避免每次都要重新加载Nginx配置。可在 nginx.conf 中关闭 lua_code_cache。

local serpent = require "serpent"
local cjson = require "cjson"
local mysql = require "resty.mysql"

-------------------------------------------------------------------------------------------
--/*完成密文协议解码*/--
local headers = ngx.req.get_headers()
-- 解析 body 参数之前一定要先读取 body
ngx.req.read_body()
--它总是返回一个 lua string
local data = ngx.req.get_body_data()
local commonRequest = cjson.decode(data)
local msgName = commonRequest.msgName
local msg = cjson.decode(commonRequest.msg)
ngx.say(msgName)
ngx.say(serpent.block(msg))
ngx.ctx.msgName = msgName
ngx.ctx.msg = msg

-------------------------------------------------------------------------------------------
--/*连接mysql*/--
local db, err = mysql:new()
if not db then
    ngx.say("failed to instantiate mysql: ", err)
    return
end

db:set_timeout(1000) -- 1 sec

local ok, err, errcode, sqlstate = db:connect {
    host = "127.0.0.1",
    port = 3306,
    database = "game001",
    user = "gamer",
    password = "gamer",
    charset = "utf8",
    max_packet_size = 1024 * 1024,
}

if not ok then
    ngx.say("failed to connect: ", err, ": ", errcode, " ", sqlstate)
    return
end

ngx.say("connected to mysql.")

