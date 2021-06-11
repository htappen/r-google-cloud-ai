-- Pulls cookies set by server originnaly in cache_cookies.lua
-- Sends the back to the R server

-- Remove some headers blocked by the Notebooks proxy.
-- This helps with local debugging
ngx.req.clear_header("Cookie")
ngx.req.clear_header("X-CSRF-Token")

-- Add back in the missing headers
local cookie_cache = ngx.shared.cookie_cache
local cookie_string = ""
for _, k in pairs(cookie_cache:get_keys()) do
  local dict_val, err = cookie_cache:get(k)
  cookie_string = cookie_string .. k .. "=" .. dict_val .. "; "
end
ngx.req.set_header("Cookie", cookie_string)

local csrf_val, err = cookie_cache:get("csrf-token")
if csrf_val ~= nil then
  ngx.req.set_header("X-CSRF-Token", csrf_val)
end

