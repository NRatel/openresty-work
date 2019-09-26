local _M = {}

function _M:test()
    ngx.say("-------------------- test request_arg --------------------")

    local headers = ngx.req.get_headers()
    ngx.say("---------headers---------")
    ngx.say(serpent.block(headers))
    ngx.say("-------------------------")

    --GET args
    local getArgs = ngx.req.get_uri_args()
    ngx.say("---------GET args---------")
    ngx.say(serpent.block(getArgs))
    ngx.say("-------------------------")

    --POST args、data  -- 解析 body 参数之前一定要先读取 body
    ngx.req.read_body()
    --它总是返回一个 lua table
    local postArgs = ngx.req.get_post_args()
    ngx.say(serpent.block(postArgs))
    --它总是返回一个 lua string

    local postData = ngx.req.get_body_data()
    ngx.say(postData)
end

return _M