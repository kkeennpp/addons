_addon.name = 'Multifollow'
_addon.author   = 'Amaiya and Aeolas'
_addon.version  = '1.4.2'
_addon.commands = {'mf','multifollow'}

require('logger')
require('coroutine')
packets = require('packets')
res = require('resources')
config = require('config')

default = {
    showgui = true,
    interval = 0.1,
    fdist = 1,
    ldist = 0,
    sdist = 15,
    ftarget = 'NotSet',
    box={
        pos={x=400,y=400},
        text={font='Segoe UI Symbol',size=10,},
        bg={alpha=150,red=0,green=0,blue=0},
        flags={draggable=true},
        padding=4
        }
}

followactive = false
followpause = false
followstuck = false
followmanager = false
wasfollowing = false

settings = config.load(default)
require 'MF_GUI'
require 'MF_ROE'

windower.register_event('load', function()
    windower.add_to_chat(200,'Welcome to Multifollow! To see a list of commands, type //mf help')
    windower.add_to_chat(200,'Common commands: //mf t followtarget, //mf d followdistance, //mf start, //mf stop')
    windower.add_to_chat(200,'Leash distance is how far you can move before follow starts')
    windower.add_to_chat(200,'Stuck distance sets how far from the follow distance before pausing follow')
    windower.add_to_chat(200,'Current distances: Follow - '..settings.fdist..', Leash - '..settings.ldist..', Stuck - '..settings.sdist)
end)

windower.register_event('logout', function()
    --quit()
end)

windower.register_event('zone change', function(new_id, old_id)
    local zone_info = windower.ffxi.get_info()
    if zone_info ~= nil then
        if zone_info.zone == 131 then
            windower.send_ipc_message('multifollow stop')
            quit()
        elseif zone_info.mog_house == true then
            --followactive = false
        --elseif followmanager and afollowme then
            --windower.send_ipc_message('multifollow zone')
        end
    end
end)

function do_stuff()
	if followactive then
        follow_target_exists()
        if not followpause then
		    local ft = windower.ffxi.get_mob_by_name(settings.ftarget)

		    if(math.sqrt(ft.distance)) < settings.fdist then
			    windower.ffxi.run(false)
		    elseif(math.sqrt(ft.distance)) > settings.fdist + settings.sdist then
                follow_stuck()
		    elseif(math.sqrt(ft.distance)) > settings.fdist + settings.ldist then
			    go_to_target()
                --wasfollowing = true
                followstuck = false
		    end
        end
	end
    window:text(updatedisplay())
end

do_stuff:loop(settings.interval)

function follow_manager_mode()
    if followmanager then
        followmanager = false
		windower.add_to_chat(200,"Exiting follow management mode.")
    else
        followmanager = true
		windower.add_to_chat(200,"Switching to follow management mode.")
    end
end

function all_follow_me()
	local player = windower.ffxi.get_player()
    if afollowme then
        afollowme = false
        windower.send_ipc_message('multifollow stop')
    else
        afollowme = true
        followactive = false
        windower.ffxi.run(false)
        windower.send_ipc_message('multifollow t '..player.name)
	    coroutine.sleep(.5)
        windower.send_ipc_message('multifollow start')
    end
end

function quit()
    followactive = false
	windower.add_to_chat(200,"Now exiting multifollow lua")
	coroutine.sleep(2)
	windower.send_command('lua unload multifollow')
end

function follow_stop()
    followactive = false
	windower.ffxi.run(false)
	log("Follow stopped")
end

function follow_start()
	if settings.ftarget == 'NotSet' then
		windower.add_to_chat(200,"Follow target not set!")
		windower.add_to_chat(200,"Please set a follow target '//mf t playername'")
	else
		log("Follow started, now following "..settings.ftarget)
		followactive = true
	end
end

function follow_stuck()
    if not followstuck then
		windower.ffxi.run(false)
        followstuck = true
	    local player = windower.ffxi.get_player()
        windower.send_ipc_message('multifollow stuck '..player.name)
        log("I Am Stuck or follow target out of range!")
    end
end

function go_to_target()
	local player = windower.ffxi.get_mob_by_target('me')
	local ft = windower.ffxi.get_mob_by_name(settings.ftarget)
	windower.ffxi.run(ft.x - player.x, ft.y - player.y, ft.z - player.z)
end

function follow_target_exists()
    if (settings.ftarget == nil) then return end
    local ft = windower.ffxi.get_mob_by_name(settings.ftarget)
    if followactive and (ft == nil) then
        followpause = true
    --elseif followpause and wasfollowing and (ft ~= nil) then
        --followpause = true
    elseif followpause and (ft ~= nil) then
        followpause = false
    end
end

function getPlayerName(name)
    local trg = getTarget(name)
    if (trg ~= nil) then
        return trg.name
    end
    return nil
end

function getTarget(targ)
    if targ == nil then
        return nil
    elseif tonumber(targ) and (tonumber(targ) > 255) then
        return windower.ffxi.get_mob_by_id(tonumber(targ))
    elseif S{'<me>','me'}:contains(targ) then
        return windower.ffxi.get_mob_by_target('me')
    elseif (targ == '<t>') then
        return windower.ffxi.get_mob_by_target()
    elseif isstr(targ) then
        local target = windower.ffxi.get_mob_by_name(targ)
        return target or windower.ffxi.get_mob_by_name(targ:ucfirst())
    end
    return nil
end

function isstr(obj) return type(obj) == 'string' end

windower.register_event('ipc message', function (msg)
	local args = msg:split(' ')

    if args[1]:lower() == 'multifollow' then
		if args[2]:lower() == 'stop' then
            follow_stop()
		elseif args[2]:lower() == 'zone' then
            if wasfollowing then
                followpause = true
		        windower.ffxi.run(true)
	            coroutine.sleep(1)
		        windower.ffxi.run(false)
                wasfollowing = false
            end
		elseif args[2]:lower() == 'd' then
            settings.fdist = tonumber(args[3])
			windower.add_to_chat(200,"Follow Distance set to: "..settings.fdist)
		elseif args[2]:lower() == 't' then
		    local ftargettemp = getPlayerName(args[3])
            if (ftargettemp ~= nil) then
                settings.ftarget = ftargettemp
                windower.add_to_chat(200,"Follow target set to "..settings.ftarget)
	            coroutine.sleep(.1)
		        follow_start()
            end
		elseif args[2]:lower() == 'start' then
		    follow_start()
		elseif args[2]:lower() == 'stuck' then
		    local stargettemp = getPlayerName(args[3])
		    log(stargettemp.." is stuck or out of follow target range!")
        end
    end
end)

windower.register_event('addon command', function (...)
	local args = {...}
	local cmd = args[1] and args[1]:lower()

    if S{'start', 'go'}:contains(cmd) then
		follow_start()
    elseif S{'halt', 'stop'}:contains(cmd) then
		follow_stop()
    elseif args[1]:lower() == 'quit' then
		quit()
    elseif S{'distance', 'dist', 'd'}:contains(cmd) then
		local fdisttemp = tonumber(args[2])
        if (fdisttemp ~= nil) and (.09 < fdisttemp) and (fdisttemp < 22) then
			settings.fdist = tonumber(args[2])
			windower.add_to_chat(200,"Follow Distance set to: "..settings.fdist)
		else
			windower.add_to_chat(200,"Invalid Distance!! Please input a number .1-22")
		end
    elseif S{'interval', 'i'}:contains(cmd) then
		local intervaltemp = tonumber(args[2])
        if (intervaltemp ~= nil) and (.009 < intervaltemp) and (intervaltemp < 1.01) then
			settings.interval = tonumber(args[2])
			windower.add_to_chat(200,"Run Interval set to: "..settings.interval)
		else
			windower.add_to_chat(200,"Invalid Interval!! Please input a number .01-1")
		end
    elseif S{'leash', 'l'}:contains(cmd) then
		local ldisttemp = tonumber(args[2])
        if (ldisttemp ~= nil) and (0 <= ldisttemp) and (ldisttemp < 22) then
			settings.ldist = tonumber(args[2])
			windower.add_to_chat(200,"Leash Distance set to: "..settings.ldist)
		else
			windower.add_to_chat(200,"Invalid Distance!! Please input a number 0-22")
		end
    elseif S{'stuck', 's'}:contains(cmd) then
		local sdisttemp = tonumber(args[2])
        if (sdisttemp ~= nil) and (4 < sdisttemp) and (sdisttemp < 50) then
			settings.sdist = tonumber(args[2])
			windower.add_to_chat(200,"Stuck Distance set to: "..settings.sdist)
		else
			windower.add_to_chat(200,"Invalid Distance!! Please input a number 5-50")
		end
    elseif S{'target', 't'}:contains(cmd) then
		local ftargettemp = getPlayerName(args[2])
            if (ftargettemp ~= nil) then
                settings.ftarget = ftargettemp
                windower.add_to_chat(200,"Follow target set to "..settings.ftarget)
	            coroutine.sleep(.1)
		        follow_start()
            else
                windower.add_to_chat(200,"Invalid name provided as a follow target: "..tostring(args[2]))
			end
    elseif args[1]:lower() == 'gui' then
        if settings.showgui then
            settings.showgui = false
            window:hide()
            windower.add_to_chat(200,'GUI now hidden')
        else
            settings.showgui = true
            window:show()
            windower.add_to_chat(200,'GUI now being displayed')
        end
    elseif S{'r','reload'}:contains(cmd) then
	    windower.send_command('lua reload multifollow')
    elseif args[1]:lower() == 'roe' then
        if args[2]:lower() == 'set' then
            if args[3]:lower() == 'ambu' then
			    windower.add_to_chat(200,"Setting ROE Ambu")
                all_ambu_set()
            elseif args[3]:lower() == 'trove' then
			    windower.add_to_chat(200,"Setting ROE Trove")
                all_trove_set()
            elseif args[3]:lower() == 'vagary' then
			    windower.add_to_chat(200,"Setting ROE Vagary")
                all_vagary_set()
            end
        elseif args[2]:lower() == 'cancel' then
            if args[3]:lower() == 'ambu' then
			    windower.add_to_chat(200,"Canceling ROE Ambu")
                all_ambu_cancel()
            elseif args[3]:lower() == 'trove' then
			    windower.add_to_chat(200,"Canceling ROE Trove")
                all_trove_cancel()
            elseif args[3]:lower() == 'vagary' then
			    windower.add_to_chat(200,"Canceling ROE Vagary")
                all_vagary_cancel()
            end
        end
    elseif args[1] == nil or args[1]:lower() == "help" then
        windower.add_to_chat(200,'multifollow:  //multifollow;//mf  Valid commands are:')
        windower.add_to_chat(200,'  start;go         : Start following')
        windower.add_to_chat(200,'  stop;halt        : Stop following')
        windower.add_to_chat(200,'  distance;d       : Sets follow distance.  Can be .1-22')
        windower.add_to_chat(200,'  leash;l          : Sets leash distance.  Can be 1-22')
        windower.add_to_chat(200,'  stuck;s          : Sets stuck distance.  Can be 5-22')
        windower.add_to_chat(200,'  target;t         : Sets follow target by player name')
        windower.add_to_chat(200,'  gui              : Show or hide the GUI')
        windower.add_to_chat(200,'  roe set obj      : Sets ROE Objectives; roe set [Ambu] [Vagary] [Trove]')
        windower.add_to_chat(200,'  roe cancel obj   : Cancel ROE Objectives; ROE Cancel [Ambu] [Vagary] [Trove]')
    end
end)