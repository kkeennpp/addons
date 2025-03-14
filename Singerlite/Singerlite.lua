_addon.name = 'SingerLite'
_addon.author   = 'Amaiya'
_addon.version  = '1.0.0'
_addon.commands = {'sl','singerl'}

require('logger')
require('coroutine')
packets = require('packets')
res = require('resources')

asinger = false

function autosing()
    if asinger then
        asinger = false
		log("Auto-singer stopped")
    else
        asinger = true
		log("Auto-singer started")
		coroutine.sleep(.1)
		while asinger do
			windower.send_command('input /so \"Advancing March\" <me>')
			coroutine.sleep(14)
			windower.send_command('input /so \"Victory March\" <me>')
			coroutine.sleep(14)
			windower.send_command('input /ja \"Pianissimo\" <me>; wait 1.5; input /so \"Mage\'s Ballad\" Maichan')
			coroutine.sleep(11)
			windower.send_command('input /ja \"Pianissimo\" <me>; wait 1.5; input /so \"Mage\'s\ Ballad II\" Maichan')
			coroutine.sleep(11)
			windower.send_command('input /ja \"Pianissimo\" <me>; wait 1.5; input /so \"Mage\'s Ballad\" Edwurd')
			coroutine.sleep(11)
			windower.send_command('input /ja \"Pianissimo\" <me>; wait 1.5; input /so \"Mage\'s\ Ballad II\" Edwurd')
			coroutine.sleep(11)
			windower.send_command('input /ja \"Pianissimo\" <me>; wait 1.5; input /so \"Mage\'s Ballad\" <me>')
			coroutine.sleep(11)
			windower.send_command('input /ja \"Pianissimo\" <me>; wait 1.5; input /so \"Mage\'s\ Ballad II\" <me>')
			coroutine.sleep(100)
		end
	end
end

windower.register_event('addon command', function (...)
	local args = {...}
	--log(args[1])
	--log(args[2])
	
	if args[1] == 'start' then
		autosing()
    elseif args[1] == 'r' then
	    windower.send_command('lua reload singerlite')
    elseif args[1] == 'exit' then
	    windower.send_command('lua unload singerlite')
    elseif args[1] == 'test' then
		--test()
    elseif args[1] == 'help' then
    end
end)