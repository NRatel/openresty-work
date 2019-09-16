local serpent = require "serpent"
local pb = require "pb"

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