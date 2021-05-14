-- nmDisplayTest
-- 1.0.2 @NightMachines
-- llllllll.co/t/norns-display-gamma/
--
-- testpatterns for luminance
-- measurements and gamma
-- correction research.
--
-- turn any encoder or press
-- K2 or K3 to switch screens
--
-- on flicker screens:
-- E3 changes rate
 



-- _norns.screen_export_png("/home/we/dust/nmDisplayTest.png")
-- norns.script.load("code/nmDisplayTest/nmDisplayTest.lua")


-- VARS!
local selScreen = 1 -- selected screen
local myScreens = 37
local flicker = 0
local refreshRate = 15

-- INIT!
function init()
  redraw()
end


-- BUTTONS!
function key(id,st)
  if id==1 then
    if st==1 then
      k1held = 1
    else
      k1held = 0
    end
  elseif id==2 and st == 1 then
    selScreen = util.clamp(selScreen-1,1,myScreens)
  elseif id==3 and st == 1then
    selScreen = util.clamp(selScreen+1,1,myScreens)
  end
  if selScreen < 23 then
    refreshRate = 15
    re.time = 1.0 / refreshRate
  end
end


-- ENCODERS!
function enc(id,delta)

  if id==1 then
  selScreen = util.clamp(selScreen+delta,1,myScreens)    
  elseif id==2 then
  selScreen = util.clamp(selScreen+delta,1,myScreens)
  elseif id==3 then 
    if selScreen >= 23 then
      refreshRate = util.clamp(refreshRate+delta,2,15)
      re.time = 1.0 / refreshRate
    else
      selScreen = util.clamp(selScreen+delta,1,myScreens)
    end
  end
  
  if selScreen < 23 then
    refreshRate = 15
    re.time = 1.0 / refreshRate
  end

end


-- REDRAW!
function redraw()
  -- screen.clear()
  screen.level(0)
  screen.move(0,0)
  screen.rect(0,0,128,64)
  screen.fill()
  
  drawScreen(selScreen)
  
  if k1held == 1 then
    screen.level(0)
    screen.rect(0,0,128,64)
    screen.fill()
    screen.level(15)
    screen.move(64,32)
    screen.text_center("hi")
  end
  
  screen.line_width(1)
  screen.update()
end

function drawScreen(s)
  if s == 1 then -- gradient left to right
    for i=0,15 do
      screen.level(i)
      screen.rect(i*8,0,i*8+8,64)
      screen.fill()
    end
  elseif s == 2 then -- gradient right to left
    for i=0,15 do
      screen.level(15-i)
      screen.rect(i*8,0,i*8+8,64)
      screen.fill()
    end
  elseif s == 3 then -- gradient down
    for i=0,15 do
      screen.level(i)
      screen.rect(0,i*4,128,i*4+4)
      screen.fill()
    end
  elseif s == 4 then -- gradient up
    for i=0,15 do
      screen.level(15-i)
      screen.rect(0,i*4,128,i*4+4)
      screen.fill()
    end
  elseif s >= 5 and s <= 20 then -- full screen brightness patches
    screen.level(15-s+5)
    screen.rect(0,0,128,64)
    screen.fill()
  elseif s == 21 then -- alternating vertical lines
    screen.level(0)
    screen.rect(0,0,128,64)
    screen.fill()
    screen.level(15)
    for i=0,128,2 do
      screen.move(i,0)
      screen.line_rel(0,64)
      screen.stroke()
    end
  elseif s == 22 then -- alternating horizontal lines
    screen.level(0)
    screen.rect(0,0,128,64)
    screen.fill()
    screen.level(15)
    for i=0,64,2 do
      screen.move(0,i)
      screen.line_rel(128,0)
      screen.stroke()
    end
  elseif s >= 23 then -- flicker
    flicker = -1 * flicker + 1
    screen.level((15-s+23)*flicker)
    screen.rect(0,0,128,64)
    screen.fill()
  end
end


re = metro.init() -- screen refresh
re.time = 1.0 / refreshRate
re.event = function()
  redraw()
end
re:start()


-- CLEANUP!
function cleanup ()
 print("goodbye")
end