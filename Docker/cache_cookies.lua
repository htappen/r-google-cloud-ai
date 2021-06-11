-- Saves cookies issues by the proxied server to a shared memory dict

local cookie_cache = ngx.shared.cookie_cache
local EQUALS = string.byte("=")
local SEMICOLON = string.byte(";")

local cookies = ngx.header.set_cookie
if cookies ~= nil then
  if type(cookies) ~= "table" then
    cookies = { cookies }
  end
  for cookie_i, cookie in pairs(cookies) do
    local len = #cookie
    local key_start = 1
    local key_end = 1
    local value_end = len

    for i=1, len do
      local char = string.byte(cookie, i)
      if char == EQUALS then
        key_end = i - 1
      end
      if char == SEMICOLON then
        value_end = i - 1
        break
      end
    end

    local cookie_key = string.sub(cookie, key_start, key_end)
    local cookie_value = string.sub(cookie, key_end + 2, value_end)
    
    if cookie_value ~= "" then
      cookie_cache:set(cookie_key, cookie_value, 3600.0)
    end
  end
end

ngx.header.set_cookie = nil