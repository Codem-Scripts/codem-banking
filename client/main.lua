
local bankingData = {
    opened = false,
    message = {
        action = true,
        data = nil,
        color = nil
    },
    updateMessage = {
        action = "updateBank",
        data = nil
    }
}


ESX = nil
Citizen.CreateThread(function()
    CDM.Functions.CreateBlips()


    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)



Citizen.CreateThread(function()

    for k,coords in pairs(CodeM.Locations) do
        exports["codem-notify"]:addNotif("E", "Codem Banking", 3.5, 2, coords)
    end

end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        local getPed = PlayerPedId()
        local entity = GetEntityCoords(getPed)
        for key,value in pairs(CodeM.Locations) do
            local dist = #(entity - value)
            if dist < 10 then
                if dist < 3 then
                    if IsControlJustPressed(0,38) then
                        Banking()  
                    end
                    if not bankingData.opened then
                        SendNUIMessage({
                            action = "draw",
                            color = CodeM.Color
                        })
                    end
                    break
                else
                    SendNUIMessage({
                        action = "stopDraw"
                    })
                end
            end
        end
    end
end)

RegisterNetEvent('qb-phone:client:RemoveBankMoney')
AddEventHandler('qb-phone:client:RemoveBankMoney', function(amount)
    TriggerServerEvent('codem:moneySpent', amount)

end)

RegisterNUICallback("codem:Deposit", function(data,cb)


    ESX.TriggerServerCallback("codem:depositCheck",function(result)
        if result then
            cb(result.test)
            SendNUIMessage({
                action = "updateBankBalance",
                value = result.value,
                type = result.type
            })
        else
            cb(false)
        end
    end, data.amount)
end)




RegisterNetEvent('codem:updateBankHistory')
AddEventHandler('codem:updateBankHistory', function()

    if bankingData.opened then
        ESX.TriggerServerCallback("codem:getPlayerTransactionHistory", function(playerhistory)
        
            SendNUIMessage({
                action = "setTransactionHistory",
                transactionHistory = playerhistory,
            })
        end)
    end
end)


RegisterNUICallback('codem:TransferMoney', function(data, cb) 

    local citizenid = data.citizenid;
    local amount = data.amount

   ESX.TriggerServerCallback("codem:transferMoneyToPlayer", function(val) 

        print(json.encode(val))
        cb(val)
    end, {amount = amount, citizenid = citizenid })

end)
RegisterNUICallback('codem:RequestPlayers', function(data,cb) 

    ESX.TriggerServerCallback("codem:getAllPlayers",function(result)
        if result then
            cb(result)
        else
            cb(false)
        end
    end)
end)



RegisterNUICallback("codem:WithDraw", function(data,cb)
    ESX.TriggerServerCallback("codem:withDrawCheck",function(result)
        if result then
        cb(result.test)
        SendNUIMessage({
            action = "updateBankBalance",
            value = result.value,
            type = result.type
        })
        else
            cb(false)
        end
    end, data.amount)
end)



local blur = "MenuMGIn"

Banking = function()
    if bankingData.opened == false then
        if bankingData.message.data == nil then

            ESX.TriggerServerCallback("codem:fetchAllInfos",function(parameterOne)
                bankingData.message.data = parameterOne
                if bankingData.message.color == nil then
                    bankingData.message.color = CodeM.Color
                end
                SendNUIMessage(bankingData.message)
                SendNUIMessage({
                    action = "stopDraw"
                })

                StartScreenEffect(blur, 1, true)
                bankingData.opened = true
                SetNuiFocus(bankingData.opened, bankingData.opened)

                TriggerEvent("codem:updateBankHistory")

            end)
            
        end
    end
end


RegisterNUICallback('codem:CloseNUI', function()
    Close()
end)



RegisterNUICallback('codem:SaveInvoice', function(data,cb)
    ESX.TriggerServerCallback("codem:server:SaveInvoice",function(result)
        if result then
            cb(true)
        else
            cb(false)
        end
    end, data)
end)



RegisterNUICallback('codem:GetTotalBills', function(data, cb)
    ESX.TriggerServerCallback("codem:server:GetTotalBills", function(result)
        cb(result)
    end)
end)

RegisterNUICallback('codem:FetchInvoice', function(data, cb)
    ESX.TriggerServerCallback("codem:server:FetchInvoice", function(result)
        cb(result)
    end, data)
end)

Close = function()
    StopScreenEffect(blur)

    bankingData.opened = false
    SetNuiFocus(bankingData.opened, bankingData.opened)
    bankingData.message.data = nil
end
