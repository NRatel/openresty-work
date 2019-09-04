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



local serpent = require "serpent"
local pb = require "pb"

--GET arg
local getArgs = ngx.req.get_uri_args()
for k, v in pairs(getArgs) do
    ngx.say("[GET ] key:", k, " v:", v)
end

--POST arg
ngx.req.read_body() -- 解析 body 参数之前一定要先读取 body
local postArgs = ngx.req.get_post_args()
for k, v in pairs(getArgs) do
    ngx.say("[POST ] key:", k, " v:", v)
end

--POST body
-----------------------------------------------------------------------
--注册pb
local prefix = ngx.config.prefix()  --"/home/nratel/openresty-work/game/"
require("app.protobuf.register").register(prefix .. "app/protobuf/proto.pb");

local data = {
    account = {
        username = "NRatel",
        password = "000000"
    }
}

local bytes = assert(pb.encode("msg.Login_C", data))
ngx.say(pb.tohex(bytes))
local data2 = assert(pb.decode("msg.Login_C", bytes))
ngx.say(serpent.block(data2))

-----------------------------------------------------------------------
local redis = require "resty.redis"
local red = redis:new()

red:set_timeout(1000) -- 1 sec

local ok, err = red:connect("127.0.0.1", 6379)
if not ok then
    ngx.say("failed to connect: ", err)
    return
end

-- 请注意这里 auth 的调用过程
local count
count, err = red:get_reused_times()
if 0 == count then
    ok, err = red:auth("password")
    if not ok then
        ngx.say("failed to auth: ", err)
        return
    end
elseif err then
    ngx.say("failed to get reused times: ", err)
    return
end

ok, err = red:set("dog", "an animal")
if not ok then
    ngx.say("failed to set dog: ", err)
    return
end

ngx.say("set result: ", ok)

-- 连接池大小是100个，并且设置最大的空闲时间是 10 秒
local ok, err = red:set_keepalive(10000, 100)
if not ok then
    ngx.say("failed to set keepalive: ", err)
    return
end