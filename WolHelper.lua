local errr, SE = pcall(require, 'lib.samp.events')
assert(errr, 'Library SAMP Events not found')

local errr, inicfg = pcall(require, 'inicfg')
assert(errr, 'Library INI cfg not found')

local res = pcall(require, "lib.moonloader")
assert(res, 'Library lib.moonloader not found')

local errr, sf = pcall(require, 'sampfuncs')
assert(errr, 'Library Sampfuncs not found')

local errr, rkeys = pcall(require, 'rkeys')
assert(errr, 'Library rKeys not found')

local errr, vkeys = pcall(require, 'vkeys')
assert(errr, 'Library vKeys not found')

local errr, re = pcall(require, 're') -- LPeg
assert(errr, 'Library LPeg not found')

local lanes = require('lanes').configure()
local errr, encoding = pcall(require, 'encoding')
assert(errr, 'Library Encoding not found')

local errr, imgui = pcall(require, 'imgui')
assert(errr, 'Library Imgui not found')

local errr, imadd = pcall(require, 'imgui_addons')
assert(errr, 'Library Imgui Addons not found')

local errr, pie = pcall(require, 'imgui_piemenu2')
assert(errr, 'Library Pie Menu not found')

local errr, notf = pcall(import, 'imgui_notf.lua')
assert(errr, 'Library Imgui Notification not found')

local idnotf = script.find('imgui_notf.lua')


encoding.default = 'CP1251'
u8 = encoding.UTF8


script_name('Way_Of_Life_Helper')
script_version('2.1.3')
script_author('Saburo Shimizu')



picups = {
    ['Clotch'] = 58, -- Пикап магазина одежды
    avtosalon = {
        [1] = 92, -- Пикап магазина одежды
        [2] = 91, -- Пикап магазина одежды
        [3] = 90, -- Пикап магазина одежды
    },
    blackjob = {
        [1] = 95, -- Автоугонщик
        [2] = 95, -- Автоугонщик
    },
}

getgunses = {
    [1] = 100, -- LSPD
    [2] = 99, -- FBI
    [3] = 28, -- SWAT
    [4] = 37, -- ВВС
    [5] = 57, -- Army LV
    [6] = 56, -- Army SF
    [7] = 218, -- Meria
    [8] = 225, -- Pra-vo
    [9] = hitmangun, -- Hitmans
    [10] = Ballas, -- Hitmans
    [11] = Vagos, -- Hitmans
    [12] = Grove, -- Hitmans
    [13] = Actec, -- Hitmans
    [14] = Rifa, -- Hitmans
}

bandgun = {
    [10] = {2002, - 1121, 27}, --Ballas
    [11] = {2784, - 1611, 11}, -- Vagis
    [12] = {2492, - 1670, 13}, -- Grove
    [13] = {1671, - 2113, 14}, -- Aztec
    [14] = {2186, - 1807, 13}, -- Rifa
}





dhelp = [[{FF7000}/wolgun - {d5dedd}Взять оружие с любого места
{FF7000}/getjob - {d5dedd}Взять пикап с трудоустройством с любого места
{FF7000}/swatgun - {d5dedd}Автоматически взять оружие
{FF7000}/getstat - {d5dedd}Принудительная проверка статистики
{FF7000}/wolhelp - {d5dedd}Помощь по скрипту
{FF7000}/wolreload - {d5dedd}Перезагрузка скрипта
{FF7000}/wolmenu - {d5dedd}Меню скрипта
{FF7000}/woltp [+ id] - {d5dedd}Меню с телепортами. [ТП к игроку]
{FF7000}/woldamag - {d5dedd}Дамажит игрока
{FF7000}/woldamags - {d5dedd}Убивает игрока
{FF7000}/woldamager [+ id] - {d5dedd}Убивает всех игроков в зоне стрима. [Убивает всех кроме ID]
{FF7000}/wolpomeha - {d5dedd}Постоянно убивает игрока + не даёт ему заспавниться
{FF7000}/wolleader - {d5dedd}Открыть панель лидеров
{FF7000}/wolcarhp [+ кол-во] - {d5dedd}Поменять транспорту хп (Если ничего не указать - восстановит)
{FF7000}/wolarmor [+ кол-во] - {d5dedd}Добавить армор (Если 0, то снимет)
{FF7000}/wolstroy - {d5dedd}Открыть автострой


{FF0000} В [ ] указаны необязательные параметры
{FF0000} Дополнительные настройки в INI файле]]


-- INI FILES

local inicfg = require 'inicfg'


-- INI FILES

local default = {
    WOL = {
        org = true;
        autogun = true;
        mvd = true;
        gun = 140;
        aupd = true;
        wolpass = 0;
        wolalogin = false;
        damag = 4;
    }
}

local restore = {
    WOL = {
        org = true;
        autogun = true;
        mvd = true;
        gun = 140;
        aupd = true;
        wolpass = 0;
        wolalogin = false;
        damag = 4;
    }
}

local ini = inicfg.load(default, 'Way_Of_Life_Helper.ini')

wol = ini.WOL


local tpfindresult = false
local teg = '{FF0000}[WolHelper] {FFFFFF}'
local sw, sh = getScreenResolution()
local orgs = nil
local getstat = false
local swatgun = false
local naambs = 1
local findkolvo = 0
local findshow = false
local blockcarhp = false
local carhpthread = nil
local findshowtable = {}
local vstroy, nevstroy, ryadom = {}, {}, {}

imgui.Process = false
local btn_size = imgui.ImVec2(-0.1, 0)
local scriptmenu = imgui.ImBool(false)
local imguifaq = imgui.ImBool(false)
local tporg = imgui.ImBool(false)
local picupsimgui = imgui.ImBool(false)
local superkillerubiza = imgui.ImBool(false)
local findimgui = imgui.ImBool(false)
local wolleader = imgui.ImBool(false)
local trenirovkaimgui = imgui.ImBool(false)

local imguiautogun = imgui.ImBool(wol.autogun)
local imguimvd = imgui.ImBool(wol.mvd)
local imguiaupd = imgui.ImBool(wol.aupd)
local imguiaulog = imgui.ImBool(wol.wolalogin)
local imguiautoinv = imgui.ImBool(wol.org)
local imguipass = imgui.ImBuffer(256)
local picupid = imgui.ImInt(0)
local damagersuska = imgui.ImInt(wol.damag)
local superkillerubizaid = imgui.ImInt(0)
local superkillerubizarezhim = imgui.ImInt(0)
local wolleadermenu = imgui.ImInt(0)
local customsendchat = imgui.ImBuffer(1024)
local imguifile = imgui.ImBuffer(256)
imguipass.v = wol.wolpass


local killerrezhim = {
    [0] = u8'Убить',
    [1] = u8'Помеха',
    [2] = u8'Урон (49)',
}

local govmenu = {
    [0] = u8'Начало собеседования',
    [1] = u8'Напоминание о собеседовании (1)',
    [2] = u8'Напоминание о собеседовании (2)',
    [3] = u8'Конец собеседования',
}


function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    local ip = sampGetCurrentServerAddress()

    if ip:find('176.32.36.103') or ip:find('176.32.39.159') then activ = true sampAddChatMessage('{FF0000}AutoInvite {FFFFFF}для {00FF00}Way Of Life и After Life {01A0E9}загружен', - 1) sampAddChatMessage(teg ..'/wolhelp - команды скрипта. Версия скрипта: {d5dedd}' ..thisScript().version, - 1) sampAddChatMessage(teg ..'Если ваша статистика не была проверена автоматически введите {FF7000}/getstat', - 1) if wol.mvd then if script.find('MVDhelper Era') then script.find('MVDhelper Era'):unload() end end else thisScript():unload() end

    if script.find('PrisonHelper.lua') then script.find('PrisonHelper.lua'):unload() end
    if aupd == true then apdeit() end
    if not doesDirectoryExist(getWorkingDirectory() ..'/WolHelper') then
        createDirectory(getWorkingDirectory() ..'/WolHelper')
        local file = io.open(getWorkingDirectory() ..'/WolHelper/начало_собеса.txt', 'w+')
        file:close()
        local file = io.open(getWorkingDirectory() ..'/WolHelper/конец_собеса.txt', 'w+')
        file:close()
        local file = io.open(getWorkingDirectory() ..'/WolHelper/первая_напоминалка_собеса.txt', 'w+')
        file:close()
        local file = io.open(getWorkingDirectory() ..'/WolHelper/вторая_напоминалка_собеса.txt', 'w+')
        file:close()
    end
    if not doesDirectoryExist(getWorkingDirectory() ..'/WolHelper/Binder/') then
        createDirectory(getWorkingDirectory() ..'/WolHelper/Binder/')
        local file = io.open(getWorkingDirectory() ..'/WolHelper/Binder/Info.txt', 'w+')
        file:write('Введите текст\nДля установки задержки используйте wait(время в мс) в новой строчке\nПример:\n/me достал Desert Eagle\nwait(1000)\n/me снял предохранитель')
        file:close()
    end
    --imgui.Process = true
    sampRegisterChatCommand('swatgun', function(nambs) if nambs == '1' or nambs == '0' then naambs = nambs else sampAddChatMessage(teg ..'Вы введи неправильно команду. {FF7000}/swatgun [0-1]', - 1) end end)
    sampRegisterChatCommand('wolgun', wolgun)
    sampRegisterChatCommand('members', function() sampSendChat('/members') findimgui.v = true end)
    sampRegisterChatCommand('getjob', function() sampSendPickedUpPickup(168) end)
    sampRegisterChatCommand('getstat', function() getstat = true sampSendChat('/mm') end)
    sampRegisterChatCommand('wolhelp', function() imguifaq.v = true end)
    sampRegisterChatCommand('wolreload', function() thisScript():reload() end)
    sampRegisterChatCommand('wolmenu', function() scriptmenu.v = true end)
    sampRegisterChatCommand('woltp', function(res) if res:find('%d+') then sampSendChat('/find '..res) tpfindresult = true else tporg.v = true end end)
    sampRegisterChatCommand('woldamag', function(id) if not id:find('%d+') then sampAddChatMessage(teg ..'Не правильно введён ID', - 1) return else sampSendGiveDamage(id, 49, 24, 9) end end)
    sampRegisterChatCommand('wolsu', function(id) sampSendTakeDamage(id, 49, 24, 9) end)
    sampRegisterChatCommand('woldamags', function(id) if not id:find('%d+') then sampAddChatMessage(teg ..'Не правильно введён ID', - 1) return else lua_thread.create(function() for i = 0, wol.damag do sampSendGiveDamage(id, 49, 24, 9) wait(90) end end) end end)
    sampRegisterChatCommand('woldamager', damagerblyt)
    sampRegisterChatCommand('wolpomeha', pomehaska)
    sampRegisterChatCommand('wolcarhp', wolcarhp)
    sampRegisterChatCommand('wolarmor', wolarmor)
    sampRegisterChatCommand('vig', vigovor)
    sampRegisterChatCommand('uninvite', uninviteska)
    sampRegisterChatCommand('wolstroy', function() sampSendChat('/members') trenirovkaimgui.v = true end)
    sampRegisterChatCommand('suninvite', function(arg) sampSendChat('/uninvite '..arg) end)
    sampRegisterChatCommand('wolleader', function() wolleader.v = true end)

    if not doesFileExist('moonloader\\config\\Way_Of_Life_Helper.ini') then inicfg.save(default, 'Way_Of_Life_Helper.ini') sampAddChatMessage(teg ..'Ini файл был создан.', - 1) end


    rkeys.registerHotKey({vkeys.VK_MENU, vkeys.VK_1}, true, function() if not superkillerubiza.v then superkillerubiza.v = true end end)
    rkeys.registerHotKey({vkeys.VK_RETURN}, true, function()
        if findimgui.v then findimgui.v = false end
        if trenirovkaimgui.v then trenirovkaimgui.v = false end
        if superkillerubiza.v then
            if superkillerubizarezhim.v == 0 then
                lua_thread.create(function() for i = 0, wol.damag do sampSendGiveDamage(superkillerubizaid.v, 49, 24, 9) wait(90) end end)
            end
            if superkillerubizarezhim.v == 1 then pomehaska(tostring(superkillerubizaid.v)) end
            if superkillerubizarezhim.v == 2 then sampSendGiveDamage(superkillerubizaid.v, 49, 24, 9) end
        end
    end)

    imgui.Process = true

    showCursor(false, false)

    while true do
        --imgui.Process = scriptmenu.v or imguifaq.v or tporg.v or picupsimgui.v or superkillerubiza.v or findimgui.v
        -- LOAD PARAMS
        wol = ini.WOL
        aupd = wol.aupd
        adownload = wol.adownload
        org = wol.org
        hide = wol.hide
        autogun = wol.autogun
        mvd = wol.mvd
        gun = wol.gun
        wolpass = wol.wolpass
        wolalogin = wol.wolalogin
        wait(0)
    end
end

function checkmenu()
    local my_dialoges = {
        {
            title = string.format('My stat: %s', stat and 'Вкл' or 'Выкл')
        }
    }
end

function menu()
    checkmenu()
    submenus_show(my_dialoges, 'Ebat', 'Ok', 'Ne ok!', 'Nozad')
    if stat == false then stat = true else stat = false end
end


function pickupid(model)
    local poolPtr = sampGetPickupPoolPtr()
    local ptwo = readMemory(poolPtr, 4, 0)
    if ptwo > 0 then
        ptwo = poolPtr + 0x4
        local pthree = poolPtr + 0xF004
        for id = 1, 4096 do
            local pfive = readMemory(ptwo + id * 4, 4, false)
            if pfive < 0 or pfive > 0 then
                pfive = readMemory(pthree + id * 20, 4, false)
                if pfive == 353 then
                    return id
                end
            end
        end
    end
end



function getorg(orges)
    if orges:find('LSPD') then return 1 end
    if orges:find('FBI') then return 2 end
    if orges:find('S.W.A.T') then return 3 end
    if orges:find('ВВС') then return 4 end
    if orges:find('Army LV') then return 5 end
    if orges:find('Army SF') then return 6 end
    if orges:find('Мэрия') then return 7 end
    if orges:find('Правительство') then return 8 end
    if orges:find('Hitmans') then return 9 end
    if orges:find('Ballas Gang') then return 10 end
    if orges:find('Vagos Gang') then return 11 end
    if orges:find('Grove Street Gang') then return 12 end
    if orges:find('Aztecas Gang') then return 13 end
    if orges:find('Rifa Gang') then return 14 end
end


function SE.onServerMessage(color, text)
    if text:find('.+Вы успешно авторизовались!') then getstat = true sampSendChat('/mm') end
    if text:find('Выдано:   Дубинка') and swatgun then return false end
    --if re.match(text, 's <- {.+} / . s') then sampAddChatMessage(text, -1) end
    if text:find('Члены организации Online') then findshowtable, vstroy, nevstroy, ryadom = {}, {}, {}, {} findshow = true return false end
    if findshow and text:find('ранг') then
        local id, nick, rang = text:match('%[(%d+)%] (%a+_%a+) ранг: (.+) ')
        local name = nick ..' ['..id..']' findshowtable[name] = rang
        local result, ped = sampGetCharHandleBySampPlayerId(id)
        if doesCharExist(ped) then
            local x, y, z = getCharCoordinates(ped)
            local mx, my, mz = getCharCoordinates(PLAYER_PED)
            local dist = getDistanceBetweenCoords3d(mx, my, mz, x, y, z)

            if dist <= 25 then
                vstroy[name] = rang
            else
                ryadom[name] = rang
            end
        else
            nevstroy[name] = rang
        end
        return false
    end
    if text:find('Всего: %d+ человек') then
        findkolvo = text:match('Всего: (%d+) человек')
        findshow = false
        return false
    end
end

function SE.onShowDialog(dialogId, style, title, button1, button2, text)
    if wolalogin == true then
        if title == '{AEFFFF}Авторизация' then
            if text:find('.+Попыток: %d+ из %d+.+') then
                sampAddChatMessage(teg ..'Вы ввели неправильно пароль. Для смены пароля введите /wolpass', - 1)
            else
                sampSendDialogResponse(dialogId, 1, - 1, wolpass)
            end
        end
    end
    if activ then
        if title == '{FFFFFF}RolePlay Тест | Вопрос {FFC100}№1' then sampSendDialogResponse(dialogId, 1, - 1, '2') end
        if title == '{FFFFFF}RolePlay Тест | Вопрос {FFC100}№2' then sampSendDialogResponse(dialogId, 1, - 1, '4') end
        if title == '{FFFFFF}RolePlay Тест | Вопрос {FFC100}№3' then sampSendDialogResponse(dialogId, 1, - 1, '1') end
        if title == '{FFFFFF}RolePlay Тест | Вопрос {FFC100}№4' then sampSendDialogResponse(dialogId, 1, - 1, '1') end
        if title == '{FFFFFF}RolePlay Тест | Вопрос {FFC100}№5' then sampSendDialogResponse(dialogId, 1, - 1, '3') end
        if title == '{FFFFFF}RolePlay Тест | Вопрос {FFC100}№6' then sampSendDialogResponse(dialogId, 1, - 1, '2') end
        if title == '{FFFFFF}RolePlay Тест | Вопрос {FFC100}№7' then sampSendDialogResponse(dialogId, 1, - 1, '4') lua_thread.create(function() wait(500) getstat = true sampSendChat('/mm') end) end
    end
    if getstat == true then
        if title:find('{AEFFFF}Игровой уровень: %d+ | Очки опыта: %d+ из %d+') then
            sampSendDialogResponse(5051, 1, 0, _)
            return false
        end
        if title:find('{33AA33}Статистика игрового аккаунта:{ffffff} .+') then
            warn = text:match('.+(%d+)/.+Уровень Преступлений:.+')
            orges = text:match('.+Организация:.+%{ffffff}(.+)Ранг:.+')
            orgs = getorg(orges)
            getstat = false
            if warn ~= '0' then sampAddChatMessage(teg ..'Ваша организация: '..orges, - 1) sampAddChatMessage(teg ..'На вашем аккаунте имеется {FF7000}' ..warn ..' {FFFFFF}варн(а). Рекомендуем снять для избежания бана!', - 1) return false
            else
                sampAddChatMessage(teg ..'Ваш аккаунт чист. Ваша организация: '..orges ..'.', - 1)
                return false
            end
        end
    end
    if swatgun == true then
        if title == 'Комплекты « SWAT » San Andreas' then for i = 0, gun * 4 do sampSendDialogResponse(dialogId, tonumber(naambs), - 1, - 1) end lua_thread.create(function() wait(10000) swatgun = false end) end
    end
    if autogun == true and title:find('Набор.+') and dialogId == 5051 then
        sampSendDialogResponse(dialogId, 1, 0, 1)
        for i = 0, gun do
            sampSendDialogResponse(dialogId, 1, 3, 1)
            sampSendDialogResponse(dialogId, 1, 4, 1)
            sampSendDialogResponse(dialogId, 1, 5, 1)
            sampSendDialogResponse(dialogId, 1, 6, 1)
        end
    end
end



function wolgun()
    lua_thread.create(function()
        if orgs == nil then getstat = true sampSendChat('/mm') end
        while orgs == nil do wait(0) end
        if orgs < 9 and orgs ~= 3 then
            sampSendPickedUpPickup(getgunses[orgs])
        elseif orgs == 9 then
            hitmangun()
        elseif orgs == 3 then
            swatgun = true sampSendPickedUpPickup(getgunses[orgs])
        elseif orgs >= 10 then
            ganggun(orgs)
        end
    end)
end

function damagerblyt(nid)
    local nekill = nil
    if nid:find('%d+') then nekill = tonumber(nid) end
    lua_thread.create(function()
        local peds = getAllChars()
        for i = 0, #peds do
            local _, id = sampGetPlayerIdByCharHandle(peds[i])
            local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
            local result = sampIsPlayerPaused(id)
            if nekill == nil then nekill = myid end
            if not result and id ~= myid and id ~= nekill then
                for z = 0, wol.damag do
                    sampSendGiveDamage(id, 49, 24, 9)
                    wait(90)
                end
                wait(200)
            end
        end
        notf.addNotification('Дамагер выключен', 5, 2)
    end)
end

function pomehaska(id)
    if not id:find('%d+') then
        notf.addNotification('WolHelper\n\nОшибка. Используйте /wolpomeha ID', 5, 3)
        return
    end
    --sampAddChatMessage(teg ..'Не правильно введён ID', -1) return end
    local name = sampGetPlayerNickname(id)
    if dmg ~= true then
        lua_thread.create(function()
            dmg = true
            --sampAddChatMessage(teg ..'Убиватор на ' ..name ..'['..id..'] включён', - 1)
            notf.addNotification('WolHelper\n\nУбиватор на ' ..name ..'['..id..'] включён', 5, 1)
            local con = sampIsPlayerConnected(id)
            while dmg and con do
                con = sampIsPlayerConnected(id)
                sampSendGiveDamage(id, 49, 24, 9)
                wait(0)
            end
            dmg = false
            if not con then
                --sampAddChatMessage(teg ..'Убиватор выключен. Жертва оффнулась', -1)
                notf.addNotification('WolHelper\n\nУбиватор выключен. Жертва оффнулась', 5, 1)
            end
        end)
    else
        dmg = false
        --sampAddChatMessage(teg ..'Убиватор на ' ..name ..'['..id..'] выключен', - 1)
        notf.addNotification('WolHelper\n\nУбиватор на ' ..name ..'['..id..'] выключен', 5, 1)
    end
end


--ОБНОВА

function apdeit()
    async_http_request('GET', 'https://raw.githubusercontent.com/SaburoShimizu/WOL/master/WOLVER', nil --[[параметры запроса]],
        function(resp) -- вызовется при успешном выполнении и получении ответа
            local suk = resp.text
            newvers = suk:match('Version = (.+), URL.+') if newvers > thisScript().version then sampAddChatMessage(teg ..'Обнаружено обновление до v.{FF0000}'..newvers ..'{01A0E9}. Для обновления используйте /wolmenu', - 1) elseif newvers == thisScript().version then sampAddChatMessage(teg..'У вас актуальная версия скрипта.', - 1) elseif newvers < thisScript().version then sampAddChatMessage(teg..'У вас тестовая версия скрипта.', - 1) end
            print('Проверка обновления')
        end,
        function(err) -- вызовется при ошибке, err - текст ошибки. эту функцию можно не указывать
            print(err)
            sampAddChatMessage(teg ..'Ошибка поиска версии. Попробуйте позже.', - 1)
    end)
end



function updates()
    async_http_request('GET', 'https://raw.githubusercontent.com/SaburoShimizu/WOL/master/WolHelper.lua', nil --[[параметры запроса]],
        function(respe) -- вызовется при успешном выполнении и получении ответа
            if #respe.text > 0 then
                f = io.open(getWorkingDirectory() ..'/WolHelper.lua', 'wb')
                f:write(u8:decode(respe.text))
                f:close()
                sampAddChatMessage(teg ..'Обновление успешно скачалось. Скрипт перезапуститься автоматически', - 1)
                thisScript():reload()
            else
                sampAddChatMessage(teg ..'Ошибка обновления. Попробуйте позже', - 3)
            end
            print('Установка обновления скрипта')
        end,
        function(err) -- вызовется при ошибке, err - текст ошибки. эту функцию можно не указывать
            print(err)
            sampAddChatMessage(teg ..'Ошибка обновления. Попробуйте позже.', - 1)
    end)
end





function imgui.OnDrawFrame()
    imgui.ShowCursor = scriptmenu.v or imguifaq.v or tporg.v or picupsimgui.v or superkillerubiza.v or findimgui.v or wolleader.v or trenirovkaimgui.v
    if scriptmenu.v then
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(400, 300), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Настройки WolHelper', scriptmenu, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.MenuBar)
        if imgui.BeginMenuBar() then
            if imgui.BeginMenu(u8'Меню скрипта') then
                if imgui.MenuItem(u8'Перезагрузить') then
                    showCursor(false, false)
                    thisScript():reload()
                end
                if imgui.MenuItem(u8'Выключить') then
                    showCursor(false, false)
                    thisScript():unload()
                end
                imgui.EndMenu()
            end
            if imgui.BeginMenu(u8'Обновление') then
                if imgui.MenuItem(u8'Проверка обновления') then
                    apdeit()
                end
                if imgui.MenuItem(u8'Принудительно обновиться') then
                    updates()
                    scriptmenu.v = false
                    showCursor(false, false)
                end
                imgui.EndMenu()
            end
            if imgui.BeginMenu(u8'Функции') then
                if imgui.MenuItem(u8'ТП меню') then
                    tporg.v = true
                    scriptmenu.v = false
                end
                if imgui.MenuItem(u8'Меню пикапов') then
                    picupsimgui.v = true
                    scriptmenu.v = false
                end
                if imgui.MenuItem(u8'Взять оружие') then
                    if orgs ~= nil then sampSendPickedUpPickup(getgunses[orgs]) else sampAddChatMessage(teg ..'Организация не определена', - 1) end
                    scriptmenu.v = false
                end
                if imgui.MenuItem(u8'Трудоустройство') then
                    sampSendPickedUpPickup(168)
                    scriptmenu.v = false
                end
                if imgui.MenuItem(u8'Проверка статистики') then
                    getstat = true sampSendChat('/mm')
                end
                imgui.EndMenu()
            end
            if imgui.BeginMenu('F.A.Q') then
                if imgui.MenuItem(u8'Показать F.A.Q') then
                    imguifaq.v = true
                    scriptmenu.v = false
                end
                imgui.EndMenu()
            end
            imgui.EndMenuBar()
            imgui.Text(u8'Автоматическое обновление')
            imgui.SameLine(365)
            imadd.ToggleButton('ainv##6', imguiaupd)
            wol.aupd = imguiaupd.v
            imgui.Text(u8'Автоинвайт')
            imgui.SameLine(365)
            imadd.ToggleButton('ainv##6', imguiautoinv)
            wol.org = imguiautoinv.v
            imgui.Text(u8'Автоган')
            imgui.SameLine(365)
            imadd.ToggleButton('autogun##6', imguiautogun)
            wol.autogun = imguiautogun.v
            imgui.Text(u8'Выключать MVD helper')
            imgui.SameLine(365)
            imadd.ToggleButton('mvd##6', imguimvd)
            wol.mvd = imguimvd.v
            imgui.Text(u8'Автологин')
            imgui.SameLine(365)
            imadd.ToggleButton('alogin##6', imguiaulog)
            wol.wolalogin = imguiaulog.v
            if imguiaulog.v then
                imgui.InputText(u8'Введите пароль', imguipass)
                imgui.Text(u8'Текущий пароль: '..wol.wolpass)
                wol.wolpass = u8:decode(imguipass.v)
            end
            imgui.Spacing()
            imgui.Separator()
            imgui.Spacing()
            imgui.SliderInt(u8'Кол-во отправлений урона', damagersuska, 1, 15)
            wol.damag = damagersuska.v
            imgui.Spacing()
            imgui.Separator()
            imgui.Spacing()
            if imgui.MenuItem(u8'Сохранить настройки в INI') then inicfg.save(default, 'Way_Of_Life_Helper.ini') sampAddChatMessage(teg ..'Настройки сохранены', - 1) end
            if imgui.MenuItem(u8'Сбросить настройки INI') then inicfg.save(restore, 'Way_Of_Life_Helper.ini') sampAddChatMessage(teg ..'Настройки сброшены', - 1) end
        end
        imgui.End()
    end
    if imguifaq.v then
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(400, 300), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'F.A.Q', imguifaq, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoSavedSettings)
        imgui.CenterTextColoredRGB(dhelp)
        if isKeyJustPressed(0x1B) or isKeyJustPressed(0x08) or isKeyJustPressed(0x0D) then imguifaq.v = false end
        imgui.End()
    end
    if tporg.v then
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        --imgui.SetNextWindowSize(imgui.ImVec2(400, 300), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'ТП меню', tporg, imgui.WindowFlags.AlwaysAutoResize)
        if isCharInAnyCar(PLAYER_PED) then
            if imgui.CollapsingHeader(u8'ТП (с авто)') then
                if imgui.MenuItem(u8'LS') then setCharCoordinates(PLAYER_PED, 1057, - 1403, 13) tporg.v = false end
                if imgui.MenuItem(u8'SF') then setCharCoordinates(PLAYER_PED, - 1818, - 579, 16) tporg.v = false end
                if imgui.MenuItem(u8'LV') then setCharCoordinates(PLAYER_PED, 1797, 842, 10) tporg.v = false end
                if imgui.MenuItem(u8'Мэрия LS') then setCharCoordinates(PLAYER_PED, 1476, - 1708, 14) tporg.v = false end
                if imgui.MenuItem(u8'VineVood') then setCharCoordinates(PLAYER_PED, 1373, - 927, 34) tporg.v = false end
                if imgui.MenuItem(u8'Мост ЛС - СФ') then setCharCoordinates(PLAYER_PED, 56, - 1531, 5) tporg.v = false end
                if imgui.MenuItem(u8'Мост ЛС - ЛВ') then setCharCoordinates(PLAYER_PED, 1698, - 736, 50) tporg.v = false end
                if imgui.MenuItem(u8'Мост СФ - ЛВ') then setCharCoordinates(PLAYER_PED, - 1411, 814, 47) tporg.v = false end
            end
        end
        if imgui.CollapsingHeader(u8'ТП в организации') then
            if imgui.MenuItem(u8'LSPD') then sampSendPickedUpPickup(103) tporg.v = false end
            if imgui.MenuItem(u8'Мэрия') then sampSendPickedUpPickup(198) tporg.v = false end
            if imgui.MenuItem(u8'Мэрия (сзади)') then sampSendPickedUpPickup(200) tporg.v = false end
            if imgui.MenuItem(u8'Правительство') then sampSendPickedUpPickup(212) tporg.v = false end
            if imgui.MenuItem(u8'S.W.A.T') then sampSendPickedUpPickup(24) tporg.v = false end
            if imgui.MenuItem(u8'FBI') then sampSendPickedUpPickup(181) tporg.v = false end
            if imgui.MenuItem(u8'SFPD') then sampSendPickedUpPickup(112) tporg.v = false end
            if imgui.MenuItem(u8'СВ (Склад)') then sampSendPickedUpPickup(223) tporg.v = false end
            if imgui.MenuItem(u8'ВВС (Склад)') then sampSendPickedUpPickup(35) tporg.v = false end
            if imgui.MenuItem(u8'ВВС (Штаб)') then sampSendPickedUpPickup(38) tporg.v = false end
            if imgui.MenuItem(u8'ВВС (Казарма)') then sampSendPickedUpPickup(32) tporg.v = false end
            if imgui.MenuItem(u8'LVPD') then sampSendPickedUpPickup(172) tporg.v = false end
            if imgui.MenuItem(u8'LCN') then sampSendPickedUpPickup(183) tporg.v = false end
            if imgui.MenuItem(u8'RM') then sampSendPickedUpPickup(184) tporg.v = false end
            if imgui.MenuItem(u8'Yakuza') then sampSendPickedUpPickup(179) tporg.v = false end
            if imgui.MenuItem(u8'Army SF (В инте нельзя)') then setCharCoordinates(PLAYER_PED, - 1336, 477, 9) tporg.v = false end
            if imgui.MenuItem(u8'Hitmans (В инте нельзя)') then setCharCoordinates(PLAYER_PED, - 2240, 2351, 5) tporg.v = false end
        end
        if imgui.CollapsingHeader(u8'ТП из организации') then
            if imgui.MenuItem(u8'LSPD') then sampSendPickedUpPickup(104) tporg.v = false end
            if imgui.MenuItem(u8'Мэрия') then sampSendPickedUpPickup(201) tporg.v = false end
            if imgui.MenuItem(u8'Мэрия (сзади)') then sampSendPickedUpPickup(199) tporg.v = false end
            if imgui.MenuItem(u8'Правительство') then sampSendPickedUpPickup(213) tporg.v = false end
            if imgui.MenuItem(u8'S.W.A.T') then sampSendPickedUpPickup(25) tporg.v = false end
            if imgui.MenuItem(u8'FBI') then sampSendPickedUpPickup(180) tporg.v = false end
            if imgui.MenuItem(u8'SFPD') then sampSendPickedUpPickup(111) tporg.v = false end
            if imgui.MenuItem(u8'СВ (Склад)') then sampSendPickedUpPickup(224) tporg.v = false end
            if imgui.MenuItem(u8'ВВС (Склад)') then sampSendPickedUpPickup(36) tporg.v = false end
            if imgui.MenuItem(u8'ВВС (Штаб)') then sampSendPickedUpPickup(39) tporg.v = false end
            if imgui.MenuItem(u8'ВВС (Казарма)') then sampSendPickedUpPickup(33) tporg.v = false end
            if imgui.MenuItem(u8'LVPD') then sampSendPickedUpPickup(173) tporg.v = false end
            if imgui.MenuItem(u8'LCN') then sampSendPickedUpPickup(182) tporg.v = false end
            if imgui.MenuItem(u8'RM') then sampSendPickedUpPickup(177) tporg.v = false end
            if imgui.MenuItem(u8'Yakuza') then sampSendPickedUpPickup(178) tporg.v = false end
        end
        if imgui.CollapsingHeader(u8'ТП в банды') then
            imgui.Text(u8'ТП в инту')
            imgui.Separator()
            imgui.Spacing()
            if imgui.MenuItem(u8'Ballas') then sampSendPickedUpPickup(207) tporg.v = false end
            if imgui.MenuItem(u8'Vagos') then sampSendPickedUpPickup(210) tporg.v = false end
            if imgui.MenuItem(u8'Groove') then sampSendPickedUpPickup(217) tporg.v = false end
            if imgui.MenuItem(u8'Aztecas') then sampSendPickedUpPickup(214) tporg.v = false end
            if imgui.MenuItem(u8'Rifa') then sampSendPickedUpPickup(209) tporg.v = false end
            imgui.Spacing()
            imgui.Separator()
            imgui.Text(u8'ТП из инты (на улицу)')
            imgui.Separator()
            imgui.Spacing()
            if imgui.MenuItem(u8'Ballas') then sampSendPickedUpPickup(206) tporg.v = false end
            if imgui.MenuItem(u8'Vagos') then sampSendPickedUpPickup(211) tporg.v = false end
            if imgui.MenuItem(u8'Groove') then sampSendPickedUpPickup(216) tporg.v = false end
            if imgui.MenuItem(u8'Aztecas') then sampSendPickedUpPickup(215) tporg.v = false end
            if imgui.MenuItem(u8'Rifa') then sampSendPickedUpPickup(208) tporg.v = false end
        end
        if imgui.CollapsingHeader(u8'ТП по метке') then
            local result, posX, posY, posZ = getTargetBlipCoordinates()
            local positionX, positionY, positionZ = getCharCoordinates(PLAYER_PED)
            if result then
                imgui.Text(u8(string.format('Координаты метки: %d, %d, %d', posX, posY, posZ)))
                imgui.Separator()
                if imgui.MenuItem(u8'Телепортироваться по метке') then
                    local result, posX, posY, posZ = getTargetBlipCoordinatesFixed()
                    setCharCoordinates(PLAYER_PED, posX, posY, posZ)
                end
            else
                imgui.Text(u8'Ошибка! Метка не стоит на карте') end
                imgui.Separator()
                imgui.Text(u8(string.format('Ваши координаты: %d, %d, %d', positionX, positionY, positionZ)))
            end
            imgui.End()
        end
        if picupsimgui.v then
            imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            --imgui.SetNextWindowSize(imgui.ImVec2(400, 300), imgui.Cond.FirstUseEver)
            imgui.Begin(u8'Меню пикапов', picupsimgui, imgui.WindowFlags.AlwaysAutoResize)
            if imgui.MenuItem(u8'Смена скина') then sampSendPickedUpPickup(picups['Clotch']) picupsimgui.v = false end
            if imgui.MenuItem(u8'Автоугонщик') then sampSendPickedUpPickup(95) picupsimgui.v = false end
            if imgui.CollapsingHeader(u8'Автосалоны') then
                if imgui.MenuItem(u8'Автосалон A класса (SF)') then sampSendPickedUpPickup(picups.avtosalon[1]) picupsimgui.v = false end
                if imgui.MenuItem(u8'Автосалон B класса (SF)') then sampSendPickedUpPickup(picups.avtosalon[2]) picupsimgui.v = false end
                if imgui.MenuItem(u8'Автосалон Nope класса (LS)') then sampSendPickedUpPickup(picups.avtosalon[3]) picupsimgui.v = false end
            end
            if imgui.CollapsingHeader(u8'Взять ган') then
                if imgui.MenuItem(u8'LSPD') then sampSendPickedUpPickup(getgunses[1]) picupsimgui.v = false end
                if imgui.MenuItem(u8'FBI') then sampSendPickedUpPickup(getgunses[2]) picupsimgui.v = false end
                if imgui.MenuItem(u8'SWAT') then sampSendPickedUpPickup(getgunses[3]) picupsimgui.v = false end
                if imgui.MenuItem(u8'ВВС') then sampSendPickedUpPickup(getgunses[4]) picupsimgui.v = false end
                if imgui.MenuItem(u8'Army LV') then sampSendPickedUpPickup(getgunses[5]) picupsimgui.v = false end
                if imgui.MenuItem(u8'Army SF') then sampSendPickedUpPickup(getgunses[6]) picupsimgui.v = false end
                if imgui.MenuItem(u8'Мэрия') then sampSendPickedUpPickup(getgunses[7]) picupsimgui.v = false end
                if imgui.MenuItem(u8'Правительство') then sampSendPickedUpPickup(getgunses[8]) picupsimgui.v = false end
            end
            if imgui.CollapsingHeader(u8'Взять пикап по ID') then
                imgui.InputInt(u8'Введите ID пикапа', picupid, 0, 9000)
                imgui.Separator()
                if imgui.MenuItem(u8'Взять пикап '..picupid.v) then sampSendPickedUpPickup(picupid.v) else end
            end
            imgui.End()
        end
        if superkillerubiza.v then
            imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.Begin(u8'Убиватор', superkillerubiza, imgui.WindowFlags.AlwaysAutoResize)
            imgui.Combo(u8'##ska', superkillerubizarezhim, killerrezhim)
            imgui.Separator()
            imgui.InputInt(u8'Введите ID жертвы', superkillerubizaid, 0, 1000)
            imgui.Text(u8'Вы ввели: ' ..superkillerubizaid.v)
            imgui.Separator()
            if imgui.MenuItem(u8'Атаковать') then
                if superkillerubizarezhim.v == 0 then
                    lua_thread.create(function() for i = 0, wol.damag do sampSendGiveDamage(superkillerubizaid.v, 49, 24, 9) wait(90) end end)
                end
                if superkillerubizarezhim.v == 1 then pomehaska(tostring(superkillerubizaid.v)) end
                if superkillerubizarezhim.v == 2 then sampSendGiveDamage(superkillerubizaid.v, 49, 24, 9) end
            end
            if imgui.MenuItem(u8'Отмена') then superkillerubiza.v = false end
            imgui.End()
        end
        if findimgui.v then
            imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(400, 250), imgui.Cond.FirstUseEver)
            --imgui.Begin('Members', findimgui, imgui.WindowFlags.NoSavedSettings)
            imgui.Begin('Members', findimgui, imgui.WindowFlags.AlwaysAutoResize)
            imgui.Columns(2, _, false)
            imgui.Text(u8'Ник')
            imgui.SetColumnWidth(-1, 200)
            imgui.NextColumn()
            imgui.Text(u8'Ранг')
            imgui.Separator()
            imgui.NewLine()
            imgui.NextColumn()
            for k, v in pairs(findshowtable) do
                --imgui.Text(u8('Ник: '..k)) imgui.NextColumn() imgui.Text(u8(' Ранг: ' ..v)) imgui.NextColumn() --imgui.Spacing() --imgui.Separator()
                if imgui.MenuItem(u8(k)) then
                    nick = k
                    rang = v
                    imgui.OpenPopup('membersfunc')
                end
                imgui.NextColumn() imgui.Text(u8(v)) imgui.NextColumn()
            end
            imgui.Columns(1)
            if imgui.BeginPopup('membersfunc') then
                imgui.Text(nick..' ('..u8(rang)..')')
                membersid = nick:match('.+%[(%d+)%]')
                imgui.Separator()
                imgui.Spacing()
                if imgui.MenuItem(u8'Повысить') then sampSendChat('/giverank '..membersid..' '..rang + 1) end
                if imgui.MenuItem(u8'Понизить') then sampSendChat('/giverank '..membersid..' '..rang - 1) end
                if imgui.MenuItem(u8'Выдать выговор') then sampSetChatInputText('/vig ' ..membersid ..' ') sampSetChatInputEnabled(true) findimgui.v = false end
                if imgui.MenuItem(u8'Уволить') then sampSetChatInputText('/uninvite ' ..membersid ..' ') sampSetChatInputEnabled(true) findimgui.v = false end
                imgui.EndPopup()
            end
            imgui.NewLine()
            imgui.Separator()
            imgui.Text(u8'Всего игроков: '..findkolvo..'													')
            imgui.End()
        end
        if trenirovkaimgui.v then
            imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(500, 300), imgui.Cond.FirstUseEver)
            imgui.Begin(u8'Автострой', trenirovkaimgui, imgui.WindowFlags.NoSavedSettings)
            imgui.Columns(3, _, false)
            imgui.Text(u8'В строю: ')
			imgui.Spacing()
            for k, v in pairs(vstroy) do
				if imgui.MenuItem(k) then imgui.OpenPopup('trenirovkapopup') nick, rang = k, v end
            end
            imgui.NextColumn()
            imgui.Text(u8'Не в строю:')
			imgui.Spacing()
            for k, v in pairs(nevstroy) do
				if imgui.MenuItem(k) then imgui.OpenPopup('trenirovkapopup') nick, rang = k, v end
            end
            imgui.NextColumn()
            imgui.Text(u8'Рядом:')
			imgui.Separator()
			imgui.Spacing()
            for k, v in pairs(ryadom) do
                if imgui.MenuItem(k) then imgui.OpenPopup('trenirovkapopup') nick, rang = k, v end
            end
			if imgui.BeginPopup('trenirovkapopup') then
                imgui.Text(nick..' ('..u8(rang)..')')
                membersid = nick:match('.+%[(%d+)%]')
                imgui.Separator()
                imgui.Spacing()
                if imgui.MenuItem(u8'Повысить') then sampSendChat('/giverank '..membersid..' '..rang + 1) end
                if imgui.MenuItem(u8'Понизить') then sampSendChat('/giverank '..membersid..' '..rang - 1) end
                if imgui.MenuItem(u8'Выдать выговор') then sampSetChatInputText('/vig ' ..membersid ..' ') sampSetChatInputEnabled(true) findimgui.v = false end
                if imgui.MenuItem(u8'Уволить') then sampSetChatInputText('/uninvite ' ..membersid ..' ') sampSetChatInputEnabled(true) findimgui.v = false end
                imgui.EndPopup()
            end
            imgui.End()
        end
        if wolleader.v then
            imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.Begin(u8'Панель лидера', wolleader, imgui.WindowFlags.AlwaysAutoResize)
            imgui.PushItemWidth(250)
            imgui.Combo('##leader', wolleadermenu, govmenu)
            imgui.PushItemWidth()
            imgui.Spacing()
            imgui.Separator()
            imgui.Spacing()
            if imgui.MenuItem(u8'Активировать') then
                if wolleadermenu.v == 0 then lua_thread.create(function() inFileRead('начало_собеса.txt') end) end --Начало
                if wolleadermenu.v == 1 then lua_thread.create(function() inFileRead('первая_напоминалка_собеса.txt') end) end --Напоминалка 1
                if wolleadermenu.v == 2 then lua_thread.create(function() inFileRead('вторая_напоминалка_собеса.txt') end) end --Напоминалка 2
                if wolleadermenu.v == 3 then lua_thread.create(function() inFileRead('конец_собеса.txt') end) end --Конец
            end
            imgui.Spacing()
            imgui.Separator()
            imgui.Spacing()
            if imgui.CollapsingHeader(u8'Просмотр отыгровки') then
                if wolleadermenu.v == 0 then inFileReadProsmotr('начало_собеса.txt') end --Начало
                if wolleadermenu.v == 1 then inFileReadProsmotr('первая_напоминалка_собеса.txt') end --Напоминалка 1
                if wolleadermenu.v == 2 then inFileReadProsmotr('вторая_напоминалка_собеса.txt') end --Напоминалка 2
                if wolleadermenu.v == 3 then inFileReadProsmotr('конец_собеса.txt') end --Конец
            end
            if imgui.CollapsingHeader(u8'Одноразовые отыгровки') then
                imgui.PushItemWidth(500)
                imgui.InputTextMultiline('##svoihui', customsendchat)
                imgui.PushItemWidth()
                if imgui.Button(u8'Активировать', btn_size) then
                    lua_thread.create(
                        function()
                            for line in u8:decode(customsendchat.v):gmatch("[^\r\n]+") do
                                if line:find('wait%(%d+%)') then local waittime = line:match('wait%((%d+)%)') wait(waittime)
                                else
                                    sampSendChat(line)
                                end
                            end
                    end)
                end
            end
            if imgui.CollapsingHeader(u8'Постоянные отыгровки') then
                imgui.Text(u8'Введите название файла.')
                imgui.InputText(u8'.txt', imguifile)

                if doesFileExist('moonloader/WolHelper/Binder/'..imguifile.v..'.txt') then
                    if imgui.MenuItem(u8'Обновить информацию') then
                        local filesource = io.open('moonloader/WolHelper/Binder/'..imguifile.v..'.txt', 'a+')
                        customsendchat.v = filesource:read('*a')
                        filesource:close()
                    end
                    imgui.PushItemWidth(500)
                    imgui.InputTextMultiline('##svoihui', customsendchat)
                    imgui.PushItemWidth()

                    if imgui.Button(u8'Активировать', imgui.ImVec2(245, 0)) then
                        lua_thread.create(
                            function()
                                for line in u8:decode(customsendchat.v):gmatch("[^\r\n]+") do
                                    if line:find('wait%(%d+%)') then local waittime = line:match('wait%((%d+)%)') wait(waittime)
                                    else
                                        sampSendChat(line)
                                    end
                                end
                        end)
                    end
                    imgui.SameLine()
                    if imgui.Button(u8'Взаимодействие', imgui.ImVec2(250, 0)) then
                        imgui.OpenPopup('VzaimFile')
                    end

                    if imgui.BeginPopup('VzaimFile') then
                        if imgui.MenuItem(u8'Сохранить файл') then
                            local filesource = io.open('moonloader/WolHelper/Binder/'..imguifile.v..'.txt', 'w+')
                            filesource:write(customsendchat.v)
                            filesource:close()
                            imgui.CloseCurrentPopup()
                        end
                        if imgui.MenuItem(u8'Удалить файл') then
                            os.remove('moonloader/WolHelper/Binder/'..imguifile.v..'.txt')
                            imgui.CloseCurrentPopup()
                        end
                        imgui.EndPopup()
                    end

                elseif not doesFileExist('moonloader/WolHelper/Binder/'..imguifile.v..'.txt') then
                    if imgui.Button(u8'Создать файл') then
                        local filesska = io.open('moonloader/WolHelper/Binder/'..imguifile.v..'.txt', 'w+')
                        filesska:write(u8'Введите текст\nДля установки задержки используйте wait(время в мс) в новой строчке\nПример:\n/me достал Desert Eagle\nwait(1000)\n/me снял предохранитель')
                        filesska:close()
                    end
                end
            end
            imgui.End()
        end
    end


    function SE.onSetCheckpoint(position, radius)
        if tpfindresult and position.z < 500 then
            setCharCoordinates(PLAYER_PED, position.x, position.y, position.z)
            print(string.format('X: %d, Y: %d, Z: %d', position.x, position.y, position.z))
            tpfindresult = false
        elseif tpfindresult and position.z > 500 then
            sampAddChatMessage(teg ..'Возможно игрок находится в инте. Нажмите {FF7000}Y{FFFFFF} для продолжения или {FF7000}N{FFFFFF} для отклонения', - 1)
            rkeys.registerHotKey({vkeys.VK_Y}, true, function() setCharCoordinates(PLAYER_PED, position.x, position.y, position.z)
                print(string.format('X: %d, Y: %d, Z: %d', position.x, position.y, position.z))
                rkeys.unRegisterHotKey({vkeys.VK_Y})
            rkeys.unRegisterHotKey({vkeys.VK_N}) end)
            rkeys.registerHotKey({vkeys.VK_N}, true, function()
                sampAddChatMessage(teg ..'Отклонено', - 1)
                rkeys.unRegisterHotKey({vkeys.VK_Y})
            rkeys.unRegisterHotKey({vkeys.VK_N}) end)
            tpfindresult = false
        end
    end

    function wolarmor(arm)
        if arm:find('%d+') then
            if arm == '0' then arm = getCharArmour(PLAYER_PED) * - 1 end
            addArmourToChar(PLAYER_PED, arm)
        else
            addArmourToChar(PLAYER_PED, 100)
        end
    end


    function ganggun(gang)
        lua_thread.create(function()
            if gang == nil then getstat = true sampSendChat('/mm') end
            while gang == nil do wait(0) end
            local positionX, positionY, positionZ = getCharCoordinates(PLAYER_PED)
            setCharCoordinates(PLAYER_PED, bandgun[gang][1], bandgun[gang][2], bandgun[gang][3])
            wait(50)
            sampSendChat('/gmenu')
            sampSendDialogResponse(5051, 1, 0, 7)
            setCharCoordinates(PLAYER_PED, positionX, positionY, positionZ)
            for i = 0, 20 do
                sampSendDialogResponse(5051, 1, 4, 7)
            end
            for i = 0, 20 do
                sampSendDialogResponse(5051, 1, 8, 7)
            end
            for i = 0, 20 do
                sampSendDialogResponse(5051, 1, 9, 7)
            end
        end)
    end

    function wolcarhp(args)
        if carhpthread ~= nil then notf.addNotification('Ошибка!\n\nНе прошло 2 секунды до предыдущей смены!', 5, 1) return end
        carhpthread = lua_thread.create(function()
            if args:find('^%d+') then
            blockcarhp = true
            setCarHealth(storeCarCharIsInNoSave(PLAYER_PED), args)
            wait(1000)
            blockcarhp = false
            carhpthread = nil
        else
            blockcarhp = true
            setCarHealth(storeCarCharIsInNoSave(PLAYER_PED), 1000)
            wait(1000)
            blockcarhp = false
            carhpthread = nil
        end
    end)
end

function hitmangun()
    lua_thread.create(function()
        local positionX, positionY, positionZ = getCharCoordinates(PLAYER_PED)
        setCharCoordinates(PLAYER_PED, - 2240, 2351, 5)
        sampSendChat('/menu')
        wait(25)
        sampSendDialogResponse(5051, 1, 3, 7)
        setCharCoordinates(PLAYER_PED, positionX, positionY, positionZ)
    end)
end

function SE.onSetVehicleHealth(vehicleId, health)
    if blockcarhp then return false end
end

function vigovor(arg)
    lua_thread.create(function()
        local id, prichinaviga = arg:match('(%d+) (.+)')
        if id == nil and prichinaviga == nil then sampAddChatMessage(teg ..'Ошибка! Введите {FF7000}/vig + ID + Причина', - 1) return end
        sampSendChat('/vig '..arg)
        wait(1000)
        sampSendChat('/r Сотрудник '..sampGetPlayerNickname(id):gsub('_', ' ')..' получает выговор')
        wait(1000)
        sampSendChat('/r Причина: '..prichinaviga)
    end)
end

function uninviteska(arg)
    lua_thread.create(function()
        local id, prichinaviga = arg:match('(%d+) (.+)')
        if id == nil and prichinaviga == nil then sampAddChatMessage(teg ..'Ошибка! Введите {FF7000}/vig + ID + Причина', - 1) return end
        sampSendChat('/uninvite '..arg)
        wait(1000)
        sampSendChat('/r Сотрудник '..sampGetPlayerNickname(id):gsub('_', ' ')..' уволен')
        wait(1000)
        sampSendChat('/r Причина: '..prichinaviga)
    end)
end




































































































































local russian_characters = {
    [168] = 'Ё', [184] = 'ё', [192] = 'А', [193] = 'Б', [194] = 'В', [195] = 'Г', [196] = 'Д', [197] = 'Е', [198] = 'Ж', [199] = 'З', [200] = 'И', [201] = 'Й', [202] = 'К', [203] = 'Л', [204] = 'М', [205] = 'Н', [206] = 'О', [207] = 'П', [208] = 'Р', [209] = 'С', [210] = 'Т', [211] = 'У', [212] = 'Ф', [213] = 'Х', [214] = 'Ц', [215] = 'Ч', [216] = 'Ш', [217] = 'Щ', [218] = 'Ъ', [219] = 'Ы', [220] = 'Ь', [221] = 'Э', [222] = 'Ю', [223] = 'Я', [224] = 'а', [225] = 'б', [226] = 'в', [227] = 'г', [228] = 'д', [229] = 'е', [230] = 'ж', [231] = 'з', [232] = 'и', [233] = 'й', [234] = 'к', [235] = 'л', [236] = 'м', [237] = 'н', [238] = 'о', [239] = 'п', [240] = 'р', [241] = 'с', [242] = 'т', [243] = 'у', [244] = 'ф', [245] = 'х', [246] = 'ц', [247] = 'ч', [248] = 'ш', [249] = 'щ', [250] = 'ъ', [251] = 'ы', [252] = 'ь', [253] = 'э', [254] = 'ю', [255] = 'я',
}
function string.rlower(s)
    s = s:lower()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:lower()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 192 and ch <= 223 then -- upper russian characters
            output = output .. russian_characters[ch + 32]
        elseif ch == 168 then -- Ё
            output = output .. russian_characters[184]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end
function string.rupper(s)
    s = s:upper()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:upper()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 224 and ch <= 255 then -- lower russian characters
            output = output .. russian_characters[ch - 32]
        elseif ch == 184 then -- ё
            output = output .. russian_characters[168]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end



function onScriptTerminate(script, quitGame)
    if script == idnotf then
        lua_thread.create(function() wait(10) notf = import 'imgui_notf.lua' notf.addNotification('WolHelper успешно загружен\n\nВерсия скрипта: '..thisScript().version, 5, 1) end)
    end
end

function inFileRead(read_patch)
    for line in io.lines(getWorkingDirectory()..'/WolHelper/'..read_patch) do
        sampSendChat(line)
        wait(1000)
    end
end

function inFileReadProsmotr(read_patch)
    for line in io.lines(getWorkingDirectory()..'/WolHelper/'..read_patch) do
        imgui.Text(u8(line))
    end
end

function ShowHelpMarker(text)
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if (imgui.IsItemHovered()) then
        imgui.SetTooltip(u8(text))
    end
end



local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8

function imgui.CenterTextColoredRGB(text)
    local width = imgui.GetWindowWidth()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local textsize = w:gsub('{.-}', '')
            local text_width = imgui.CalcTextSize(u8(textsize))
            imgui.SetCursorPosX( width / 2 - text_width .x / 2 )
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else
                imgui.Text(u8(w))
            end
        end
    end
    render_text(text)
end



function async_http_request(method, url, args, resolve, reject)
    local request_lane = lanes.gen('*', {package = {path = package.path, cpath = package.cpath}}, function()
        local requests = require 'requests'
        local ok, result = pcall(requests.request, method, url, args)
        if ok then
            result.json, result.xml = nil, nil -- cannot be passed through a lane
            return true, result
        else
            return false, result -- return error
        end
    end)
    if not reject then reject = function() end end
    lua_thread.create(function()
        local lh = request_lane()
        while true do
            local status = lh.status
            if status == 'done' then
                local ok, result = lh[1], lh[2]
                if ok then resolve(result) else reject(result) end
                return
            elseif status == 'error' then
                return reject(lh[1])
            elseif status == 'killed' or status == 'cancelled' then
                return reject(status)
            end
            wait(0)
        end
    end)
end



function getTargetBlipCoordinatesFixed()
    local bool, x, y, z = getTargetBlipCoordinates(); if not bool then return false end
    requestCollision(x, y); loadScene(x, y, z)
    local bool, x, y, z = getTargetBlipCoordinates()
    return bool, x, y, z
end


function apply_custom_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4

    style.WindowRounding = 2.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
    style.ChildWindowRounding = 2.0
    style.FrameRounding = 2.0
    style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
    style.ScrollbarSize = 13.0
    style.ScrollbarRounding = 0
    style.GrabMinSize = 8.0
    style.GrabRounding = 1.0

    colors[clr.FrameBg] = ImVec4(0.16, 0.29, 0.48, 0.54)
    colors[clr.FrameBgHovered] = ImVec4(0.26, 0.59, 0.98, 0.40)
    colors[clr.FrameBgActive] = ImVec4(0.26, 0.59, 0.98, 0.67)
    colors[clr.TitleBg] = ImVec4(0.04, 0.04, 0.04, 1.00)
    colors[clr.TitleBgActive] = ImVec4(0.16, 0.29, 0.48, 1.00)
    colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.CheckMark] = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.SliderGrab] = ImVec4(0.24, 0.52, 0.88, 1.00)
    colors[clr.SliderGrabActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.Button] = ImVec4(0.26, 0.59, 0.98, 0.40)
    colors[clr.ButtonHovered] = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.ButtonActive] = ImVec4(0.06, 0.53, 0.98, 1.00)
    colors[clr.Header] = ImVec4(0.26, 0.59, 0.98, 0.31)
    colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
    colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.Separator] = colors[clr.Border]
    colors[clr.SeparatorHovered] = ImVec4(0.26, 0.59, 0.98, 0.78)
    colors[clr.SeparatorActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.ResizeGrip] = ImVec4(0.26, 0.59, 0.98, 0.25)
    colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
    colors[clr.ResizeGripActive] = ImVec4(0.26, 0.59, 0.98, 0.95)
    colors[clr.TextSelectedBg] = ImVec4(0.26, 0.59, 0.98, 0.35)
    colors[clr.Text] = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled] = ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[clr.WindowBg] = ImVec4(0.06, 0.06, 0.06, 0.94)
    colors[clr.ChildWindowBg] = ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.ComboBg] = colors[clr.PopupBg]
    colors[clr.Border] = ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.MenuBarBg] = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab] = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered] = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive] = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CloseButton] = ImVec4(0.41, 0.41, 0.41, 0.50)
    colors[clr.CloseButtonHovered] = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive] = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
    colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.ModalWindowDarkening] = ImVec4(0.80, 0.80, 0.80, 0.35)
end

apply_custom_style()
