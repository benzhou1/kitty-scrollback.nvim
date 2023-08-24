local M = {}

---@param c  string
M.hexToRgb = function(c)
  c = string.lower(c)
  return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
end

---@param foreground string foreground color
---@param background string background color
---@param alpha number|string number between 0 and 1. 0 results in bg, 1 results in fg
M.blend = function(foreground, background, alpha)
  alpha = type(alpha) == 'string' and (tonumber(alpha, 16) / 0xff) or alpha
  local bg = M.hexToRgb(background)
  local fg = M.hexToRgb(foreground)

  local blendChannel = function(i)
    local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format('#%02x%02x%02x', blendChannel(1), blendChannel(2), blendChannel(3))
end

M.darken = function(hex, amount, bg)
  local default_bg = '#ffffff'
  if vim.o.background == 'dark' then
    default_bg = '#000000'
  end
  return M.blend(hex, bg or default_bg, amount)
end

---Convert camelCase to SCREAMING_SNAKECASE
---@param s string
---@return string
M.screaming_snakecase = function(s)
  -- copied and modified from https://codegolf.stackexchange.com/a/177958
  return s:gsub('%f[^%l]%u', '_%1'):gsub('%f[^%a]%d', '_%1'):gsub('%f[^%d]%a', '_%1'):gsub('(%u)(%u%l)', '%1_%2'):upper()
end

-- copied from https://github.com/folke/lazy.nvim/blob/dac844ed617dda4f9ec85eb88e9629ad2add5e05/lua/lazy/view/float.lua#L70
M.size = function(max, value)
  return value > 1 and math.min(value, max) or math.floor(max * value)
end


return M
