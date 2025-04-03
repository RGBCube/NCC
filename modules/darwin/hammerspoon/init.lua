---@type table
_G.hs = _G.hs

PaperWM = hs.loadSpoon("PaperWM")
Swipe = hs.loadSpoon("Swipe")

local windowResize = function(offsetWidth, offsetHeight)
  local window = hs.window.focusedWindow()
  if not window then return end

  local window_frame = window:frame()
  local screen_frame = window:screen():frame()

  -- Adjust width
  window_frame.w = window_frame.w + offsetWidth
  window_frame.w = math.max(100, math.min(window_frame.w, screen_frame.w - window_frame.x))

  -- Adjust height
  window_frame.h = window_frame.h + offsetHeight
  window_frame.h = math.max(100, math.min(window_frame.h, screen_frame.h - window_frame.y))

  window:setFrame(window_frame)
end

local windowClose = function()
  local window = hs.window.focusedWindow()

  if not window then return end

  window:close()
end

local spaceChange = function(offset)
  local current_space = hs.spaces.activeSpaceOnScreen()
  local spaces = hs.spaces.allSpaces()[hs.screen.mainScreen():getUUID()]

  local current_index = nil
  for space_index, space in ipairs(spaces) do
    if space == current_space then
      current_index = space_index
      break
    end
  end

  local next_index = current_index + offset
  if next_index > #spaces then
    next_index = 1
  elseif next_index <= 0 then
    next_index = #spaces
  end

  local next_space = spaces[next_index]

  hs.spaces.gotoSpace(next_space)
end

do -- HOTKEYS
  local super = { "cmd", "alt" }
  local super_ctrl = { "cmd", "alt", "ctrl" }
  local super_shift = { "cmd", "alt", "shift" }

  hs.hotkey.bind(super, "left", PaperWM.actions.focus_left)
  hs.hotkey.bind(super, "down", PaperWM.actions.focus_down)
  hs.hotkey.bind(super, "up", PaperWM.actions.focus_up)
  hs.hotkey.bind(super, "right", PaperWM.actions.focus_right)

  hs.hotkey.bind(super, "h", PaperWM.actions.focus_left)
  hs.hotkey.bind(super, "j", PaperWM.actions.focus_down)
  hs.hotkey.bind(super, "k", PaperWM.actions.focus_up)
  hs.hotkey.bind(super, "l", PaperWM.actions.focus_right)

  hs.hotkey.bind(super_ctrl, "left", function() windowResize(-100, 0) end)
  hs.hotkey.bind(super_ctrl, "down", function() windowResize(0, 100) end)
  hs.hotkey.bind(super_ctrl, "up", function() windowResize(0, -100) end)
  hs.hotkey.bind(super_ctrl, "right", function() windowResize(100, 0) end)

  hs.hotkey.bind(super_ctrl, "h", function() windowResize(-100, 0) end)
  hs.hotkey.bind(super_ctrl, "j", function() windowResize(0, 100) end)
  hs.hotkey.bind(super_ctrl, "k", function() windowResize(0, -100) end)
  hs.hotkey.bind(super_ctrl, "l", function() windowResize(100, 0) end)

  hs.hotkey.bind(super, "tab", function() spaceChange(1) end)
  hs.hotkey.bind(super_shift, "tab", function() spaceChange(-1) end)

  for index = 1, 9 do
    hs.hotkey.bind(super, tostring(index), PaperWM.actions["switch_space_" .. index])
    hs.hotkey.bind(super_shift, tostring(index), PaperWM.actions["move_window_" .. index])
  end

  hs.hotkey.bind(super_shift, "left", PaperWM.actions.swap_left)
  hs.hotkey.bind(super_shift, "down", PaperWM.actions.swap_down)
  hs.hotkey.bind(super_shift, "up", PaperWM.actions.swap_up)
  hs.hotkey.bind(super_shift, "right", PaperWM.actions.swap_right)

  hs.hotkey.bind(super_shift, "h", PaperWM.actions.swap_left)
  hs.hotkey.bind(super_shift, "j", PaperWM.actions.swap_down)
  hs.hotkey.bind(super_shift, "k", PaperWM.actions.swap_up)
  hs.hotkey.bind(super_shift, "l", PaperWM.actions.swap_right)

  hs.hotkey.bind(super, "q", windowClose)
  hs.hotkey.bind(super, "c", PaperWM.actions.center_window)
  hs.hotkey.bind(super_ctrl, "f", PaperWM.actions.full_width)
  hs.hotkey.bind(super, "f", PaperWM.actions.toggle_floating)

  hs.hotkey.bind(super, "w", function() hs.application.launchOrFocus("Zen") end)
  hs.hotkey.bind(super, "return", function() hs.application.launchOrFocus("Ghostty") end)
  hs.hotkey.bind(super, "t", function() hs.application.launchOrFocus("Finder") end)

  PaperWM.swipe_fingers = 3
  PaperWM.swipe_gain = 1.7

  PaperWM:start()
end

do -- 3 FINGER VERTICAL SWIPE TO CHANGE SPACES
  local current_id, threshold

  Swipe:start(3, function(direction, distance, id)
    if id ~= current_id then
      current_id = id
      threshold = 0.2 -- 20% of trackpad
      return
    end

    if distance > threshold then
      threshold = math.huge -- only trigger once per swipe

      if direction == "up" then
        spaceChange(1)
      elseif direction == "down" then
        spaceChange(-1)
      end
    end
  end)
end

do -- SPACE BUTTONS
  local space_buttons = {}

  local updateSpaceButtons = function()
    for _, button in pairs(space_buttons) do
      button:delete()
    end
    space_buttons = {}

    local current_space = hs.spaces.activeSpaceOnScreen()
    local spaces = hs.spaces.allSpaces()[hs.screen.mainScreen():getUUID()]

    for index = #spaces, 1, -1 do
      local space = spaces[index]

      local title = tostring(index)

      local attributes = space == current_space and {
        color = { red = 1 }
      } or {}

      local button = hs.menubar.new()
      button:setTitle(hs.styledtext.new(title, attributes))
      button:setClickCallback(function()
        hs.spaces.gotoSpace(space)
      end)

      table.insert(space_buttons, button)
    end
  end

  hs.spaces.watcher.new(updateSpaceButtons):start()

  updateSpaceButtons()
end
