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

if (res) then
    ngx.print("res.status: ", res.status)

    if 200 ~= res.status then
        ngx.exit(res.status)
    end

    ngx.print("res.body: ", res.body)
end