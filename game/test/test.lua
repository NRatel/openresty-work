local http = require "resty.http"
local httpc = http.new()
local res, err = httpc:request_uri("http://127.0.0.1:81/game", {
    method = "POST",
    args = ngx.encode_args({ a = 111, b = 'bbb' }),
    body = ngx.encode_args({ c = 222, d = 'ddd' }),
    -- headers = {
    --     ["Content-Type"] = "application/x-www-form-urlencoded",
    -- },
    keepalive_timeout = 60,
    keepalive_pool = 10
})

if res.status == ngx.HTTP_OK then
    ngx.say(res.body)
else
    ngx.exit(res.status)
end