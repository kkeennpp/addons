require('coroutine')
texts = require('texts')
local _events = {}

Colors = {
    ["false"] = "\\cs(255,0,0)",
    ["true"] = "\\cs(0,255,0)",
    }

color = {}
afollowme = false
afollowdist = 1

buttons = {'showgui','followmanagergui','ftargetgui','followactive','followstuckgui','partygui','p1','p2','p3','p4','p5'}

function colorize(row, str)
    if not color[row] then return str end
    return '\\cs(0,150,255)%s\\cr':format(str)
end

function updatedisplay()
    if followmanager then
        buttons = {'showgui','followmanagergui','allfollowmegui','fdallgui','fd1','fd5','fd10','fd21'}

        --local str = colorize(1, 'Hide GUI')
        local str = 'Multifollow'
        str = str .. colorize(2, '\nFollow Manager: ')..Colors[tostring(followmanager)]..'[%s]':format(followmanager and 'On' or 'Off')..'\\cr'
        str = str .. colorize(3, '\nAll Follow Me: ')..Colors[tostring(afollowme)]..'[%s]':format(afollowme and 'True' or 'False')..'\\cr'
        str = str .. '\nSet Follow Distance: '..afollowdist
        str = str .. colorize(5, '\n     1')
        str = str .. colorize(6, '\n     5')
        str = str .. colorize(7, '\n     10')
        str = str .. colorize(8, '\n     21')
        return str
    else
        buttons = {'showgui','followmanagergui','ftargetgui','fdistgui','followactive','followstuckgui','partygui','p1','p2','p3','p4','p5'}
        
        local str = 'Multifollow'
        str = str .. colorize(2, '\nFollow Manager: ')..Colors[tostring(followmanager)]..'[%s]':format(followmanager and 'On' or 'Off')..'\\cr'
        str = str .. '\nFollow Target: '..settings.ftarget
        str = str .. '\nFollow Distance: '..settings.fdist
        str = str .. colorize(5, '\nFollow Active: ')..Colors[tostring(followactive)]..'[%s]':format(followactive and 'On' or 'Off')..'\\cr'
        str = str .. '\nFollow Stuck: '..Colors[tostring(followstuck)]..'[%s]':format(followstuck and 'True' or 'False')..'\\cr'
        --str = str .. '\nFollowing: '..tostring(wasfollowing)
        --str = str .. '\nFollow Pause: '..tostring(followpause)
        --str = str .. '\nRun Interval: '..tostring(settings.interval)
        str = str .. '\nCurent Party:'

        local party = windower.ffxi.get_party()
        for x = 1, 5 do
            local slot = 'p' .. x
            local member = party[slot]
            if member then
                member = member.name
                str = str..colorize(x + 7,'\n    %s':format(member))
            else
                member = ''
            end
        end
        return str
    end
end

window = texts.new(updatedisplay(),settings.box,settings)
window:show()

windower.register_event('mouse', function(type, x, y, delta, blocked)
    -- type 0 is hover
    -- type 1 is left click down
    -- type 2 is left click up
    -- type 4 is right click down
    -- type 5 is right click up
    -- type 7 is middle click down
    -- type 8 is middle click up
    -- type 10 is mouse wheel

    for row in ipairs(buttons) do
        color[row] = false
    end

    if window:hover(x, y) and window:visible() then
        local lines = window:text():count('\n') + 1
        local _, _y = window:extents()
        local pos_y = y - settings.box.pos.y
        local off_y = _y / lines
        local upper = 1
        local lower = off_y
        
        for row, button in ipairs(buttons) do
            if pos_y > upper and pos_y < lower then
                color[row] = true
                if type == 2 then
                    if button == 'followactive' and followactive then
                        follow_stop()
                    elseif button == 'followactive' and not followactive then
                        follow_start()
                    else
                        --settings[button] = not settings[button]
                    end
                    
                    if button == 'showgui' then
                        --window:hide()
                    end
                    
                    if button == 'followmanagergui' then
                        follow_manager_mode()
                    end
                    
                    if button == 'allfollowmegui' then
                        all_follow_me()
                    end
                    
                    if button == 'fd1' then
                        windower.send_ipc_message('multifollow d 1')
                        afollowdist = 1
                    end
                    
                    if button == 'fd5' then
                        windower.send_ipc_message('multifollow d 5')
                        afollowdist = 5
                    end
                    
                    if button == 'fd10' then
                        windower.send_ipc_message('multifollow d 10')
                        afollowdist = 10
                    end
                    
                    if button == 'fd21' then
                        windower.send_ipc_message('multifollow d 21')
                        afollowdist = 20.5
                    end

                    if S{'p1','p2','p3','p4','p5'}:contains(button) then
                        local party = windower.ffxi.get_party()
                        local member = party[button]
                        settings.ftarget = member.name
                    end
                end
            end

            upper = lower
            lower = lower + off_y
        end
    end
end)