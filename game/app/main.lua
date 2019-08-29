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