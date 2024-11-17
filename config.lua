CodeM = {}

CodeM.Locations = {
    vector3(241.727, 220.706, 106.286),
    vector3(150.266, -1040.203, 29.374),
    vector3(-1212.980, -330.841, 37.787),
    vector3(-2962.582, 482.627, 15.703),
    vector3(-112.202, 6469.295, 31.626),
    vector3(314.187, -278.621, 54.170),
    vector3(-351.534, -49.529, 49.042),
    vector3(1175.0643310547, 2706.6435546875, 38.094036102295),
}
CodeM.Color = "blue"



--[[
    default = https://cdn.discordapp.com/attachments/812677506984968202/871405353508671518/Screenshot_612.png
    lightblue = https://media.discordapp.net/attachments/812677506984968202/871405274936799292/Screenshot_611.png?width=1036&height=566
    blue = https://cdn.discordapp.com/attachments/812677506984968202/871405171882737704/Screenshot_610.png
    red = https://cdn.discordapp.com/attachments/812677506984968202/871405086688034866/Screenshot_609.png
    green = https://cdn.discordapp.com/attachments/812677506984968202/871405031608442880/Screenshot_608.png

]]

CDM = {}
CDM.Functions = {
    CreateBlips = function()
        for key, value in pairs(CodeM.Locations) do
        local blip = AddBlipForCoord(value.x,value.y,value.z)
        SetBlipSprite(blip, 108)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Bank")
        EndTextCommandSetBlipName(blip)
        end
    end
}