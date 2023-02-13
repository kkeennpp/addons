_addon.author   = 'Amaiya'
_addon.version  = '1.1'
_addon.commands = {'cm','chatmon'}

--1.0   initial working release
--1.1   added text logging, updated color key

require('logger')
require('coroutine')
config = require('config')
packets = require('packets')
res = require('resources')
texts = require('texts')
files = require('files')

windower.register_event('load', function()
	local player = windower.ffxi.get_player()
    f = files.new(player.name..'.txt')
    if f:exists() and settings.save then
        f:append('\n\n'..os.date("%X")..' Addon loaded, logging started')
    else
        f:write(os.date("%X")..' Addon loaded, logging started')
    end
end)

default = {
    showgui = true,
    lookfor1 = 'segment',
    lookfor2 = 'odyssey',
    lookfor3 = 'ody',
    lookfor4 = 'c farm',
    lookfor5 = 'sheol',
    broadcast = false,
    save = true,
    box = {
        pos={x=400,y=400},
        text={font='Segoe UI Symbol',size=10,},
        bg={alpha=150,red=0,green=0,blue=0},
        flags={draggable=true},
        padding=4
    },
    ilist = S{"Sixgodg","Meiods","Meios","Cpttn"
    }
}

Colors = {
    [0] = "\\cs(255,255,255)", --say
    [1] = "\\cs(0,150,255)", --shout
    [3] = "\\cs(255,150,0)", --tell
    [4] = "\\cs(255,255,255)", --party
    [5] = "\\cs(255,255,255)", --linkshell
    [8] = "\\cs(255,255,255)", --emote
    [26] = "\\cs(0,255,0)", --yell
    [27] = "\\cs(255,255,255)", --linkshell2
    [33] = "\\cs(255,255,255)", --unity
    [34] = "\\cs(255,255,255)", --assistj
    [35] = "\\cs(255,255,255)", --assiste
}

settings = config.load(default)

function updatedisplay(mode,sender,message)
	local str = 'Chatmon'
	str = str..'\nCurrently searching for: \"'..settings.lookfor1..'\", \"'..settings.lookfor2..'\", \"'..settings.lookfor3..'\", \"'..settings.lookfor4..'\", \"'..settings.lookfor5..'\"'
    if message then
	    str = str..'\n\n'..os.date("%X")..' '..Colors[tonumber(mode)]..sender..': \\cr'..message
        f:append('\n'..os.date("%X")..' '..sender..': '..message)
        if prev1 then
            str = str..prev1
            if prev2 then
                str = str..prev2
                prev2 = prev1
                prev1 = '\n'..os.date("%X")..' '..Colors[tonumber(mode)]..sender..': \\cr'..message
            else
                prev2 = prev1
                prev1 = '\n'..os.date("%X")..' '..Colors[tonumber(mode)]..sender..': \\cr'..message
            end
        else
            prev1 = '\n'..os.date("%X")..' '..Colors[tonumber(mode)]..sender..': \\cr'..message
        end
    end

    str = str..'\n\n Color key: '..Colors[3]..'Tell, '..Colors[26]..'Yell, '..Colors[1]..'Shout\\cr'
    return str
end

window = texts.new(updatedisplay(),settings.box,settings)
window:show()

windower.register_event('chat message', function(message,sender,mode)
    local lmsg = message:lower()
    local lsend = sender:lower()

    if not settings.ilist:contains(sender) then
        if lmsg:contains(settings.lookfor1) or lsend:contains(settings.lookfor1) then
            window:text(updatedisplay(mode,sender,message))
            if settings.broadcast then
                windower.send_ipc_message('chatmon '..mode..' '..sender..' '..message)
            end
        elseif lmsg:contains(settings.lookfor2) or lsend:contains(settings.lookfor2) then
            window:text(updatedisplay(mode,sender,message))
            if settings.broadcast then
                windower.send_ipc_message('chatmon '..mode..' '..sender..' '..message)
            end
        elseif lmsg:contains(settings.lookfor3) or lsend:contains(settings.lookfor3) then
            window:text(updatedisplay(mode,sender,message))
            if settings.broadcast then
                windower.send_ipc_message('chatmon '..mode..' '..sender..' '..message)
            end
        elseif lmsg:contains(settings.lookfor4) or lsend:contains(settings.lookfor4) then
            window:text(updatedisplay(mode,sender,message))
            if settings.broadcast then
                windower.send_ipc_message('chatmon '..mode..' '..sender..' '..message)
            end
        elseif lmsg:contains(settings.lookfor5) or lsend:contains(settings.lookfor5) then
            window:text(updatedisplay(mode,sender,message))
            if settings.broadcast then
                windower.send_ipc_message('chatmon '..mode..' '..sender..' '..message)
            end
        end
    end
end)

--windower.register_event('incoming text', function(original)
    --window:text(updatedisplay("0","test",original))
--end)

windower.register_event('ipc message', function (msg)
	local args = msg:split(' ')

    if args[1]:lower() == 'chatmon' then
        local rmode = args[2]
        local rsender = args[3]
        local rmessage = string.gsub(msg,args[1]..' '..args[2]..' '..args[3]..' ',"")
        --log(rmode,rsender,rmessage)
        window:text(updatedisplay(rmode,rsender,rmessage))
    end
end)

windower.register_event('addon command', function (...)
	local args = {...}
	local cmd = args[1] and args[1]:lower()

    if args[1]:lower() == 'gui' then
        if settings.showgui then
            settings.showgui = false
            window:hide()
            windower.add_to_chat(200,'GUI now hidden')
        else
            settings.showgui = true
            window:show()
            windower.add_to_chat(200,'GUI now being displayed')
        end
    elseif S{'b','broadcast'}:contains(cmd) then
        if settings.broadcast then
            settings.broadcast = false
            windower.add_to_chat(200,'No longer broadcasting to all accounts')
        else
            settings.broadcast = true
            windower.add_to_chat(200,'Now broadcasting results to all accounts')
        end
    elseif S{'s','s1'}:contains(cmd) then
        if (args[2]) ~= nil then
            settings.lookfor1 = (args[2])
            windower.add_to_chat(200,"Now searching for "..settings.lookfor1)
            window:text(updatedisplay())
        else
            windower.add_to_chat(200,"Invalid term provided as a search target: "..tostring(args[2]))
		end
    elseif args[1]:lower() == 's2' then
        if (args[2]) ~= nil then
            settings.lookfor2 = (args[2])
            windower.add_to_chat(200,"Now searching for "..settings.lookfor2)
            window:text(updatedisplay())
        else
            windower.add_to_chat(200,"Invalid term provided as a search target: "..tostring(args[2]))
		end
    elseif args[1]:lower() == 's3' then
        if (args[2]) ~= nil then
            settings.lookfor3 = (args[2])
            windower.add_to_chat(200,"Now searching for "..settings.lookfor3)
            window:text(updatedisplay())
        else
            windower.add_to_chat(200,"Invalid term provided as a search target: "..tostring(args[2]))
		end
    elseif args[1]:lower() == 's4' then
        if (args[2]) ~= nil then
            settings.lookfor4 = (args[2])
            windower.add_to_chat(200,"Now searching for "..settings.lookfor4)
            window:text(updatedisplay())
        else
            windower.add_to_chat(200,"Invalid term provided as a search target: "..tostring(args[2]))
		end
    elseif args[1]:lower() == 's5' then
        if (args[2]) ~= nil then
            settings.lookfor5 = (args[2])
            windower.add_to_chat(200,"Now searching for "..settings.lookfor5)
            window:text(updatedisplay())
        else
            windower.add_to_chat(200,"Invalid term provided as a search target: "..tostring(args[2]))
		end
    elseif args[1]:lower() == "add" then
		settings.ilist:add(args[2]:trim())
	elseif args[1]:lower() == "remove" then
		settings.ilist:remove(args[2]:trim())
    elseif S{'r','reload'}:contains(cmd) then
	    windower.send_command('lua reload chatmon')
    end
end)