local RSGCore = exports['rsg-core']:GetCoreObject()
local inCinema = false
local playing
local CinemaScreen
local startFilmHour
local canBuyTicket
local whereCanBuy = 0

Citizen.CreateThread(function()
	for k,v in pairs(Config.Cinemas) do
		local blip = Citizen.InvokeNative(0x554d9d53f696d002, 1664425300, v.EnterCinema)
		SetBlipSprite(blip, 103490298)
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, "Cinema")
	end
end)

Citizen.CreateThread(function()
    local targetCinema
	local targetCinema2
    while true do
        Wait(0)
        local PlayerPed = PlayerPedId()
        local coords = GetEntityCoords(PlayerPed)
        for i, info in pairs(Config.Cinemas) do
            if Vdist(coords , info.EnterCinema) < 2.0 then
                if targetCinema == nil then
                    targetCinema = i
                    local str2 = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", "Press ~INPUT_JUMP~ To Buy a Ticket", Citizen.ResultAsLong())
                    Citizen.InvokeNative(0xFA233F8FE190514C, str2)
                    Citizen.InvokeNative(0xE9990552DEC71600)
                end
				  if IsControlJustReleased(0, 0xD9D0E1C0) then
					if canBuyTicket and whereCanBuy == i then
						TriggerServerEvent("qbr-cinema:BuyTicket", i)
						end  
                    end
            else
                if targetCinema == i then
                    targetCinema = nil
					local blank = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", " ", Citizen.ResultAsLong())
					Citizen.InvokeNative(0xFA233F8FE190514C, blank)
					Citizen.InvokeNative(0xE9990552DEC71600)
                end
            end

            if Vdist(coords , info.ExitCinema) < 2.0 then
                if targetCinema2 == nil then
                    targetCinema2 = i
                    local str = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", "Press ~INPUT_JUMP~ to Exit The Theater", Citizen.ResultAsLong())
                    Citizen.InvokeNative(0xFA233F8FE190514C, str)
                    Citizen.InvokeNative(0xE9990552DEC71600) 
                end
				  if IsControlJustReleased(0, 0xD9D0E1C0) then
                        SetTvChannel(-1)
                        SetTextRenderId(0)
                        DoScreenFadeOut(800)
                        Wait(1000)
                        SetEntityCoords(PlayerPed, info.EnterCinema)
                        Wait(600)
                        DoScreenFadeIn(1500)
                        TaskGoToCoordAnyMeans(PlayerPed, info.AnimationCoord , 0.5, 0, false, 524419, -1.0)
                        EnableMovieSubtitles(false)
                        inCinema = false
                    end
				else
                if targetCinema2 == i then
                    targetCinema2 = nil
                    local blank = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", " ", Citizen.ResultAsLong())
					Citizen.InvokeNative(0xFA233F8FE190514C, blank)
					Citizen.InvokeNative(0xE9990552DEC71600)
                end
				
            end
			
			if Vdist(coords , info.ExitCinema) < 2.0 then
                if targetCinema3 == nil then
                    targetCinema3 = i
                    local str = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", "Press ~INPUT_JUMP~ to Exit The Theater", Citizen.ResultAsLong())
                    Citizen.InvokeNative(0xFA233F8FE190514C, str)
                    Citizen.InvokeNative(0xE9990552DEC71600) 
                end
				  if IsControlJustReleased(0, 0xD9D0E1C0) then
                        SetTvChannel(-1)
                        SetTextRenderId(0)
                        DoScreenFadeOut(800)
                        Wait(1000)
                        SetEntityCoords(PlayerPed, info.EnterCinema)
                        Wait(600)
                        DoScreenFadeIn(1500)
                        TaskGoToCoordAnyMeans(PlayerPed, info.AnimationCoord , 0.5, 0, false, 524419, -1.0)
                        EnableMovieSubtitles(false)
                        inCinema = false
                    end
				else
                if targetCinema3 == i then
                    targetCinema3 = nil
                    local blank = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", " ", Citizen.ResultAsLong())
					Citizen.InvokeNative(0xFA233F8FE190514C, blank)
					Citizen.InvokeNative(0xE9990552DEC71600)
                end
				
            end

        end

    end
end)


RegisterNetEvent('qbr-cinema:Teleport')
AddEventHandler('qbr-cinema:Teleport', function(id)
     DoScreenFadeOut(800)
      Wait(500)
      SetEntityCoords(PlayerPedId(), Config.Cinemas[id].ExitCinema)
      Wait(1000)
      DoScreenFadeIn(1000)
      inCinema = true
end)


Citizen.CreateThread(function()
    while true do
        Wait(1000)
        local hour = GetClockHours()
        local minute = GetClockMinutes()
        local PlayerPed = PlayerPedId()
        local coords = GetEntityCoords(PlayerPed)
        for i, info in pairs(Config.Cinemas) do
            if Vdist(coords , info.EnterCinema) < 25.0 then
                for _, info_2 in pairs(info.Listings) do
				 if hour == info_2.Hour - 1 and  minute > 30 and not playing and not canBuyTicket then
					canBuyTicket = true
					whereCanBuy = i
				 end
                    if hour == info_2.Hour and not playing then
                        StartMovie(i, info_2.MovieID)
						startFilmHour = hour
						canBuyTicket = true
						whereCanBuy = i
                    end
                end
            end
        end
    end
end)





function StartMovie (cinema , movieId)
    CinemaScreen = CreateObjectNoOffset(-349278483, Config.Cinemas[cinema].CinemaScreen.Coords, false, true, false, true)
    SetEntityRotation(CinemaScreen, 0.0, 0.0, Config.Cinemas[cinema].CinemaScreen.Rotation, 2, true)
    SetEntityVisible(CinemaScreen, true)
    SetEntityDynamic(CinemaScreen, true)
    SetEntityProofs(CinemaScreen, 31, true)
    FreezeEntityPosition(CinemaScreen, true)

    local handle = CreateNamedRenderTargetForModel("bla_theater", -349278483)
	Citizen.InvokeNative(0xC6ED9D5092438D91, 0)
    playing = true
    InputMovie(cinema, handle)
	Citizen.InvokeNative(0xDEC6B25F5DC8925B, 2, movieId , false )
	Citizen.InvokeNative(0x593FAF7FC9401A56, 2)
end



function InputMovie(cinema, handle)
Citizen.CreateThread(function()
    while playing do
        Wait(1)
		if inCinema then
        SetTvAudioFrontend(false)
        AttachTvAudioToEntity(CinemaScreen)
        SetTextRenderId(handle)
        SetScriptGfxDrawOrder(4)
        SetScriptGfxDrawBehindPausemenu(true)
        DrawTvChannel(0.5, 0.5, 1.1, 1.1, 0.0, 255, 255, 255, 50)
        SetTextRenderId(Citizen.InvokeNative(0x66F35DD9D2B58579))
        SetScriptGfxDrawBehindPausemenu(false)
		
        if inCinema then
            EnableMovieSubtitles(true)
        else
            EnableMovieSubtitles(false)
        end
		end
		local hour = GetClockHours()
        local minute = GetClockMinutes()
		local testhour = startFilmHour + 1
		if testhour == 24 then
			testhour = 0
		end
		if hour >= testhour and minute >= 14 then
			playing = false
			canBuyTicket = false
			whereCanBuy = 0
			DeleteObject(CinemaScreen)
		end
    
	end
end)
end


function  CreateNamedRenderTargetForModel (name , model)
    local handle = 0
    if  not IsNamedRendertargetRegistered(name) then
        RegisterNamedRendertarget(name, false)
    end
    if IsNamedRendertargetLinked(model) then
        LinkNamedRendertarget(model)
    end
    if IsNamedRendertargetRegistered(name) then
        handle = GetNamedRendertargetRenderId(name)
    end
    return handle
end





function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str, Citizen.ResultAsLong())
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
    SetTextCentre(centre)
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
    Citizen.InvokeNative(0xADA9255D, 10);
    DisplayText(str, x, y)
end