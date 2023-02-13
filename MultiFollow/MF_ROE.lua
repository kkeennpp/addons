require('coroutine')
packets = require('packets')

roe_ambus = {
    vol_one = 3998,
    vol_one_daily = 3758,
    vol_two = 3999,
    vol_two_daily = 3759,
    weekly = 3760,
    monthly = 3995,
}

roe_trove = {
    aman = 3768,
    home_point = 3769,
    auction = 3770,
    unity_chat = 3771,
    conquest = 3772,
    besieged = 3773,
    campaign = 3774,
    reive = 3775,
    ambuscade = 3776,
    omen = 3777,
    dynamis = 3778,
}

roe_vagary = {
    putraxia = 879,
    rancibus = 880,
    palloritus = 881,
    perfidien = 882,
    plouton = 883,
    putraxia_1 = 3400,
    putraxia_2 = 3401,
    rancibus_1 = 3402,
    rancibus_2 = 3403,
    palloritus_1 = 3404,
    palloritus_2 = 3405,
    perfidien_1 = 3406,
    perfidien_2 = 3407,
    plouton_1 = 3408,
    plouton_2 = 3409,
}

function all_ambu_set()
	start_roe(roe_ambus.vol_one_daily)
	coroutine.sleep(1)
	start_roe(roe_ambus.vol_one)
	coroutine.sleep(1)
	start_roe(roe_ambus.weekly)
	coroutine.sleep(1)
	start_roe(roe_ambus.monthly)
end

function all_trove_set()
	start_roe(roe_trove.aman)
	coroutine.sleep(1)
	start_roe(roe_trove.home_point)
	coroutine.sleep(1)
	start_roe(roe_trove.auction)
	coroutine.sleep(1)
	start_roe(roe_trove.unity_chat)
	coroutine.sleep(1)
	start_roe(roe_trove.ambuscade)
	coroutine.sleep(1)
	start_roe(roe_trove.omen)
	coroutine.sleep(1)
	start_roe(roe_trove.dynamis)
end

function all_vagary_set()
	start_roe(roe_vagary.putraxia_1)
	coroutine.sleep(1)
	start_roe(roe_vagary.putraxia_2)
	coroutine.sleep(1)
	start_roe(roe_vagary.rancibus_1)
	coroutine.sleep(1)
	start_roe(roe_vagary.rancibus_2)
	coroutine.sleep(1)
	start_roe(roe_vagary.palloritus_1)
	coroutine.sleep(1)
	start_roe(roe_vagary.palloritus_2)
	coroutine.sleep(1)
	start_roe(roe_vagary.perfidien_1)
	coroutine.sleep(1)
	start_roe(roe_vagary.perfidien_2)
	coroutine.sleep(1)
	start_roe(roe_vagary.plouton_1)
	coroutine.sleep(1)
	start_roe(roe_vagary.plouton_2)
end

function all_ambu_cancel()
	cancel_roe(roe_ambus.vol_one_daily)
	coroutine.sleep(1)
	cancel_roe(roe_ambus.vol_one)
	coroutine.sleep(1)
	cancel_roe(roe_ambus.weekly)
	coroutine.sleep(1)
	cancel_roe(roe_ambus.monthly)
end

function all_aman_cancel()
	cancel_roe(roe_trove.aman)
	coroutine.sleep(1)
	cancel_roe(roe_trove.home_point)
	coroutine.sleep(1)
	cancel_roe(roe_trove.auction)
	coroutine.sleep(1)
	cancel_roe(roe_trove.unity_chat)
	coroutine.sleep(1)
	cancel_roe(roe_trove.ambuscade)
	coroutine.sleep(1)
	cancel_roe(roe_trove.omen)
	coroutine.sleep(1)
	cancel_roe(roe_trove.dynamis)
end

function all_vagary_cancel()
	cancel_roe(roe_vagary.putraxia_1)
	coroutine.sleep(1)
	cancel_roe(roe_vagary.putraxia_2)
	coroutine.sleep(1)
	cancel_roe(roe_vagary.rancibus_1)
	coroutine.sleep(1)
	cancel_roe(roe_vagary.rancibus_2)
	coroutine.sleep(1)
	cancel_roe(roe_vagary.palloritus_1)
	coroutine.sleep(1)
	cancel_roe(roe_vagary.palloritus_2)
	coroutine.sleep(1)
	cancel_roe(roe_vagary.perfidien_1)
	coroutine.sleep(1)
	cancel_roe(roe_vagary.perfidien_2)
	coroutine.sleep(1)
	cancel_roe(roe_vagary.plouton_1)
	coroutine.sleep(1)
	cancel_roe(roe_vagary.plouton_2)
end

function start_roe(quest)
    local  p = packets.new('outgoing', 0x10C, {
        ['RoE Quest'] = quest,
    })
    packets.inject(p)
end

function cancel_roe(quest)
    local  p = packets.new('outgoing', 0x10D, {
        ['RoE Quest'] = quest,
    })
    packets.inject(p)
end