_addon.name = 'Aliass'
_addon.author   = 'Amaiya'
_addon.version  = '1.0.0'
_addon.commands = {'al','aliass'}

require('logger')
require('coroutine')
require('automove')
packets = require('packets')
res = require('resources')

skillup = false
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
	windower.send_command('lua unload aliass')
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
		while skillup do
			windower.send_command('input /ma \"Cure\" <me>')
			coroutine.sleep(5)
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

function autosingm4()
    if asinger then
        asinger = false
		log("Auto-singer stopped")
    else
        asinger = true
		log("Auto-singer started")
		log("Singing dummy songs on Maddyline")
		coroutine.sleep(.1)
		windower.send_command('send Maddyline //gs c dummy')
		coroutine.sleep(26)
		log("Singing NT songs1 on Maddyline")
		coroutine.sleep(.1)
		windower.send_command('send Maddyline //gs c ntsongs4')
		coroutine.sleep(450)
        asongnitro = false
		while asinger do
			if asongnitro then
				log("Singing NT songs1 on Maddyline in 5")
				coroutine.sleep(5)
				windower.send_command('send Maddyline //gs c ntsongs4')
				coroutine.sleep(430)
				asongnitro = false
			else
				log("Singing song set 1 on Maddyline in 5")
				coroutine.sleep(5)
				windower.send_command('send Maddyline //gs c songs4')
				coroutine.sleep(190)
				asongnitro = true
			end
		end
	end
end

function autosingmcc()
    if asinger then
        asinger = false
		log("Auto-singer stopped")
    else
        asinger = true
		log("Auto-singer started")
		log("Singing dummy songs on Maddyline")
		coroutine.sleep(.1)
		windower.send_command('send Maddyline //gs c dummycc')
		coroutine.sleep(32)
		log("Singing NTCC songs on Maddyline")
		coroutine.sleep(.1)
		windower.send_command('send Maddyline //gs c ntsongscc')
		coroutine.sleep(450)
        asongnitro = false
		while asinger do
			if asongnitro then
				log("Singing NTCC songs on Maddyline in 5")
				coroutine.sleep(5)
				windower.send_command('send Maddyline //gs c ntsongscc')
				coroutine.sleep(430)
				asongnitro = false
			else
				log("Singing CC songs on Maddyline in 5")
				coroutine.sleep(5)
				windower.send_command('send Maddyline //gs c songscc')
				coroutine.sleep(190)
				asongnitro = true
			end
		end
	end
end

function autosinga()
    if asinger then
        asinger = false
		log("Auto-singer stopped")
    else
        asinger = true
		log("Auto-singer started")
		log("Singing dummy songs on Amaiya")
		coroutine.sleep(.1)
		windower.send_command('send Amaiya //gs c dummy')
		coroutine.sleep(30)
		log("Singing song set 1 on Amaiya")
		coroutine.sleep(.1)
		windower.send_command('send Amaiya //gs c ntsongs')
		coroutine.sleep(600)
		while asinger do
			log("Singing NT songs on Amaiya in 5")
			coroutine.sleep(5)
			windower.send_command('send Amaiya //gs c ntsongs')
			coroutine.sleep(600)
		end
	end
end

function autosingacc()
    if asinger then
        asinger = false
		log("Auto-singer stopped")
    else
        asinger = true
		log("Auto-singer started")
		log("Singing dummy songs on Amaiya")
		coroutine.sleep(.1)
		windower.send_command('send Amaiya //gs c dummycc')
		coroutine.sleep(34)
		log("Singing song set 1 on Amaiya")
		coroutine.sleep(.1)
		windower.send_command('send Amaiya //gs c ntsongscc')
		coroutine.sleep(600)
		while asinger do
			log("Singing NT songs on Amaiya in 5")
			coroutine.sleep(5)
			windower.send_command('send Amaiya //gs c ntsongscc')
			coroutine.sleep(600)
		end
	end
end

function autoengage()
    if afighter then
        afighter = false
		log("Auto-engager stopped")
    else
        afighter = true
		log("Auto-engager started")
		log("Waiting for mob")
		while afighter do
			mobdead = true
			while mobdead do
				mob1 = windower.ffxi.get_mob_by_name('Qilin')
				if mob1.hpp > 0 then
					mobdead = false
					coroutine.sleep(.5)
					windower.send_command('input /ta \<bt\>')
					coroutine.sleep(.5)
					windower.send_command('input /a')
					coroutine.sleep(.5)
					windower.send_command('input /ja Hasso \<me\>')
				end
				coroutine.sleep(.5)
			end
			mobalive = true
			while mobalive do
				local player = windower.ffxi.get_player()
				mob1 = windower.ffxi.get_mob_by_name('Qilin')
				if mob1.hpp == 0 then
					mobalive = false
				end
				if player.vitals.tp >= 3000 then
				--if player.vitals.tp > 1000 then
					windower.send_command('input /ws \"King\'s Justice\" \<t\>')
					--windower.send_command('input /ws Resolution \<t\>')
					coroutine.sleep(.5)
				end
				coroutine.sleep(.5)
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
			if (player.vitals.tp > 1500 and player.status == 1) then
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

function invall()
	log('Sending invites all characters')
	coroutine.sleep(1)
	windower.send_command('input /pcmd add Maddyline')
	coroutine.sleep(2)
	windower.send_command('input /pcmd add Teladianium')
	coroutine.sleep(2)
	windower.send_command('input /pcmd add Morti')
	coroutine.sleep(2)
	windower.send_command('input /pcmd add Amaiya')
end



function followoff()
	log('Sending cancel follow to all characters')
	coroutine.sleep(.1)
	windower.send_command('send @all //mf stop')
end

function followa()
	log('Sending follow Amaiya to all characters')
	coroutine.sleep(.1)
	windower.send_command('send @all //mf t Amaiya')
end

function followm()
	log('Sending follow Maddyline to all characters')
	coroutine.sleep(.1)
	windower.send_command('send @all //mf t Maddyline')
end

function lotall()
	log('Sending lotall to all characters')
	coroutine.sleep(.1)
	windower.send_command('send @all //tr lotall')
end

function lotother()
	log('Sending lotall to other characters')
	coroutine.sleep(.1)
	windower.send_command('send @others //tr lotall')
end

function passall()
	log('Sending passall to all characters')
	coroutine.sleep(.1)
	windower.send_command('send @all //tr passall')
end

function passother()
	log('Sending passall to other characters')
	coroutine.sleep(.1)
	windower.send_command('send @others //tr passall')
end

function diaall()
	log('Sending dia to all characters')
    local mob = windower.ffxi.get_mob_by_target('t')
	coroutine.sleep(.1)
	windower.send_command('send @all /ma dia ' .. tostring(mob.id))
end

function dispelall()
	log('Sending dispel to all characters')
    local mob = windower.ffxi.get_mob_by_target('t')
	coroutine.sleep(.1)
	windower.send_command('send @all /ma dispel ' .. tostring(mob.id))
end

function mdia3(target_id)
	log('Sending dia III to Maddyline')
    local mob = windower.ffxi.get_mob_by_target('t')
	coroutine.sleep(.1)
	windower.send_command('send Maddyline /ma \\"Dia III\\" ' .. tostring(mob.id))
end

function msilence(target_id)
	log('Sending silence to Maddyline')
    local mob = windower.ffxi.get_mob_by_target('t')
	coroutine.sleep(.1)
	windower.send_command('send Maddyline /ma \\"Silence\\" ' .. tostring(mob.id))
end

function msleep(target_id)
	log('Sending sleep II to Maddyline')
    local mob = windower.ffxi.get_mob_by_target('t')
	coroutine.sleep(.1)
	windower.send_command('send Maddyline /ma \\"Sleep II\\" ' .. tostring(mob.id))
end

function msleepga(target_id)
	log('Sending sleepga to Maddyline')
    local mob = windower.ffxi.get_mob_by_target('t')
	coroutine.sleep(.1)
	windower.send_command('send Maddyline /ma \\"Sleepga\\" ' .. tostring(mob.id))
end

function mdispel()
	log('Sending dispel to Maddyline')
    local mob = windower.ffxi.get_mob_by_target('t')
	coroutine.sleep(.1)
	windower.send_command('send Maddyline /ma \\"Dispel\\" ' .. tostring(mob.id))
end

function mdistract()
	log('Sending distract III to Maddyline')
    local mob = windower.ffxi.get_mob_by_target('t')
	coroutine.sleep(.1)
	windower.send_command('send Maddyline /ma \\"Distract III\\" ' .. tostring(mob.id))
end

function mfrazzle()
	log('Sending frazzle III to Maddyline')
    local mob = windower.ffxi.get_mob_by_target('t')
	coroutine.sleep(.1)
	windower.send_command('send Maddyline /ma \\"Frazzle III\\" ' .. tostring(mob.id))
end

function mphalanx()
	log('Sending Phalanx II to Maddyline')
	windower.send_command('gs equip sets.Midcast.phx')
	coroutine.sleep(.1)
	windower.send_command('send Maddyline /ma \\"Phalanx II\\" Amaiya')
end

function mdebuff()
	log('Sending cast all debuffs with Maddyline')
    local mob = windower.ffxi.get_mob_by_target('t')
	coroutine.sleep(.1)
	windower.send_command('send Maddyline /ma \\"Frazzle III\\" ' .. tostring(mob.id))
	coroutine.sleep(4)
	windower.send_command('send Maddyline /ma \\"Dia III\\" ' .. tostring(mob.id))
	coroutine.sleep(4)
	windower.send_command('send Maddyline /ma \\"Slow II\\" ' .. tostring(mob.id))
	coroutine.sleep(4)
	windower.send_command('send Maddyline /ma \\"Paralyze II\\" ' .. tostring(mob.id))
	coroutine.sleep(4)
	windower.send_command('send Maddyline /ma \\"Distract III\\" ' .. tostring(mob.id))
end

function warp()
	log("Equiping warp ring and warping")
	coroutine.sleep(.1)
	windower.send_command('input /equip ring2 \\"Warp Ring\\"')
	coroutine.sleep(1)
	windower.send_command('gs disable ring2')
	coroutine.sleep(11)
	windower.send_command('input /item \\"Warp Ring\\" <me>')
	coroutine.sleep(1)
	windower.send_command('gs enable ring2')
end

function warpall()
	log("Equiping warp ring and warping all characters")
	coroutine.sleep(.1)
	windower.send_command('send @all /equip ring2 \\"Warp Ring\\"')
	coroutine.sleep(1)
	windower.send_command('send @all //gs disable ring2')
	coroutine.sleep(11)
	windower.send_command('send @all /item \\"Warp Ring\\" <me>')
	coroutine.sleep(1)
	windower.send_command('send @all //gs enable ring2')
end

function warpholla()
	log("Equiping holla ring and telaporting all characters")
	coroutine.sleep(.1)
	windower.send_command('send @all /equip ring2 \\"Dimensional Ring (Holla)\\"')
	coroutine.sleep(1)
	windower.send_command('send @all //gs disable ring2')
	coroutine.sleep(11)
	windower.send_command('send @all /item \\"Dimensional Ring (Holla)\\" <me>')
	coroutine.sleep(1)
	windower.send_command('send @all //gs enable ring2')
end

function expring()
	log("Equiping exp ring all characters")
	coroutine.sleep(.1)
	windower.send_command('send @all /equip ring2 \\"Echad Ring\\"')
	coroutine.sleep(1)
	windower.send_command('send @all //gs disable ring2')
	coroutine.sleep(11)
	windower.send_command('send @all /item \\"Echad Ring\\" <me>')
	coroutine.sleep(1)
	windower.send_command('send @all //gs enable ring2')
end

function abrdstart()
	log("Singing dummy songs on Amaiya")
	coroutine.sleep(.1)
	windower.send_command('send Amaiya //gs c dummy')
	coroutine.sleep(26)
	log("Singing song set 1 on Amaiya")
	coroutine.sleep(.1)
	windower.send_command('send Amaiya //gs c ntsongs')
end

function asing0()
	log("Singing dummy songs on Amaiya")
	coroutine.sleep(.1)
	windower.send_command('send Amaiya //gs c dummy')
end

function asing1()
	log("Singing song set 1 on Amaiya")
	coroutine.sleep(.1)
	windower.send_command('send Amaiya //gs c songs')
end

function asing1n()
	log("Singing song set 1 on Amaiya")
	coroutine.sleep(.1)
	windower.send_command('send Amaiya //gs c ntsongs')
end

function asing2()
	log("Singing song set 2 on Amaiya")
	coroutine.sleep(.1)
	windower.send_command('send Amaiya //gs c songs2')
end

function asing2n()
	log("Singing song set 2 on Amaiya")
	coroutine.sleep(.1)
	windower.send_command('send Amaiya //gs c ntsongs2')
end

function asing3()
	log("Singing song set 3 on Amaiya")
	coroutine.sleep(.1)
	windower.send_command('send Amaiya //gs c songs3')
end

function asing4()
	log("Singing song set 4 on Amaiya")
	coroutine.sleep(.1)
	windower.send_command('send Amaiya //gs c songs4')
end

function asingcn()
	log("Singing cait songs on Amaiya")
	coroutine.sleep(.1)
	windower.send_command('send Amaiya //gs c ntcait')
end

function asingsleep()
	log('Sending Horde Lullaby to Amaiya')
    local mob = windower.ffxi.get_mob_by_target('t')
	coroutine.sleep(.1)
	windower.send_command('send Amaiya /ma \\"Horde Lullaby II\\" ' .. tostring(mob.id))
end

function mbrdstart()
	log("Singing dummy songs on Maddyline")
	coroutine.sleep(.1)
	windower.send_command('send Maddyline //gs c dummy')
	coroutine.sleep(24)
	log("Singing song set 1 on Maddyline")
	coroutine.sleep(.1)
	windower.send_command('send Maddyline //gs c ntsongs')
end

function msing0()
	log("Singing dummy songs on Maddyline")
	coroutine.sleep(.1)
	windower.send_command('send Maddyline //gs c dummy')
end

function msing1()
	log("Singing song set 1 on Maddyline")
	coroutine.sleep(.1)
	windower.send_command('send Maddyline //gs c songs')
end

function msing1n()
	log("Singing song set 1 on Maddyline")
	coroutine.sleep(.1)
	windower.send_command('send Maddyline //gs c ntsongs')
end

function msing2()
	log("Singing song set 2 on Maddyline")
	coroutine.sleep(.1)
	windower.send_command('send Maddyline //gs c songs2')
end

function msing2n()
	log("Singing song set 2 on Maddyline")
	coroutine.sleep(.1)
	windower.send_command('send Maddyline //gs c ntsongs2')
end

function msing3()
	log("Singing song set 3 on Maddyline")
	coroutine.sleep(.1)
	windower.send_command('send Maddyline //gs c songs3')
end

function msing4()
	log("Singing song set 4 on Maddyline")
	coroutine.sleep(.1)
	windower.send_command('send Maddyline //gs c songs4')
end

function msingsleep()
	log('Sending Horde Lullaby to Maddyline')
    local mob = windower.ffxi.get_mob_by_target('t')
	coroutine.sleep(.1)
	windower.send_command('send Maddyline /ma \\"Horde Lullaby II\\" ' .. tostring(mob.id))
end

function test()
	local me = windower.ffxi.get_mob_by_target('me')
	log(me.x, me.y, me.z)
end

windower.register_event('addon command', function (...)
	local args = {...}
	--log(args[1])
	--log(args[2])
	
	if args[1] == 'lot' then
		if args[2] == 'other' then
			lotother()
		else
			lotall()
		end
    elseif args[1] == 'pass' then
		if args[2] == 'other' then
			passother()
		else
			passall()
		end
    elseif args[1] == 'follow' then
		if args[2] == 'a' then
			followa()
		elseif args[2] == 'm' then
			followm()
		elseif args[2] == 'off' then
			followoff()
		else
			followa()
		end
    elseif args[1] == 'warp' then
		warp()
    elseif args[1] == 'warpall' then
		if args[2] == 'h' then
			warpholla()
		else
			warpall()
		end
    elseif args[1] == 'exp' then
		expring()
    elseif args[1] == 'm' then
		if args[2] == 'dia' then
			mdia3()
		elseif args[2] == 'dispel' then
			mdispel()
		elseif args[2] == 'dist' then
			mdistract()
		elseif args[2] == 'fraz' then
			mfrazzle()
		elseif args[2] == 'sleep' then
			msleep()
		elseif args[2] == 'sleepga' then
			msleepga()
		elseif args[2] == 'sil' then
			msilence()
		elseif args[2] == 'phx' then
			mphalanx()
		elseif args[2] == 'debuff' then
			mdebuff()
		end
	elseif args[1] == 'sing' then
		if args[2] == 'a0' then
			asing0()
		elseif args[2] == 'a1' then
			asing1()
		elseif args[2] == 'a1n' then
			asing1n()
		elseif args[2] == 'a2' then
			asing2()
		elseif args[2] == 'a2n' then
			asing2n()
		elseif args[2] == 'a3' then
			asing3()
		elseif args[2] == 'a4' then
			asing4()
		elseif args[2] == 'acn' then
			asingcn()
		elseif args[2] == 'as' then
			asingsleep()
		elseif args[2] == 'aa' then
			autosinga()
		elseif args[2] == 'aacc' then
			autosingacc()
		elseif args[2] == 'astart' then
			abrdstart()
		elseif args[2] == 'm0' then
			msing0()
		elseif args[2] == 'm1' then
			msing1()
		elseif args[2] == 'm1n' then
			msing1n()
		elseif args[2] == 'm2' then
			msing2()
		elseif args[2] == 'm2n' then
			msing2n()
		elseif args[2] == 'm3' then
			msing3()
		elseif args[2] == 'm4' then
			msing4()
		elseif args[2] == 'ms' then
			msingsleep()
		elseif args[2] == 'mstart' then
			mbrdstart()
		elseif args[2] == 'ma4' then
			autosingm4()
		elseif args[2] == 'macc' then
			autosingmcc()
		end
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
		else
			skillup = false
			log('Skillup stopped')
		end
    elseif args[1] == 'zeni' then
		zeni()
    elseif args[1] == 'autoa' then
		autoengage()
    elseif args[1] == 'aws' then
		autows()
    elseif args[1] == 'dia' then
		diaall()
    elseif args[1] == 'dispel' then
		dispelall()
    elseif args[1] == 'inv' then
		if args[2] == 'all' then
			invall()
		end
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