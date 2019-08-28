local serpent = require "serpent"
local pb = require "pb"
local protoc = require "protoc"

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

local prefix = ngx.config.prefix()  --"/home/nratel/openresty-work/game/"

local pbLoader = require("app.protobuf.loader");
pbLoader:loadByBytes(prefix .. "app/protobuf/proto.bytes");

local data = {
    account = {
        username = "NRatel",
        password = "000000"
    }
}

local bytes = assert(pb.encode("msg.Login_C", data))
ngx.say(pb.tohex(bytes))
ngx.say("---------------------")
local data2 = assert(pb.decode("msg.Login_C", bytes))
ngx.say(serpent.block(data2))