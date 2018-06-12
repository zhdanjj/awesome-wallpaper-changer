# Awesome WM wallpaper changer
Randomly changes wallpaper on click on root window and with timer.

## Dependences
Awesome WM => 4.2

## Installing
Make `git clone`  in directory where `rc.lua` is located. Then add to the end of `rc.lua` following lines:
```lua
require('awesome-wallpaper-changer').start({
	path = '~/pics/wallpapers/',
	show_notify = true,
	timeout = 60*15,
	change_on_click = true
})
```

## Options
Default values are shown above.
* `path` - path to images, plugin will not use images from subdirectories
* `show_notify` -  show alert when wallpaper has been changed
* `timeout` - how often to change in seconds. If set to 0 disables
* `change_on_click` - whether to change background on click on root window

