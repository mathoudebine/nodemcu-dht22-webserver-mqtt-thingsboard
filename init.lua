-- 5 sec. delay before running main program to be able to reflash in case of hung/reboot loops
-- SDK 2.2.1 minimum !
function startup()
    dofile('main.lua')
end
print ("Init.lua started : 5 sec. delay before running main program")
tmr.create():alarm(5000, tmr.ALARM_SINGLE, startup)