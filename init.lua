local naughty = require("naughty")
local gears = require("gears")
local awful = require("awful")

local config = {}
local timer = nil

local function mergeTables(src1, src2)
   local dest = src1
   for i, v in pairs(src2) do
      dest[i] = v
   end
   return dest
end

local function listDirFiles(dir,filter)
   local homedir = os.getenv('HOME')
   if not filter then
       filter = function(s) return true end
   end
   dir = dir:gsub('^~/', homedir..'/')
   if dir:sub(#dir) ~= '/' then
      dir = dir..'/'
   end
   local cmd = 'ls -p1 '..dir
   local files = {}
   local output = io.popen(cmd, 'r')
   for file in output:lines() do
      if not file:match('/') and filter(file) then
         table.insert(files, dir..file)
      end
      if file:match('/') then
          local subdirfiles = listDirFiles( dir..file, filter)
          for _,v in pairs( subdirfiles ) do
             table.insert(files, v)
          end
      end
   end
   output:close()
   return files
end

local function getRandomImage()
   local images = listDirFiles(config.path)
   local index = math.random(1, #images)
   return images[index]
end

local function setWallpaper(pathToImage)
   for s in screen do
      gears.wallpaper.maximized(pathToImage, s, false)
   end
end

local function onClick()
   local filename = getRandomImage()
   setWallpaper(filename)
   if timer then
      timer:again()
   end
   if config.show_notify then
      naughty.notify({
         text = "Wallpaper changed\n"..filename,
         timeout = 1
      })
   end
end

local function setClickListener() 
   root.buttons(gears.table.join(
      root.buttons(),
      awful.button({ }, 1, onClick)
   ))
end

local function startTimer()
   timer = gears.timer {
      timeout = config.timeout,
      autostart = true,
      callback = onClick
   }
end

local function start(cfg)
   config = mergeTables({
      path = '~/pics/wallpapers/',
      show_notify = true,
      timeout = 60*15,
      change_on_click = true
   }, cfg)
   math.randomseed(os.time())
   onClick()
   if config.change_on_click then 
      setClickListener() 
   end
   if config.timeout > 0 then
      startTimer()
   end
end

return {
   start = start
}
