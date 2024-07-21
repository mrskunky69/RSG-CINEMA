local RSGCore = exports['rsg-core']:GetCoreObject()

RegisterServerEvent('qbr-cinema:BuyTicket')
AddEventHandler('qbr-cinema:BuyTicket', function (id)
--print("test")
	local src = source
	local Player = RSGCore.Functions.GetPlayer(src)
    local money = Player.Functions.GetMoney("cash")	   
	if money - 10 >= 0 then
		TriggerClientEvent('qbr-cinema:Teleport',src ,id)
		Player.Functions.RemoveMoney("cash", 10)
		else
		RSGCore.Functions.Notify(source, 'you don\'t have enough money!', 'error')
	end
end)