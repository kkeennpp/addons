_addon.name = 'mules'
_addon.version = '1'
_addon.author = 'Amaiya'

require('coroutine')

windower.register_event('load', function()
	coroutine.sleep(5)
	cycle_mules()
end)

function cycle_mules()
    mule_number = 0
	repeat
		windower.send_command('setkey up down')
		coroutine.sleep(.1)
		windower.send_command('setkey up up')
		coroutine.sleep(.2)
		windower.send_command('setkey enter down')
		coroutine.sleep(.1)
		windower.send_command('setkey enter up')
		coroutine.sleep(.2)
		windower.send_command('setkey enter down')
		coroutine.sleep(.1)
		windower.send_command('setkey enter up')
		coroutine.sleep(22)
		windower.send_command('input /logout')
		coroutine.sleep(10)
		mule_number = mule_number + 1
    until mule_number == 14
	
	windower.send_command('setkey up down')
	coroutine.sleep(.1)
	windower.send_command('setkey up up')
	coroutine.sleep(.2)
	windower.send_command('setkey enter down')
	coroutine.sleep(.1)
	windower.send_command('setkey enter up')
	coroutine.sleep(.2)
	windower.send_command('setkey enter down')
	coroutine.sleep(.1)
	windower.send_command('setkey enter up')

	quit()
end

function quit()
	windower.send_command('lua unload mules')
end