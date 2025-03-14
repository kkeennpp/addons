_addon.name = 'Alias_lite'
_addon.author   = 'Amaiya'
_addon.version  = '1.0.0'
_addon.commands = {'al','aliass'}

require('logger')
require('coroutine')
--require('automove')
packets = require('packets')
res = require('resources')

skillup = false
craftgear = false
picture = false
asinger = false
afighter = false
aws = false
running = false

windower.register_event('zone change', function(new_id, old_id)
    local zone_info = windower.ffxi.get_info()
    if zone_info ~= nil then
        if zone_info.zone == 131 then
            quit()
        end
		if skillup then
			skillup = false
			log('Healing skillup stopped')
		elseif picture then
			picture = false
			log('Zeni pictures stopping')
		elseif asinger then
			asinger = false
			log("Auto-singer stopped")
		end
    end
end)

function quit()
	windower.send_command('lua unload aliass_lite')
end

function scraft(ammt)
    if skillup then
        skillup = false
		log('Crafting stopped')
    else
        skillup = true
		log('Crafting '..ammt..' times //al craft to stop')
		craftcount = 0
		while skillup do
			windower.send_command('input /lastsynth')
			coroutine.sleep(16)
			craftcount = craftcount + 1
			log(craftcount.." of "..ammt.." completed")
			if craftcount >= ammt then
				skillup = false
				log('Crafting completed')
			end
			coroutine.sleep(6)
		end
    end
end

function sheal()
    if skillup then
        skillup = false
		log('Healing skillup stopped')
    else
        skillup = true
		log('Healing skillup starting //al skill to stop')
		while skillup do
			windower.send_command('input /ma \"Cure\" <t>')
			coroutine.sleep(5)
		end
    end
end

function sblu()
    if skillup then
        skillup = false
		log('Bluemagic skillup stopped')
    else
        skillup = true
		log('Bluemagic skillup starting //al skill to stop')
		while skillup do
			windower.send_command('input /ma \"Pollen\" <me>')
			coroutine.sleep(5)
		end
    end
end

function sblu2()
    if skillup then
        skillup = false
		log('Bluemagic skillup stopped')
    else
        skillup = true
		log('Bluemagic skillup starting //al skill to stop')
		while skillup do
			windower.send_command('input /ma \"Wild Carrot\" <t>')
			coroutine.sleep(6)
		end
    end
end

function sgeo()
    if skillup then
        skillup = false
		log('Geomancy skillup stopped')
    else
        skillup = true
		log('Geomancy skillup starting //al skill to stop')
		while skillup do
			windower.send_command('input /ma \"indi-poison\" <me>')
			coroutine.sleep(8.5)
		end
    end
end

function senh()
    if skillup then
        skillup = false
		log('Enhancing skillup stopped')
    else
        skillup = true
		log('Enhancing skillup starting //al skill to stop')
		while skillup do
			--windower.send_command('input /ma \"Barfire\" <me>')
			--coroutine.sleep(5)
			--windower.send_command('input /ma \"Barblizzard\" <me>')
			--coroutine.sleep(5)
			--windower.send_command('input /ma \"Baraero\" <me>')
			--coroutine.sleep(5)
			--windower.send_command('input /ma \"Barstone\" <me>')
			windower.send_command('input /ma \"Protect\" <t>')
			coroutine.sleep(5)
		end
    end
end

function ssing()
    if skillup then
        skillup = false
		log('Singing skillup stopped')
    else
        skillup = true
		log('Singing skillup starting //al skill to stop')
		sst = 1
		while skillup do
			if sst == 1 then
				windower.send_command('input /ma \"Fire Carol\" <me>')
				coroutine.sleep(9)
				sst = 2
			elseif sst == 2 then
				windower.send_command('input /ma \"Ice Carol\" <me>')
				coroutine.sleep(9)
				sst = 3
			elseif sst == 3 then
				windower.send_command('input /ma \"Wind Carol\" <me>')
				coroutine.sleep(9)
				sst = 1
			end
		end
    end
end

function ssmn()
    if skillup then
        skillup = false
		log('Summoning skillup stopped')
    else
        skillup = true
		log('Summoning skillup starting //al skill to stop')
		while skillup do
			windower.send_command('input /ma \"Carbuncle\" <me>')
			coroutine.sleep(10)
			windower.send_command('input /ja \"Release\" <me>')
			coroutine.sleep(1)
		end
    end
end

function spup()
    if skillup then
        skillup = false
		log('Automaton skillup stopped')
    else
        skillup = true
		log('Automaton skillup starting //al skill to stop')
		sst = 1
		while skillup do
			--windower.send_command('input /ja \"Deploy\" <t>')
			coroutine.sleep(1)
			--windower.send_command('input /ja \"Retrieve\" <me>')
			coroutine.sleep(2)
			sst = sst + 1
			if sst == 3 then
				windower.send_command('input /ja \"Thunder Maneuver\" <me>')
				--windower.send_command('input /ja \"Light Maneuver\" <me>')
			elseif sst == 4 then
				windower.send_command('input /ja \"Wind Maneuver\" <me>')
				--windower.send_command('input /ja \"Dark Maneuver\" <me>')
			elseif sst == 5 then
				windower.send_command('input /ja \"Water Maneuver\" <me>')
				sst = 1
			end
			coroutine.sleep(13)
		end
    end
end

function srng()
    if skillup then
        skillup = false
		log('Ranged skillup stopped')
    else
        skillup = true
		log('Ranged skillup starting //al skill to stop')
		while skillup do
			windower.send_command('input /ra <t>')
			coroutine.sleep(4)
		end
    end
end

function zeni()
    if picture then
        picture = false
		log('Zeni pictures stopping')
		coroutine.sleep(.1)
		windower.send_command('gs enable range')
		coroutine.sleep(.1)
		windower.send_command('gs enable ammo')
    else
        picture = true
		local picnumber = 0
		log('Zeni pictures starting //al zeni to stop')
		windower.send_command('input /equip range \"Soultrapper 2000\"')
		coroutine.sleep(.1)
		windower.send_command('gs disable range')
		coroutine.sleep(.1)
		windower.send_command('gs disable ammo')
		coroutine.sleep(12)
		while picture do
			windower.send_command('input /equip ammo \"Blank Soulplate\"')
			coroutine.sleep(2)
			windower.send_command('input /item \"Soultrapper 2000\" <t>')
			coroutine.sleep(31)
			picnumber = picnumber + 1
			log('picture number - ' .. picnumber)
			if picnumber == 48 then
				picture = false
				coroutine.sleep(.1)
				windower.send_command('gs enable range')
				coroutine.sleep(.1)
				windower.send_command('gs enable ammo')
			end
		end
    end
end

function autows()
    if aws then
        aws = false
		log("Auto-WS stopped")
    else
        aws = true
		log("Auto-WS started")
		while aws do
			local player = windower.ffxi.get_player()
			--if player.vitals.tp >= 3000 then
			if (player.vitals.tp > 2000 and player.status == 1) then
				--windower.send_command('input /ws \"Detonator\" \<t\>')
				--windower.send_command('input /ws \"Wildfire\" \<t\>')
				--windower.send_command('input /ws \"Savage Blade\" \<t\>')
				--windower.send_command('input /ws \"Mordant Rime\" \<t\>')
				windower.send_command('input /ws \"Leaden Salute\" \<t\>')
				--windower.send_command('input /ws \"King\'s Justice\" \<t\>')
			end
			coroutine.sleep(.8)
		end
	end
end

function warp()
	log("Equiping warp ring and warping")
	coroutine.sleep(.1)
	windower.send_command('input /equip ring2 \"Warp Ring\"')
	coroutine.sleep(1)
	windower.send_command('gs disable ring2')
	coroutine.sleep(11)
	windower.send_command('input /item \"Warp Ring\" <me>')
	coroutine.sleep(1)
	windower.send_command('gs enable ring2')
end

function test()
	local me = windower.ffxi.get_mob_by_target('me')
	log(me.x, me.y, me.z)
end

windower.register_event('addon command', function (...)
	local args = {...}
	--log(args[1])
	--log(args[2])
	
	if args[1] == 'warp' then
		warp()
    elseif args[1] == 'skill' then
		if args[2] == 'enh' then
			senh()
		elseif args[2] == 'heal' then
			sheal()
		elseif args[2] == 'blu' then
			sblu()
		elseif args[2] == 'blu2' then
			sblu2()
		elseif args[2] == 'geo' then
			sgeo()
		elseif args[2] == 'sing' then
			ssing()
		elseif args[2] == 'smn' then
			ssmn()
		elseif args[2] == 'pup' then
			spup()
		elseif args[2] == 'rng' then
			srng()
		elseif args[2] == 'craft' then
			if tonumber(args[3]) ~= nil then
				scraft(tonumber(args[3]))
			else
				scraft(12)
			end
		else
			skillup = false
			log('Skillup stopped')
		end
	elseif args[1] == 'craft' then
		if tonumber(args[2]) ~= nil then
			scraft(tonumber(args[2]))
		else
			scraft(12)
		end
    elseif args[1] == 'ws' then
		if args[2] == 'cata' then
			wscata()
		end
    elseif args[1] == 'zeni' then
		zeni()
    elseif args[1] == 'aws' then
		autows()
    elseif args[1] == 'r' then
	    windower.send_command('lua reload aliass')
    elseif args[1] == 'test' then
		test()
    elseif args[1] == 'help' then
        log('Aliass:  /aliass;/al  Valid commands are:')
        log('  lotall     : Sends lotall to all characters')
        log('  passall    : Sends passall to all characters')
        log('  asing 0-3  : Sings dummy through song set3 on Amaiya')
        log('  msing 0-3  : Sings dummy through song set3 on Maddyline')
    end
end)