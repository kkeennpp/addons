_addon.author   = 'Amaiya'
_addon.version  = '1.0.0'
_addon.commands = {'bat'}

--1.0   initial working release

require('logger')
require('coroutine')
packets = require('packets')
config = require('config')
files = require('files')

default = {
    autotarget = true,
    ignorepet = true,
	highhp = false,
    petlist = S{"Squadron's Avatar","Regiment's Avatar","Squadron's Crow","Regiment's Bats","Squadron's Rabbit","Regiment's Coeurl","Squadron's Wasp",
				"Regiment's Fly","Squadron's Jagil","Regiment's Crab","Squadron's Wyvern","Regiment's Wyvern","Leader's Avatar","Commander's Avatar",
				"Leader's Hippogryph","Commander's Hippogryph","Leader's Manticore","Commander's Pet","Leader's Gnat","Commander's Gnat","Leader's Kraken",
				"Commander's Kraken","Leader's Wyvern","Commander's Wyvern","Volte's Cluster","Volte's Automaton",
    }
}

settings = config.load(default)
f = files.new('array.csv')

windower.register_event('load', function()
    windower.add_to_chat(200,'Welcome to betterautotarget! To see a list of commands, type //bat help')
    windower.add_to_chat(200,'Common commands: //bat at -- toggle on/off, //bat ip -- toggle ignorepet')
    windower.add_to_chat(200,'Current settings: autotarget - '..tostring(settings.autotarget)..', ignorepet - '..tostring(settings.ignorepet))
end)

windower.register_event('target change', function()
	--is Engaged / combat
	if windower.ffxi.get_player().status == 1 then
		if settings.autotarget == true then
			local nearest_target = Find_Nearest_Target()
			if nearest_target > 0 then
				local new_target = windower.ffxi.get_mob_by_index(nearest_target)

				log('Switching to closest mob: '..new_target.name)
				local p = packets.new('outgoing', 0x01A, {
					["Target"] = new_target.id,
					["Target Index"] = new_target.index,
					["Category"] = 0x0F -- Switch target
				})
				packets.inject(p)
			end
		end
	end
end)

function Find_Nearest_Target()
	local id_targ = -1
	local dist_targ = -1
	local marray = windower.ffxi.get_mob_array()
	--f:write('index,validtarget,name,distance,isnpc,hpp,status')

	for key,mob in pairs(marray) do
		--f:append('\n'..key..','..tostring(mob["valid_target"])..','..mob.name..','..math.sqrt(mob.distance)..','..tostring(mob.is_npc)..','..mob.hpp..','..tostring(mob.status))
		if settings.highhp then
			if mob.valid_target and mob.is_npc and (mob.status == 1) and (mob.hpp >= 90) then
				if not settings.petlist:contains(mob.name:lower()) then
					if dist_targ == -1 then
						id_targ = key
						dist_targ = math.sqrt(mob.distance)
					elseif math.sqrt(mob.distance) < dist_targ then
						id_targ = key
						dist_targ = math.sqrt(mob.distance)
					end
				end
			end
		elseif mob.valid_target and mob.is_npc and (mob.status == 1) then
			if not settings.petlist:contains(mob.name:lower()) then
				if dist_targ == -1 then
					id_targ = key
					dist_targ = math.sqrt(mob.distance)
				elseif math.sqrt(mob.distance) < dist_targ then
					id_targ = key
					dist_targ = math.sqrt(mob.distance)
				end
			end
		end
	end
	return(id_targ)
end

function quit()
	log("Now exiting betterautotarget lua")
	coroutine.sleep(2)
	windower.send_command('lua unload betterautotarget')
end

windower.register_event('addon command', function (...)
	local args = {...}
	local cmd = args[1]:lower()
	
	if args[1] == nil or args[1] == "help" then
        windower.add_to_chat(200,'Betterautotarget:  //betterautotarget;//bat  Valid commands are:')
        windower.add_to_chat(200,'  at;autotarget    : Toggle autotarget on or off')
        windower.add_to_chat(200,'  ip;ignorepet     : Toggle ignorepet on or off')
        windower.add_to_chat(200,'  hhp;highhp       : Toggle high hp mode on or off')
        windower.add_to_chat(200,'  add              : Add name to petlist')
        windower.add_to_chat(200,'  remove           : Remove name from petlist')
        windower.add_to_chat(200,'  r;reload         : Reloads the addon')
        --windower.add_to_chat(200,'  gui              : Show or hide the GUI')
    elseif args[1]:lower() == 'quit' then
		quit()
    elseif S{'at','autotarget'}:contains(cmd) then
        if settings.autotarget then
            settings.autotarget = false
            windower.add_to_chat(200,'Auto-target paused')
        else
            settings.autotarget = true
            windower.add_to_chat(200,'Auto-target unpaused')
        end
    elseif S{'hhp','highhp'}:contains(cmd) then
        if settings.highhp then
            settings.highhp = false
            windower.add_to_chat(200,'High HP only disbaled')
        else
            settings.highhp = true
            windower.add_to_chat(200,'High HP only enabled')
        end
    elseif S{'ip','ignorepet'}:contains(cmd) then
        if settings.ignorepet then
            settings.ignorepet = false
            windower.add_to_chat(200,'Pet list no longer ignored')
        else
            settings.ignorepet = true
            windower.add_to_chat(200,'Ignore pet list active')
        end
    elseif args[1]:lower() == 'on' then
        settings.autotarget = true
        windower.add_to_chat(200,'Auto-target unpaused')
    elseif args[1]:lower() == 'off' then
        settings.autotarget = false
        windower.add_to_chat(200,'Auto-target paused')
    elseif args[1]:lower() == "add" then
		settings.petlist:add(args[2]:trim())
	elseif args[1]:lower() == "remove" then
		settings.petlist:remove(args[2]:trim())
    elseif S{'r','reload'}:contains(cmd) then
	    windower.send_command('lua reload bat')
    end
end)