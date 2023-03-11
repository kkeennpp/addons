_addon.name = 'SortieTracker'
_addon.author = 'Amaiya'
_addon.version = '1.0.0'
_addon.commands = {'stt'}

require('logger')
require('coroutine')
config = require('config')
packets = require('packets')
images = require('images')
res = require('resources')
files = require('files')
texts = require('texts')

running = false

current_gal = 0
starting_gal = 0
gained_gal = 0
player_deaths = 0
location = "Drifts"

CHA3 = false
CHA4 = false
CAA1 = false
CAA2 = false
COA = false

CHB3 = false
CHB4 = false
CAB1 = false
CAB2 = false
COB = false

CHC3 = false
CHC4 = false
CAC1 = false
CAC2 = false
COC = false

CHD3 = false
CHD4 = false
CAD1 = false
CAD2 = false
COD = false

AURUM = false

CHE = false
CAE1 = false
CAE2 = false
COE = false

CHF = false
CAF1 = false
CAF2 = false
COF = false

CHG = false
CAG1 = false
CAG2 = false
COG = false

CHH = false
CAH1 = false
CAH2 = false
COH = false

Colors = {
    ["false"] = "\\cs(0,128,255)",
    ["true"] = "\\cs(0,255,0)",
}

ColorsTF = {
    ["false"] = "\\cs(0,128,255)",
    ["true"] = "\\cs(0,255,0)",
}

default = {
    box = {
        pos={x=400,y=400},
        text={font='Segoe UI Symbol',size=10},
        bg={alpha=150,red=0,green=0,blue=0},
        flags={draggable=true},
    },
    map = {
        pos = {
            x = windower.get_windower_settings().ui_x_res / 2 - 384,
            y = windower.get_windower_settings().ui_y_res / 2 - 384
        },
        size = {
            width = 768,
            height = 768
        },
        texture = {
            fit = false,
            path = ''
        }
    }
}

settings = config.load(default)
local map = images.new(settings.map)

function updatedisplay()
	local str = 'Sortie Tracker'
    if running then
	    --str = str..'\n\\cs(0, 255, 0)[A] [B] [C] [D] [E] [F] [G] [H] [Map]\\cr'
	    str = str..'\n\\cs(0, 255, 204)[A] \\cr'..
                    '\\cs(0, 255, 204)[B] \\cr'..
                    '\\cs(0, 255, 204)[C] \\cr'..
                    '\\cs(0, 255, 204)[D] \\cr'..
                    '\\cs(0, 255, 204)[E] \\cr'..
                    '\\cs(0, 255, 204)[F] \\cr'..
                    '\\cs(0, 255, 204)[G] \\cr'..
                    '\\cs(0, 255, 204)[H] \\cr'..
                    '\\cs(0, 255, 204)[Map]\\cr'
        str = str..'\n\nCurrent Location: '..location
        if location == "A" then
            -- Top Floor A
            str = str..'\n'..ColorsTF[tostring(CHA3)]..'Chest #A3 - Shard\\cr'
            str = str..'\n     Magic kill 3x'
            str = str..'\n'..ColorsTF[tostring(CHA4)]..'Chest #A4 - Metal\\cr'
            str = str..'\n     Magic kill 3x'
            str = str..'\n'..ColorsTF[tostring(CAA1)]..'Casket #A1\\cr'
            str = str..'\n     Kill 5x enemies'
            str = str..'\n'..ColorsTF[tostring(CAA2)]..'Casket #A2\\cr'
            str = str..'\n     /heal past the #A1 gate'
            str = str..'\n'..ColorsTF[tostring(COA)]..'Coffer #A\\cr'
            str = str..'\n     Kill Abject Obdella'
        elseif location == 'B' then
            -- Top Floor B
            str = str..'\n'..ColorsTF[tostring(CHB3)]..'Chest #B3 - Shard\\cr'
            str = str..'\n     Kill 3x elementals in < 30 sec'
            str = str..'\n'..ColorsTF[tostring(CHB4)]..'Chest #B4 - Metal\\cr'
            str = str..'\n     Kill 3x elementals in < 30 sec'
            str = str..'\n'..ColorsTF[tostring(CAB1)]..'Casket #B1\\cr'
            str = str..'\n     Kill 3x Biune < 30 sec'
            str = str..'\n'..ColorsTF[tostring(CAB2)]..'Casket #B2\\cr'
            str = str..'\n     Open a #B locked Gate'
            str = str..'\n'..ColorsTF[tostring(COB)]..'Coffer #B\\cr'
            str = str..'\n     Kill Porxie after opening Casket #B1'
        elseif location == 'C' then
            -- Top Floor C
            str = str..'\n'..ColorsTF[tostring(CHC3)]..'Chest #C3 - Shard\\cr'
            str = str..'\n     Do 3x Magic Bursts'
            str = str..'\n'..ColorsTF[tostring(CHC4)]..'Chest #C4 - Metal\\cr'
            str = str..'\n     Do 3x Magic Bursts'
            str = str..'\n'..ColorsTF[tostring(CAC1)]..'Casket #C1\\cr'
            str = str..'\n     Kill 3x enemies < 30 sec'
            str = str..'\n'..ColorsTF[tostring(CAC2)]..'Casket #C2\\cr'
            str = str..'\n     Kill all enemies'
            str = str..'\n'..ColorsTF[tostring(COC)]..'Coffer #C\\cr'
            str = str..'\n     Kill Cachaemic Bhoot < 5 min'
        elseif location == 'D' then
            -- Top Floor D
            str = str..'\n'..ColorsTF[tostring(CHD3)]..'Chest #C3 - Shard\\cr'
            str = str..'\n     Do a 4-step skillchain 3x times'
            str = str..'\n'..ColorsTF[tostring(CHD4)]..'Chest #C4 - Metal\\cr'
            str = str..'\n     Do a 4-step skillchain 3x times'
            str = str..'\n'..ColorsTF[tostring(CAD1)]..'Casket #D1\\cr'
            str = str..'\n     Kill 6x Demisang of different jobs'
            str = str..'\n'..ColorsTF[tostring(CAD2)]..'Casket #D2\\cr'
            str = str..'\n     WAR->MNK->WHM->BLM->RDM->THF'
            str = str..'\n'..ColorsTF[tostring(COD)]..'Coffer #D\\cr'
            str = str..'\n     Kill 3x enemies after NM'
        elseif location == 'E' then
            -- E Basement
            str = str..'\n'..ColorsTF[tostring(CHE)]..'Chest #E - Metal\\cr'
            str = str..'\n     Kill Botulus with WS from behind'
            str = str..'\n'..ColorsTF[tostring(CAE1)]..'Casket #E1\\cr'
            str = str..'\n     Kill foes at bitzer (x12)'
            str = str..'\n'..ColorsTF[tostring(CAE2)]..'Casket #E2\\cr'
            str = str..'\n     Kill all flan (x15)'
            str = str..'\n'..ColorsTF[tostring(COE)]..'Coffer #E\\cr'
            str = str..'\n     Kill Naakuals any order'
        elseif location == 'F' then
            -- F Basement
            str = str..'\n'..ColorsTF[tostring(CHF)]..'Chest #F - Metal\\cr'
            str = str..'\n     Kill Ixion unknown'
            str = str..'\n'..ColorsTF[tostring(CAF1)]..'Casket #F1\\cr'
            str = str..'\n     5/5 Empy gear at bitzer'
            str = str..'\n'..ColorsTF[tostring(CAF2)]..'Casket #F2\\cr'
            str = str..'\n     Kill all Veela'
            str = str..'\n'..ColorsTF[tostring(COF)]..'Coffer #F\\cr'
            str = str..'\n     Leave then kill all Naakuals'
        elseif location == 'G' then
            -- G Basement
            str = str..'\n'..ColorsTF[tostring(CHG)]..'Chest #G - Metal\\cr'
            str = str..'\n     Kill Naraka'
            str = str..'\n'..ColorsTF[tostring(CAG1)]..'Casket #G1\\cr'
            str = str..'\n     Target the Bizter for 30 sec '
            str = str..'\n'..ColorsTF[tostring(CAG2)]..'Casket #G2\\cr'
            str = str..'\n     Kill all dullahan (x17)'
            str = str..'\n'..ColorsTF[tostring(COG)]..'Coffer #G\\cr'
            str = str..'\n     Bee->Shark->T-Rex->Bird->Tree->Lion'
        elseif location == 'H' then
            -- H Basement
            str = str..'\n'..ColorsTF[tostring(CHH)]..'Chest #H - Metal\\cr'
            str = str..'\n     Kill Tulittia after fomor near her'
            str = str..'\n'..ColorsTF[tostring(CAH1)]..'Casket #H1\\cr'
            str = str..'\n     Leave then re-enter'
            str = str..'\n'..ColorsTF[tostring(CAH2)]..'Casket #H2\\cr'
            str = str..'\n     Kill all of one Job'
            str = str..'\n'..ColorsTF[tostring(COH)]..'Coffer #H\\cr'
            str = str..'\n     Kill one fomor of each job then'
            str = str..'\n     Bee->Lion->T-Rex->Shark->Bird->Tree'
        end
    end
    str = str..'\n\nCurrent Gallimaufry: '..current_gal
	str = str..'\nPrevious Run: '..gained_gal
    return str
end

window = texts.new(updatedisplay(),settings.box,settings)

windower.register_event('load', function()
    windower.add_to_chat(200,'Welcome to SortieTracker! To see a list of commands, type //stt help')
	get_gal()

	local player = windower.ffxi.get_player()
    f = files.new(player.name..'.txt')
    if f:exists() and settings.save then
        f:append('\n\n'..os.date("%X")..' Addon loaded, logging started')
    else
        f:write(os.date("%X")..' Addon loaded, logging started')
    end

    local zone_info = windower.ffxi.get_info()
    if zone_info ~= nil then
        if zone_info.zone == 133 or zone_info.zone == 189 or zone_info.zone == 275 then
            running = true
            location = "A"
            log("Entered Sortie zone, now starting")
            window:show()
	        window:text(updatedisplay())
        else
            window:hide()
            running = false
            log("Waiting to enter Sortie zone...")
        end
    end
end)

windower.register_event('zone change', function()
    local zone_info = windower.ffxi.get_info()
    if zone_info ~= nil then
        if zone_info.zone == 133 or zone_info.zone == 189 or zone_info.zone == 275 then
            running = true
            location = "A"
            log("Entered Sortie zone, now starting")
            window:show()
	        window:text(updatedisplay())
        elseif zone_info.zone == 267 then
            if running then
                running = false
                location = "Drifts"
                log("Exited Sortie, display previous run")
	            get_gal()
            end
        else
            window:hide()
            running = false
        end
    end
end)

windower.register_event('incoming chunk',function(id, data, modified, injected, blocked)
	if id == 0x118 and not injected then
		local p = packets.parse('incoming', data)
		current_gal = p["Gallimaufry"]

		if starting_gal == 0 then
			starting_gal = current_gal
		end
		
		gained_gal = current_gal - starting_gal
		window:text(updatedisplay())
    elseif id == 0x027 and not injected then
		local p = packets.parse('incoming', data)
        f:append('\n'..os.date("%X")..' Player: '..p["Player"]..', Player Index: '..p["Player Index"])
        log(p["Player"]..', '..p["Player Index"])
        if tostring(p["Player Index"]):contains('3') then
            CHA3 = true
        elseif tostring(p["Player Index"]):contains('4') then
            CHA4 = true
        elseif tostring(p["Player Index"]):contains('Casket #A1') then
            CAA1 = true
        elseif tostring(p["Player Index"]):contains('Casket #A2') then
            CAA2 = true
        elseif tostring(p["Player Index"]):contains('28') then COA = true
        --elseif p["Player Index"] == 28 then COA = true
        elseif tostring(p["Player Index"]):contains('38') then
            AURUM = true
        elseif tostring(p["Player Index"]):contains('42') then
            CAF1 = true
        elseif tostring(p["Player Index"]):contains('45') then
            CAG1 = true
        end
	    get_gal()
	end
end)

windower.register_event('incoming text',function(orig)
    if orig:find('#A') then
        f:append('\n'..os.date("%X")..' '..orig)
    elseif orig:find('#B') then
        f:append('\n'..os.date("%X")..' '..orig)
    elseif orig:find('#C') then
        f:append('\n'..os.date("%X")..' '..orig)
    elseif orig:find('#D') then
        f:append('\n'..os.date("%X")..' '..orig)
    elseif orig:find('#E') then
        f:append('\n'..os.date("%X")..' '..orig)
    elseif orig:find('#F') then
        f:append('\n'..os.date("%X")..' '..orig)
    elseif orig:find('#G') then
        f:append('\n'..os.date("%X")..' '..orig)
    end
end)

function get_gal()
    if not windower.ffxi.get_info().logged_in then
        return
    end
    local p = packets.new('outgoing', 0x115)
    packets.inject(p)
end

windower.register_event('addon command', function (...)
	local args = {...}
	local cmd = args[1] and args[1]:lower()

    if args[1]:lower() == 'save' then
        config.save(settings, windower.ffxi.get_player().name:lower())
        log('Sortie Settings Saved')
    elseif args[1]:lower() == 'a' then
        location = "A"
        log('Sortie zone set to A')
    elseif args[1]:lower() == 'b' then
        location = "B"
        log('Sortie zone set to B')
    elseif args[1]:lower() == 'c' then
        location = "C"
        log('Sortie zone set to C')
    elseif args[1]:lower() == 'd' then
        location = "D"
        log('Sortie zone set to D')
    elseif args[1]:lower() == 'e' then
        location = "E"
        log('Sortie zone set to E')
    elseif args[1]:lower() == 'f' then
        location = "F"
        log('Sortie zone set to F')
    elseif args[1]:lower() == 'g' then
        location = "G"
        log('Sortie zone set to G')
    elseif args[1]:lower() == 'h' then
        location = "H"
        log('Sortie zone set to H')
    elseif S{'r','reload'}:contains(cmd) then
	    windower.send_command('lua reload stt')
    elseif args[1]:lower() == 'test' then
        if running then
            running = false
            window:hide()
        else        
            running = true
            window:show()
        end
    elseif S{'m','map'}:contains(cmd) then
        if map and map:visible() then
            map:hide()
        else
            map:show()
        end
    end

    if S{'A','B','C','D'}:contains(location) then
        map:path(windower.addon_path..'maps/Upper.png')
    else
        map:path(windower.addon_path..'maps/Lower.png')
    end
	get_gal()
end)

windower.register_event('mouse', function (type, x, y, delta, blocked)
    if window:hover(x, y) and window:visible() then
        if type == 2 then
            local pos_x = tonumber(settings.box.pos.x)
            local pos_y = tonumber(settings.box.pos.y)

            --log("X["..tostring(x).."], Y["..tostring(y).."]")
            --log("Window location ["..pos_x.."]")
            --Set the floor
            if y > pos_y + 20 and y < pos_y + 40 then
                if x > pos_x + 0 and x < pos_x + 18 then
                    location = "A"
                    log("Set to A")
                elseif x > pos_x + 25 and x < pos_x + 38 then
                    location = "B"
                    log("Set to B")
                elseif x > pos_x + 45 and x < pos_x + 58 then
                    location = "C"
                    log("Set to C")
                elseif x > pos_x + 64 and x < pos_x + 80 then
                    location = "D"
                    log("Set to D")
                elseif x > pos_x + 87 and x < pos_x + 99 then
                    location = "E"
                    log("Set to E")
                elseif x > pos_x + 106 and x < pos_x + 118 then
                    location = "F"
                    log("Set to F")
                elseif x > pos_x + 125 and x < pos_x + 139 then
                    location = "G"
                    log("Set to G")
                elseif x > pos_x + 146 and x < pos_x + 162 then
                    location = "H"
                    log("Set to H")
                elseif x > pos_x + 169 and x < pos_x + 202 then
                    if map and map:visible() then
                        map:hide()
                    else
                        map:show()
                    end
                end
            end

            if S{'A','B','C','D'}:contains(location) then
                map:path(windower.addon_path..'maps/Upper.png')
            else
                map:path(windower.addon_path..'maps/Lower.png')
            end

	        get_gal()
        end
    end
end)