local check = false;

if check then
    ngx.exit(ngx.HTTP_BAD_REQUEST)
    return
else
    print("not use check")
end