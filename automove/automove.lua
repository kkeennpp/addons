mvmt_gear = {
    feet = {
        WHM = "Herald's Gaiters",
        BLM = "Herald's Gaiters",
        SCH = "Herald's Gaiters",
        SMN = "Herald's Gaiters",
        GEO = "Herald's Gaiters",
        MNK = "Herald's Gaiters",
    
        WAR = "Hermes' Sandals",
        PUP = "Hermes' Sandals",

        SAM = "Danzo Sune-Ate",
        NIN = "Danzo Sune-Ate",

        BRD = "Fili Cothurnes +1",
    },

    legs = {
        DRK = "Carmine Cuisses +1",
        DRG = "Carmine Cuisses +1",
        COR = "Carmine Cuisses +1",
        RNG = "Carmine Cuisses +1",
        RDM = "Carmine Cuisses +1",
        BLU = "Carmine Cuisses +1",
        PLD = "Carmine Cuisses +1",
        RUN = "Carmine Cuisses +1",
    },
}

moving = false
mov_counter = 0

windower.register_event('load', function()
    player = windower.ffxi.get_player()
    if (player == nil) then return end
    player.x = windower.ffxi.get_mob_by_index(player.index).x
    player.y = windower.ffxi.get_mob_by_index(player.index).y
    player.z = windower.ffxi.get_mob_by_index(player.index).z
end)

windower.register_event('login', function()
    player = windower.ffxi.get_player()
	coroutine.sleep(1)
    player.x = windower.ffxi.get_mob_by_index(player.index).x
    player.y = windower.ffxi.get_mob_by_index(player.index).y
    player.z = windower.ffxi.get_mob_by_index(player.index).z
end)

 windower.register_event('job change', function()
    player = windower.ffxi.get_player()
    player.x = windower.ffxi.get_mob_by_index(player.index).x
    player.y = windower.ffxi.get_mob_by_index(player.index).y
    player.z = windower.ffxi.get_mob_by_index(player.index).z
end)

windower.register_event('prerender', function()
    mov_counter = mov_counter + 1;
    if mov_counter > 10 then
        if (player == nil) then return end
        local pl = windower.ffxi.get_mob_by_target('me')
        if (mvmt_gear.feet[player.main_job] == nil) and (mvmt_gear.legs[player.main_job] == nil) then return end
        if pl and pl.x and player.x then
            dist = math.sqrt( (pl.x-player.x)^2 + (pl.y-player.y)^2 + (pl.z-player.z)^2 )
            if dist > 1 and not moving then
	            --windower.add_to_chat(200,"now moving")
                plr = windower.ffxi.get_player()
				if plr.in_combat then
                    moving = true
                else
					windower.send_command('gs equip sets.Idle.MVMT')
	                --windower.add_to_chat(200,"equiping")
                    moving = true
                end
            elseif dist < 1 and moving then
	            --windower.add_to_chat(200,"stopped moving")
                windower.send_command('gs c update')
                moving = false
            end
        end
        if pl and pl.x then
            player.x = pl.x
            player.y = pl.y
            player.z = pl.z
        end
        mov_counter = 0
    end
end)