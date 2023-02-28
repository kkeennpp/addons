_addon.author   = 'Amaiya'
_addon.version  = '1.3.0'
_addon.commands = {'beadit'}

--1.0.0		initial working release
--1.1.0		added auto engage for dragons
--1.2.0		added bead counter
--1.3.0		added death sequence and 4th trust

require('logger')
require('coroutine')
config = require('config')
packets = require('packets')
res = require('resources')
texts = require('texts')

dragonQuetz = false
dragonNaga = false
dragonAzi = false
beadbuff = false
running = false
warping = false

current_beads = 0
starting_beads = 0
gained_beads = 0
player_deaths = 0

default = {
	active = true,
    box = {
        pos={x=400,y=400},
        text={font='Segoe UI Symbol',size=10},
        bg={alpha=150,red=0,green=0,blue=0},
        flags={draggable=true},
        padding=4
    }
}

settings = config.load(default)

function updatedisplay()
	local str = 'Beadit Counter'
	str = str..'\n\nCurrent Beads: '..current_beads
	str = str..'\nGained Beads: '..gained_beads

	if not player_deaths == 0 then
		str = str..'\nYour Death Count: '..player_deaths
	end

	if settings.active then
		str = str..'\n\nCurrent status: running'
	else
		str = str..'\n\nCurrent status: paused'
	end

    return str
end

window = texts.new(updatedisplay(),settings.box,settings)
window:show()

windower.register_event('load', function()
    windower.add_to_chat(200,'Welcome to Beadit! To see a list of commands, type //beadit help, but there are none')
    windower.add_to_chat(200,'Common commands: there are no commands, why do you need commands?')
    windower.add_to_chat(200,'Oh wait, I forgot about quit, you can type //beadit quit')
    windower.add_to_chat(200,'WARNING: Do not leave this loaded, it will do stuff when you zone!')
	
	coroutine.sleep(5)
	log("Initialize...")
	get_beads()

    local zone_info = windower.ffxi.get_info()
    if zone_info ~= nil then
        if zone_info.zone == 131 then
            quit()
        elseif zone_info.zone == 252 then
			coroutine.sleep(5)
			log("Currently in Norg, loading N.G. subroutine...")
			zonenorg()
        elseif zone_info.zone == 102 then
			coroutine.sleep(5)
			log("Currently in La Theine Plateau, loading L.T.P. subroutine...")
			zonelatheine()
        elseif zone_info.zone == 126 then
			coroutine.sleep(5)
			log("Currently in Qufim Island, loading Q.I. subroutine...")
			zonequfim()
        elseif zone_info.zone == 25 then
			coroutine.sleep(5)
			log("Currently in Misareaux Coast, loading M.C. subroutine...")
			zonemisa()
        elseif zone_info.zone == 288 then
			coroutine.sleep(5)
			log("Currently in Escha - Zi'Tah, loading E.Z. subroutine...")
			zonezitah()
        elseif zone_info.zone == 289 then
			coroutine.sleep(5)
			log("Currently in Escha - Ru'Aun, loading E.R. subroutine...")
			zoneruaun()
        elseif zone_info.zone == 291 then
			coroutine.sleep(5)
			log("Currently in Reisenjima, loading R.G. subroutine...")
			zonereisen()
		else
			coroutine.sleep(5)
			log("Current zone not identified...")
			coroutine.sleep(1)
			log("Please proceed to the current dragon entrance...")
        end
	else
		coroutine.sleep(5)
		log("Current zone not identified...")
		coroutine.sleep(1)
		log("Please proceed to the current dragon entrance...")
    end
end)

function quit()
	log("Now exiting beadit lua")
	coroutine.sleep(2)
	windower.send_command('lua unload beadit')
end

windower.register_event('logout', function()
    quit()
end)

windower.register_event('gain buff', function(buff_id)
    if buff_id == 603 then
		beadbuff = true
		log('Elvorseal found')
	end
end)

windower.register_event('lose buff', function(buff_id)
    if buff_id == 603 then
		beadbuff = false
		coroutine.schedule(get_beads,3)
	end
end)

windower.register_event('zone change', function()
    local zone_info = windower.ffxi.get_info()
    if zone_info ~= nil then
        if zone_info.zone == 131 then
            --windower.send_ipc_message('bi stop')
            quit()
        elseif zone_info.mog_house == true then
			--
        elseif zone_info.zone == 288 then
			coroutine.sleep(10)
			log("Welcome to Escha - Zi'Tah")
			dragonQuetz = false
			dragonNaga = false
			dragonAzi = true
			zonezitah()
        elseif zone_info.zone == 289 then
			coroutine.sleep(10)
			log("Welcome to Escha - Ru'Aun")
			dragonQuetz = false
			dragonNaga = true
			dragonAzi = false
			zoneruaun()
        elseif zone_info.zone == 291 then
			coroutine.sleep(10)
			log("Welcome to Reisenjima")
			dragonQuetz = true
			dragonNaga = false
			dragonAzi = false
			zonereisen()
        elseif zone_info.zone == 252 then
			coroutine.sleep(10)
			log("Welcome to Norg")
			zonenorg()
        elseif zone_info.zone == 102 then
			coroutine.sleep(10)
			log("Welcome to La Theine Plateau")
			zonelatheine()
        elseif zone_info.zone == 126 then
			coroutine.sleep(10)
			log("Welcome to Qufim Island")
			zonequfim()
        elseif zone_info.zone == 25 then
			coroutine.sleep(10)
			log("Welcome to Misareaux Coast")
			zonemisa()
        end
    end
end)

function zonezitah()
	coroutine.sleep(50)
	local me = windower.ffxi.get_mob_by_target('me')
	local target = windower.ffxi.get_mob_by_name('Affi')
	windower.ffxi.run(-355.91 - me.x, -169.71 - me.y, 0.20 - me.z)
	running = true

	while running do
		if(math.sqrt(target.distance)) < 4 then
			running = false
		end
		coroutine.sleep(.05)
		target = windower.ffxi.get_mob_by_name('Affi')
	end
	windower.ffxi.run(false)
	coroutine.sleep(5)
	
	dragonbuff = false
	while not dragonbuff do
		log('Obtaining Elvorseal')
		--windower.send_command('/targetnpc Affi')
		npc = windower.ffxi.get_mob_by_name('Affi')
		if npc then
			local p = packets.new('outgoing', 0x01A, {
				["Target"] = npc.id,
				["Target Index"] = npc.index,
				["Category"] = 0
			})
			packets.inject(p)
		end
		coroutine.sleep(8)
	
		windower.send_command('setkey down down')
		coroutine.sleep(.05)
		windower.send_command('setkey down up')
		coroutine.sleep(.5)
	
		windower.send_command('setkey enter down')
		coroutine.sleep(.05)
		windower.send_command('setkey enter up')
		coroutine.sleep(5)
		
		if beadbuff then
			dragonbuff = true
		else
			windower.send_command('setkey escape down')
			coroutine.sleep(.05)
			windower.send_command('setkey escape up')
			log('Did not obtain elvorseal, retry in 30 sec')
			coroutine.sleep(30)
		end
	end
	
	windower.send_command('setkey up down')
	coroutine.sleep(.05)
	windower.send_command('setkey up up')
	coroutine.sleep(.5)
	
	windower.send_command('setkey enter down')
	coroutine.sleep(.05)
	windower.send_command('setkey enter up')
	coroutine.sleep(30)

	--drag wait
	local me = windower.ffxi.get_mob_by_target('me')
	windower.ffxi.run(9.88 - me.x, 44.71 - me.y, 0.22 - me.z)
	coroutine.sleep(3.5)
	windower.ffxi.run(false)
	calltrusts()
	coroutine.sleep(25)

	log('Waiting for dragon pop...')
	
	dragonname = windower.ffxi.get_mob_by_name('Azi Dahaka')
	dragonDead = true
	while dragonDead do
		if dragonname.hpp > 0 then
			dragonDead = false
		end
		coroutine.sleep(.5)
		dragonname = windower.ffxi.get_mob_by_name('Azi Dahaka')
	end

	log('Dragon popped...')
	coroutine.sleep(1)
	fight_dragon()

	dragonname = windower.ffxi.get_mob_by_name('Azi Dahaka')
	dragonAlive = true
	while dragonAlive do
		if dragonname.hpp == 0 then
			dragonAlive = false
		end
		coroutine.sleep(1)
		dragonname = windower.ffxi.get_mob_by_name('Azi Dahaka')
	end
	
	log('Dragon died, starting exit sequence...')
	check_if_dead()
	coroutine.sleep(20)
	log('Now warping...')
	windower.send_command('input /equip ring2 \\"Warp Ring\\"')
	coroutine.sleep(1)
	windower.send_command('gs disable ring2')
	coroutine.sleep(11)
	windower.send_command('input /item \\"Warp Ring\\" <me>')
	
    local zone_info = windower.ffxi.get_info()
	warping = true

	while warping do
		if zone_info.zone == 252 then
			warping = false
		end
		coroutine.sleep(5)
		windower.send_command('input /item \\"Warp Ring\\" <me>')
		zone_info = windower.ffxi.get_info()
	end
	
	coroutine.sleep(1)
	windower.send_command('gs enable ring2')
end

function zoneruaun()
	coroutine.sleep(50)
	local me = windower.ffxi.get_mob_by_target('me')
	local target = windower.ffxi.get_mob_by_name('Dremi')
	windower.ffxi.run(-11.00 - me.x, -461.05 - me.y, -34.00 - me.z)
	running = true

	while running do
		if(math.sqrt(target.distance)) < 4 then
			running = false
		end
		coroutine.sleep(.05)
		target = windower.ffxi.get_mob_by_name('Dremi')
	end
	windower.ffxi.run(false)
	coroutine.sleep(5)
	
	dragonbuff = false
	while not dragonbuff do
		log('Obtaining Elvorseal')
		--windower.send_command('/targetnpc Dremi')
		npc = windower.ffxi.get_mob_by_name('Dremi')
		if npc then
			local p = packets.new('outgoing', 0x01A, {
				["Target"] = npc.id,
				["Target Index"] = npc.index,
				["Category"] = 0
			})
			packets.inject(p)
		end
		coroutine.sleep(8)
	
		windower.send_command('setkey down down')
		coroutine.sleep(.05)
		windower.send_command('setkey down up')
		coroutine.sleep(.5)
	
		windower.send_command('setkey enter down')
		coroutine.sleep(.05)
		windower.send_command('setkey enter up')
		coroutine.sleep(5)
		
		if beadbuff then
			dragonbuff = true
		else
			windower.send_command('setkey escape down')
			coroutine.sleep(.05)
			windower.send_command('setkey escape up')
			log('Did not obtain elvorseal, retry in 30 sec')
			coroutine.sleep(30)
		end
	end
	
	windower.send_command('setkey up down')
	coroutine.sleep(.05)
	windower.send_command('setkey up up')
	coroutine.sleep(.5)
	
	windower.send_command('setkey enter down')
	coroutine.sleep(.05)
	windower.send_command('setkey enter up')
	coroutine.sleep(30)

	-- drag wait
	local me = windower.ffxi.get_mob_by_target('me')
	windower.ffxi.run(-9.44 - me.x, -217.55 - me.y, -43.60 - me.z)
	coroutine.sleep(4.5)
	windower.ffxi.run(false)
	calltrusts()
	coroutine.sleep(25)

	log('Waiting for dragon pop...')
	
	dragonname = windower.ffxi.get_mob_by_name('Naga Raja')
	dragonDead = true
	while dragonDead do
		if dragonname.hpp > 0 then
			dragonDead = false
		end
		coroutine.sleep(.5)
		dragonname = windower.ffxi.get_mob_by_name('Naga Raja')
	end

	log('Dragon popped...')
	coroutine.sleep(1)
	fight_dragon()

	dragonname = windower.ffxi.get_mob_by_name('Naga Raja')
	dragonAlive = true
	while dragonAlive do
		if dragonname.hpp == 0 then
			dragonAlive = false
		end
		coroutine.sleep(1)
		dragonname = windower.ffxi.get_mob_by_name('Naga Raja')
	end
	
	log('Dragon died, starting exit sequence...')
	check_if_dead()
	coroutine.sleep(20)
	log('Now warping...')
	windower.send_command('input /equip ring2 \\"Dimensional Ring (Holla)\\"')
	coroutine.sleep(1)
	windower.send_command('gs disable ring2')
	coroutine.sleep(11)
	windower.send_command('input /item \\"Dimensional Ring (Holla)\\" <me>')
	coroutine.sleep(1)
	windower.send_command('gs enable ring2')
end

function zonereisen()
	coroutine.sleep(50)

	dragonbuff = false
	while not dragonbuff do
		log('Obtaining Elvorseal')
		--windower.send_command('/targetnpc Shiftrix')
		npc = windower.ffxi.get_mob_by_name('Shiftrix')
		if npc then
			local p = packets.new('outgoing', 0x01A, {
				["Target"] = npc.id,
				["Target Index"] = npc.index,
				["Category"] = 0
			})
			packets.inject(p)
		end
		coroutine.sleep(8)
	
		windower.send_command('setkey down down')
		coroutine.sleep(.05)
		windower.send_command('setkey down up')
		coroutine.sleep(.5)
	
		windower.send_command('setkey enter down')
		coroutine.sleep(.05)
		windower.send_command('setkey enter up')
		coroutine.sleep(5)
		
		if beadbuff then
			dragonbuff = true
		else
			windower.send_command('setkey escape down')
			coroutine.sleep(.05)
			windower.send_command('setkey escape up')
			log('Did not obtain elvorseal, retry in 30 sec')
			coroutine.sleep(30)
		end
	end
	
	windower.send_command('setkey up down')
	coroutine.sleep(.05)
	windower.send_command('setkey up up')
	coroutine.sleep(.5)
	
	windower.send_command('setkey enter down')
	coroutine.sleep(.05)
	windower.send_command('setkey enter up')
	coroutine.sleep(30)

	-- drag wait
	local me = windower.ffxi.get_mob_by_target('me')
	windower.ffxi.run(626.35 - me.x, -955.69 - me.y, -371.50 - me.z)
	coroutine.sleep(6)
	windower.ffxi.run(false)
	calltrusts()
	coroutine.sleep(25)

	log('Waiting for dragon pop...')
	
	dragonname = windower.ffxi.get_mob_by_name('Quetzalcoatl')
	dragonDead = true
	while dragonDead do
		if dragonname.hpp > 0 then
			dragonDead = false
		end
		coroutine.sleep(.5)
		dragonname = windower.ffxi.get_mob_by_name('Quetzalcoatl')
	end

	log('Dragon popped...')
	coroutine.sleep(1)
	fight_dragon()

	dragonname = windower.ffxi.get_mob_by_name('Quetzalcoatl')
	dragonAlive = true
	while dragonAlive do
		if dragonname.hpp == 0 then
			dragonAlive = false
		end
		coroutine.sleep(1)
		dragonname = windower.ffxi.get_mob_by_name('Quetzalcoatl')
	end
	
	log('Dragon died, starting exit sequence...')
	check_if_dead()
	coroutine.sleep(20)
	log('Now warping...')
	windower.send_command('input /equip ring2 \\"Warp Ring\\"')
	coroutine.sleep(1)
	windower.send_command('gs disable ring2')
	coroutine.sleep(11)
	windower.send_command('input /item \\"Warp Ring\\" <me>')
	
    local zone_info = windower.ffxi.get_info()
	warping = true

	while warping do
		if zone_info.zone == 252 then
			warping = false
		end
		coroutine.sleep(5)
		windower.send_command('input /item \\"Warp Ring\\" <me>')
		zone_info = windower.ffxi.get_info()
	end
	
	coroutine.sleep(1)
	windower.send_command('gs enable ring2')
end

function zonenorg()
	coroutine.sleep(10)
	if current_beads == 50000 then
		settings.active = false
		window:text(updatedisplay())
		return
	else
		settings.running = true
	end

	if dragonQuetz then
		log('Last dragon was Quetz, warping to Qufim...')
		windower.send_command('sw hp Qufim')
	elseif dragonAzi then
		log('Last dragon was Azi, warping to Misareaux...')
		windower.send_command('sw hp Misareaux')
	else
		log("No dragon kill detected, manual warp required")
	end
end

function zonelatheine()
	coroutine.sleep(10)
	local me = windower.ffxi.get_mob_by_target('me')
	local target = windower.ffxi.get_mob_by_name('Dimensional Portal')
	windower.ffxi.run(420.04 - me.x, -141.64 - me.y, 19.10 - me.z)
	running = true

	while running do
		if(math.sqrt(target.distance)) < 3 then
			running = false
		end
		coroutine.sleep(.05)
		target = windower.ffxi.get_mob_by_name('Dimensional Portal')
	end
	windower.ffxi.run(false)
	coroutine.sleep(10)
	windower.send_command('sw ew enter')
end

function zonequfim()
	coroutine.sleep(10)
	local me = windower.ffxi.get_mob_by_target('me')
	windower.ffxi.run(-208.32 - me.x, 88.25 - me.y, -20.27 - me.z)
	coroutine.sleep(1.5)
	local me = windower.ffxi.get_mob_by_target('me')
	local target = windower.ffxi.get_mob_by_name('Undulating Confluence')
	windower.ffxi.run(-206.78 - me.x, 75.32 - me.y, -20.14 - me.z)
	running = true

	while running do
		if(math.sqrt(target.distance)) < 4 then
			running = false
		end
		coroutine.sleep(.05)
		target = windower.ffxi.get_mob_by_name('Undulating Confluence')
	end
	windower.ffxi.run(false)
	coroutine.sleep(10)
	windower.send_command('sw ew enter')
end

function zonemisa()
	coroutine.sleep(10)
	local me = windower.ffxi.get_mob_by_target('me')
	windower.ffxi.run(-60.75 - me.x, 571.05 - me.y, -19.81 - me.z)
	coroutine.sleep(1.5)
	local me = windower.ffxi.get_mob_by_target('me')
	local target = windower.ffxi.get_mob_by_name('Undulating Confluence')
	windower.ffxi.run(-48.60 - me.x, 568.93 - me.y, -23.31 - me.z)
	running = true

	while running do
		if(math.sqrt(target.distance)) < 4 then
			running = false
		end
		coroutine.sleep(.05)
		target = windower.ffxi.get_mob_by_name('Undulating Confluence')
	end
	windower.ffxi.run(false)
	coroutine.sleep(10)
	windower.send_command('sw ew enter')
end

function fight_dragon()
    local zone_info = windower.ffxi.get_info()
    if zone_info.zone == 288 then
		--Escha - Zi'Tah
		local me = windower.ffxi.get_mob_by_target('me')
		local target = windower.ffxi.get_mob_by_name('Azi Dahaka')
		windower.ffxi.run(target.x - me.x, target.y - me.y, target.z - me.z)
		running = true

		while running do
			if(math.sqrt(target.distance)) < 5 then
				running = false
			end
			coroutine.sleep(.05)
			target = windower.ffxi.get_mob_by_name('Azi Dahaka')
		end
		windower.ffxi.run(false)

		local p = packets.new('outgoing', 0x01A, {
			["Target"] = target.id,
			["Target Index"] = target.index,
			["Category"] = 0x02 -- Engage Monster
		})
		packets.inject(p)
    elseif zone_info.zone == 289 then
		--Escha - Ru'Aun
		local me = windower.ffxi.get_mob_by_target('me')
		local target = windower.ffxi.get_mob_by_name('Naga Raja')
		windower.ffxi.run(target.x - me.x, target.y - me.y, target.z - me.z)
		running = true

		while running do
			if(math.sqrt(target.distance)) < 5 then
				running = false
			end
			coroutine.sleep(.05)
			target = windower.ffxi.get_mob_by_name('Naga Raja')
		end
		windower.ffxi.run(false)

		local p = packets.new('outgoing', 0x01A, {
			["Target"] = target.id,
			["Target Index"] = target.index,
			["Category"] = 0x02 -- Engage Monster
		})
		packets.inject(p)
    elseif zone_info.zone == 291 then
		--Reisenjima
		local me = windower.ffxi.get_mob_by_target('me')
		local target = windower.ffxi.get_mob_by_name('Quetzalcoatl')
		windower.ffxi.run(target.x - me.x, target.y - me.y, target.z - me.z)
		running = true

		while running do
			if(math.sqrt(target.distance)) < 5 then
				running = false
			end
			coroutine.sleep(.05)
			target = windower.ffxi.get_mob_by_name('Quetzalcoatl')
		end
		windower.ffxi.run(false)

		local p = packets.new('outgoing', 0x01A, {
			["Target"] = target.id,
			["Target Index"] = target.index,
			["Category"] = 0x02 -- Engage Monster
		})
		packets.inject(p)
	end
end

function check_if_dead()
	local player = windower.ffxi.get_player()
	if player.vitals.hp == 0 then
		log('HAHAHAHA you died....')
		coroutine.sleep(5)
		log('Yay for raise 1!')
		windower.send_command('setkey enter down')
		coroutine.sleep(.05)
		windower.send_command('setkey enter up')
		coroutine.sleep(1)
		player_deaths = player_deaths + 1
	end
end

windower.register_event('incoming chunk',function(id, data, modified, injected, blocked)
	if id == 0x118 and not injected then
		local p = packets.parse('incoming', data)
		current_beads = p["Escha Beads"]

		if starting_beads == 0 then
			starting_beads = current_beads
		end
		
		gained_beads = current_beads - starting_beads
		window:text(updatedisplay())
		--log('current: '..current_beads)
		--log('starting: '..starting_beads)
		--log('gained: '..gained_beads)
	end
end)

function get_beads()
    if not windower.ffxi.get_info().logged_in then
        return
    end
    local p = packets.new('outgoing', 0x115)
    packets.inject(p)
end

function calltrusts()
	coroutine.sleep(5)
	log("Summoning trusts")
	windower.send_command('input /ma \"Kupipi\" <me>')
	coroutine.sleep(8)
	windower.send_command('input /ma \"Sylvie (UC)\" <me>')
	coroutine.sleep(8)
	windower.send_command('input /ma \"lilisette II\" <me>')
	coroutine.sleep(8)
	windower.send_command('input /ma \"Mumor\" <me>')
	--windower.send_command('input /ma \"Koru-moru\" <me>')
	--windower.send_command('input /ma \"Cornelia\" <me>')
end

windower.register_event('addon command', function (...)
	local args = {...}
	local cmd = args[1] and args[1]:lower()
	
    if S{'q','quit'}:contains(cmd) then
		quit()
    elseif args[1]:lower() == 'beads' then
		get_beads()
    elseif S{'r','reload'}:contains(cmd) then
	    windower.send_command('lua reload beadit')
    end
end)