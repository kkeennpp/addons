_addon.name = 'AzureSubs'
_addon.version = '1'
_addon.author = 'Amaiya'
_addon.commands = {'asub','azuresubs','asubs'}

require('logger')
require('coroutine')
config = require('config')
res = require('resources')

defaults = {}
defaults.setspeed = 0.65
defaults.spellsets = {}
defaults.spellsets.tank1 = T{slot01='sandspin',slot02='cocoon',slot03='jettatura',slot04='screwdriver',
slot05='sheep song',slot06='terror touch',slot07='geist wall',slot08='healing breeze',
slot09='pollen',slot10='wild carrot',slot11='blank gaze',slot12='grand slam'}

defaults.spellsets.tank2 = T{slot01='sandspin',slot02='cocoon',slot03='jettatura',
slot04='screwdriver',slot05='sheep song',slot06='terror touch',slot07='geist wall',
slot08='healing breeze',slot09='pollen',slot10='wild carrot',slot11='blank gaze',
slot12='grand slam',slot13='frightful roar',slot14='stinking gas'}

settings = config.load(defaults)

function initialize()
    spells = res.spells:type('BlueMagic')
    get_current_spellset()
end

windower.register_event('load', initialize:cond(function() return windower.ffxi.get_info().logged_in end))
windower.register_event('login', initialize)
windower.register_event('job change', initialize:cond(function(subjob) return subjob == 16 end))

function set_spells(spellset)
    if windower.ffxi.get_player()['sub_job_id'] ~= 16 then
        error('Support job not set to Blue Mage.')
        return
    end
    if settings.spellsets[spellset] == nil then
        error('Set not defined: '..spellset)
        return
    end
    if S(settings.spellsets[spellset]):map(string.lower) == S(get_current_spellset()) then
        log(spellset..' was already equipped.')
        return
    end

    windower.ffxi.reset_blue_magic_spells()
    log('All spells removed.')
	coroutine.sleep(1)

    log('Starting to set '..spellset..'.')
    set_spells_from_spellset:schedule(settings.setspeed, spellset)
end

function set_spells_from_spellset(spellset)
    local setToSet = settings.spellsets[spellset]
    local currentSet = get_current_spellset()

    local slotToSetTo
    for i = 1, 20 do
        local slotName = 'slot%02u':format(i)
        if currentSet[slotName] == nil then
            slotToSetTo = i
            break
        end
    end
    
    if slotToSetTo ~= nil then
        -- We found an empty slot. Find a spell to set.
        for k,v in pairs(setToSet) do
            if not currentSet:contains(v:lower()) then
                if v ~= nil then
                    local spellID = find_spell_id_by_name(v)
                    if spellID ~= nil then
                        windower.ffxi.set_blue_magic_spell(spellID, tonumber(slotToSetTo))
                        --log('Set spell: '..v..' ('..spellID..') at: '..slotToSetTo)
                        set_spells_from_spellset:schedule(settings.setspeed, spellset)
                        return
                    end
                end
            end
        end
    end

    -- Unable to find any spells to set. Must be complete.
    log(spellset..' has been equipped.')
    windower.send_command('@timers c "Blue Magic Cooldown" 60 up')
end

function get_current_spellset()
    if windower.ffxi.get_player().sub_job_id ~= 16 then return nil end
    return T(windower.ffxi.get_sjob_data().spells)
    -- Returns all values but 512
    :filter(function(id) return id ~= 512 end)
    -- Transforms them from IDs to lowercase English names
    :map(function(id) return spells[id].english:lower() end)
    -- Transform the keys from numeric x or xx to string 'slot0x' or 'slotxx'
    :key_map(function(slot) return 'slot%02u':format(slot) end)
end

function find_spell_id_by_name(spellname)
    for spell in spells:it() do
        if spell['english']:lower() == spellname:lower() then
            return spell['id']
        end
    end
    return nil
end

function remove_all_spells()
    windower.ffxi.reset_blue_magic_spells()
    notice('All spells removed.')
end

function save_set(setname)
    if setname == 'default' then
        error('Please choose a name other than default.')
        return
    end
    local curSpells = T(get_current_spellset())
    settings.spellsets[setname] = curSpells
    settings:save('all')
    notice('Set '..setname..' saved.')
end

function delete_set(setname)
    if settings.spellsets[setname] == nil then
        error('Please choose an existing spellset.')
        return
    end    
    settings.spellsets[setname] = nil
    settings:save('all')
    notice('Deleted '..setname..'.')
end

function quit()
	windower.send_command('lua unload azuresubs')
end

windower.register_event('addon command', function(...)
    if windower.ffxi.get_player()['sub_job_id'] ~= 16 then
        error('Support job not set to Blue Mage.')
        return nil
    end
	local args = {...}
    if args ~= nil then
        if args[1]:lower() == 'removeall' then
            remove_all_spells()
        elseif args[1]:lower() == 'save' then
            if args[2] ~= nil then
                save_set(args[2])
            end
        elseif args[1]:lower() == 'delete' then
            if args[2] ~= nil then
                delete_set(args[2])
            end
        elseif args[1]:lower() == 'set' then
            if args[2] ~= nil then
                set_spells(args[2])
            end
        elseif args[1]:lower() == 'currentlist' then
            get_current_spellset():print()
        elseif args[1]:lower() == 'help' then
            windower.add_to_chat(200,'removeall -- Unsets all spells')
            windower.add_to_chat(200,'set <setname> -- Set (setname)\'s spells')
            windower.add_to_chat(200,'save <setname> -- Saves current spellset as (setname)')
            windower.add_to_chat(200,'delete <setname> -- Delete (setname) spellset')
            windower.add_to_chat(200,'currentlist -- Lists currently set spells')
        end
    end
end)