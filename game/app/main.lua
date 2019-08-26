local serpent = require "serpent"


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

-- local file, msg = io.open("${prefix}/app/test.txt", "r")

local file, msg = io.open("/home/nratel/openresty-work/game/app/test.txt", "r")

if file ~= nil then
    local str = file:read("*a")
    file:close()
    ngx.say(str)
else
   ngx.say("err, " .. msg)
end