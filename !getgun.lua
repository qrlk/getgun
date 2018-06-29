--Больше скриптов от автора можно найти на сайте: http://www.rubbishman.ru/samp
--------------------------------------------------------------------------------
-------------------------------------META---------------------------------------
--------------------------------------------------------------------------------
script_name("GETGUN")
script_description("/gg")
script_author("rubbishman")
script_version("1.85")
--------------------------------------VAR---------------------------------------
color = 0x348cb2
local prefix = '['..string.upper(thisScript().name)..']: '
local inicfg = require 'inicfg'
local data = inicfg.load({
  options =
  {
    startmessage = 1,
    hotkey = 'N',
    mode = 0,
    autoupdate = 1,
    doklad = 1,
  },
}, 'getgun.ini')
local dlstatus = require('moonloader').download_status
local mod_submenus_sa = {
  {
    title = 'Информация о скрипте',
    onclick = function()
      wait(100)
      cmdInfo()
    end
  },
  {
    title = 'Связаться с автором (все баги сюда)',
    onclick = function()
      local ffi = require 'ffi'
      ffi.cdef [[
								void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);
								uint32_t __stdcall CoInitializeEx(void*, uint32_t);
							]]
      local shell32 = ffi.load 'Shell32'
      local ole32 = ffi.load 'Ole32'
      ole32.CoInitializeEx(nil, 2 + 4)
      print(shell32.ShellExecuteA(nil, 'open', 'http://rubbishman.ru/sampcontact', nil, nil, 1))
    end
  },
  {
    title = ' ',
    onclick = function()
      sampAddChatMessage('плиттовская братва на месте. обернись.', - 1)
    end
  },
  {
    title = '{AAAAAA}Настройки'
  },
  {
    title = 'Вкл/выкл режим складосохранения',
    onclick = function()
      cmdChangeMode()
    end
  },
  {
    title = 'Настройки скрипта',
    submenu = {
      {
        title = 'Изменить клавишу активации',
        onclick = function()
          cmdHotKey()
        end
      },
      {
        title = 'Включить/выключить уведомление при запуске',
        onclick = function()
          cmdInform()
        end
      },
      {
        title = 'Включить/выключить отчёт в /f',
        onclick = function()
          cmdChangeStorojMode()
        end
      },
      {
        title = 'Вкл/выкл автообновление',
        onclick = function()
          if data.options.autoupdate == 1 then
            data.options.autoupdate = 0 sampAddChatMessage(('[GETGUN]: Автообновление выключено'), color)
          else
            data.options.autoupdate = 1 sampAddChatMessage(('[GETGUN]: Автообновление включено'), color)
          end
          inicfg.save(data, "getgun")
        end
      },
    }
  },
  {
    title = 'Открыть страницу скрипта',
    onclick = function()
      local ffi = require 'ffi'
      ffi.cdef [[
							void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);
							uint32_t __stdcall CoInitializeEx(void*, uint32_t);
						]]
      local shell32 = ffi.load 'Shell32'
      local ole32 = ffi.load 'Ole32'
      ole32.CoInitializeEx(nil, 2 + 4)
      print(shell32.ShellExecuteA(nil, 'open', 'http://rubbishman.ru/samp/getgun', nil, nil, 1))
    end
  },
  {
    title = ' '
  },
  {
    title = '{AAAAAA}Обновления'
  },
  {
    title = 'История обновлений',
    onclick = function()
      changelog()
    end
  },
  {
    title = 'Принудительно обновить',
    onclick = function()
      lua_thread.create(goupdate)
    end
  },
}
function main()
  while not isSampAvailable() do wait(100) end
  if data.options.autoupdate == 1 then
    update()
    while update ~= false do wait(100) end
  end

  firstload()
  onload()
  if data.options.startmessage == 1 then
    sampAddChatMessage(('GETGUN v'..thisScript().version..' запущен. Автор: rubbishman.ru'),
    0x348cb2)
    sampAddChatMessage(('Подробнее - /gg. Отключить это сообщение - /ggnot'), 0x348cb2)
  end
  while true do
    if menutrigger ~= nil then menu() menutrigger = nil end
    wait(0)
    while getActiveInterior() == 11 do
      if menutrigger ~= nil then menu() menutrigger = nil end
      wait(0)
      res, handle = getCharPlayerIsTargeting(playerHandle)
      if res then
        resid, getgunid = sampGetPlayerIdByCharHandle(handle)
        ggidnick = sampGetPlayerNickname(getgunid)
        if string.find(ggidnick, "_") then
          ggidname, ggidsurname = string.match(ggidnick, "(%g+)_(%g+)")
        end
      end
      while res and isKeyDown(whatkeyid(data.options.hotkey)) and sampIsChatInputActive() == false do
        if sampIsDialogActive() then sampCloseCurrentDialogWithButton(0) end
        sampSendChat('/getgun '..getgunid)
        local stopthis2 = 0
        while sampIsDialogActive() == false and stopthis2 < 30 do wait(40)
          stopthis2 = stopthis2 + 1
        end
        if sampIsDialogActive(123) and sampGetCurrentDialogId() == 123 then
          wait(200)
          sampSendDialogResponse(123, 1, 0, - 1)
          wait(100)
          capture = 99
          checkwarehouse, prefix, color1, pcolor = sampGetChatString(99)
          local stopthis2 = 0
          while string.find(checkwarehouse, 'На складе осталось', 1, true) == nil and stopthis2 < 5 do
            wait(0)
            checkwarehouse, prefix, color1, pcolor = sampGetChatString(capture)
            capture = capture - 1
            if capture < 90 then capture = 99 stopthis2 = stopthis2 + 1 end
          end
          if checkwarehouse ~= nil and string.find(checkwarehouse, 'На складе осталось', 1, true) and color1 == -10185235 then
            warehouse = tonumber(string.match(checkwarehouse, "(%d+)"))
            if data.options.mode == 0 then
              if warehouse < 100001 and warehouse > 79999 then ggid(getgunid, 3, 4, 0, 0, 2, 2) end
              if warehouse < 80001 and warehouse > 49999 then ggid(getgunid, 3, 3, 0, 0, 1, 2) end
              if warehouse < 50001 and warehouse > 29999 then ggid(getgunid, 3, 3, 0, 0, 0, 2) end
              if warehouse < 30001 and warehouse > 19999 then ggid(getgunid, 2, 3, 0, 0, 0, 1) end
              if warehouse < 20001 and warehouse > 9999 then ggid(getgunid, 1, 3, 0, 0, 0, 0) end
              if warehouse < 10001 and warehouse > 0 then ggid(getgunid, 1, 2, 0, 0, 0, 0) end
            else
              ggid(getgunid, 3, 3, 0, 0, 0, 2)
            end
          end
        end
      end
      if res == false and sampIsChatInputActive() == false and isKeyDown(whatkeyid(data.options.hotkey)) then
        if sampIsDialogActive() then sampCloseCurrentDialogWithButton(0) end
        sampSendChat('/getgun')

        capture = 99
        local stopthis = 0
        while sampIsDialogActive() == false and stopthis < 30 do wait(40)
          stopthis = stopthis + 1
        end
        if sampIsDialogActive(123) and sampGetCurrentDialogId() == 123 then
          wait(200)
          sampSendDialogResponse(123, 1, 0, - 1)
          wait(100)
          capture = 99
          checkwarehouse, prefix, color1, pcolor = sampGetChatString(99)
          local stopthis1 = 0
          while string.find(checkwarehouse, 'На складе осталось', 1, true) == nil and stopthis1 < 5 do
            wait(0)
            checkwarehouse, prefix, color1, pcolor = sampGetChatString(capture)
            capture = capture - 1
            if capture < 90 then capture = 99 stopthis1 = stopthis1 + 1 end
          end
          if checkwarehouse ~= nil and string.find(checkwarehouse, 'На складе осталось', 1, true) and color1 == -10185235 then
            warehouse = tonumber(string.match(checkwarehouse, "(%d+)"))
            if data.options.mode == 0 then
              if warehouse < 100001 and warehouse > 79999 then gg(4, 4, 0, 0, 2, 2) end
              if warehouse < 80001 and warehouse > 49999 then gg(4, 3, 0, 0, 1, 2) end
              if warehouse < 50001 and warehouse > 29999 then gg(4, 3, 0, 0, 0, 2) end
              if warehouse < 30001 and warehouse > 19999 then gg(3, 3, 0, 0, 0, 1) end
              if warehouse < 20001 and warehouse > 9999 then gg(2, 3, 0, 0, 0, 0) end
              if warehouse < 10001 and warehouse > 0 then gg(2, 2, 0, 0, 0, 0) end
            else
              gg(3, 3, 0, 0, 0, 2)
            end
          end
        end
      end
    end
  end
end

function cmdChangeMode()
  if data.options.mode == 1 then data.options.mode = 0 sampAddChatMessage('Режим складосохранения деактивирован.', color) else data.options.mode = 1 sampAddChatMessage('Режим складосохранения активирован.', color)
  end
  inicfg.save(data, "getgun")
end

function cmdChangeStorojMode()
  if data.options.doklad == 1 then data.options.doklad = 0 sampAddChatMessage('Отчёт сторожа выключен.', color) else data.options.doklad = 1 sampAddChatMessage('Отчёт сторожа включен.', color)
  end
  inicfg.save(data, "getgun")
end

function gg(gtgdeagle, gtgshotgun, gtgsmg, gtgak47, gtgm4a1, gtgrifle)
  if gtgdeagle ~= 0 then
    intweapon, ammodeagle, ModelModel = getCharWeaponInSlot(PLAYER_PED, 3)
    if intweapon == 24 then
      gtgdeagle = math.ceil((gtgdeagle * 14 - ammodeagle) / 14)
      if gtgdeagle < 0 then gtgdeagle = 0 end
    end
  end
  if gtgshotgun ~= 0 then
    intweapon, ammoshotgun, ModelModel = getCharWeaponInSlot(PLAYER_PED, 4)
    gtgshotgun = math.ceil((gtgshotgun * 10 - ammoshotgun) / 10)
    if gtgshotgun < 0 then gtgshotgun = 0 end
  end
  if gtgsmg ~= 0 then
    intweapon, ammosmg, ModelModel = getCharWeaponInSlot(PLAYER_PED, 5)
    gtgsmg = math.ceil((gtgsmg * 60 - ammosmg) / 120)
    if gtgsmg < 0 then gtgsmg = 0 end
  end
  if gtgak47 ~= 0 then
    intweapon, ammoak47, ModelModel = getCharWeaponInSlot(PLAYER_PED, 6)
    if intweapon == 30 then
      gtgak47 = math.ceil((gtgak47 * 60 - ammoak47) / 120)
      if gtgak47 < 0 then gtgak47 = 0 end
    end
  end
  if gtgm4a1 ~= 0 then
    intweapon, ammom4a1, ModelModel = getCharWeaponInSlot(PLAYER_PED, 6)
    if intweapon == 31 then
      gtgm4a1 = math.ceil((gtgm4a1 * 100 - ammom4a1) / 100)
      if gtgm4a1 < 0 then gtgm4a1 = 0 end
    end
  end
  if gtgrifle ~= 0 then
    intweapon, ammorifle, ModelModel = getCharWeaponInSlot(PLAYER_PED, 7)
    gtgrifle = math.ceil((gtgrifle * 10 - ammorifle) / 10)
    if gtgrifle < 0 then gtgrifle = 0 end
  end
  countgg = 42 + gtgdeagle * 42 + gtgshotgun * 30 + gtgsmg * 120 + gtgak47 * 180 + gtgm4a1 * 300 + gtgrifle * 50
  getgun(0, gtgdeagle)
  if gtgdeagle ~= 0 then wait(400) end
  getgun(1, gtgshotgun)
  if gtgshotgun ~= 0 then wait(400) end
  getgun(2, gtgsmg)
  if gtgsmg ~= 0 then wait(400) end
  getgun(3, gtgak47)
  if gtgak47 ~= 0 then wait(400) end
  getgun(4, gtgm4a1)
  if gtgm4a1 ~= 0 then wait(400) end
  getgun(5, gtgrifle)
  wait(500)
  while sampIsDialogActive() == true do
    wait(30)
    sampCloseCurrentDialogWithButton(0)
  end
  wait(500)
  sampCloseCurrentDialogWithButton(0)
  wait(200)
  if countgg > 0 then
    countgg = countgg
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    local bikernick = sampGetPlayerNickname(myid)
    if string.find(bikernick, "_") then
      local bikername, bikersurname = string.match(bikernick, "(%g+)_(%g+)")
      if data.options.doklad == 1 then sampSendChat("/f [Сторож]: "..bikername.." "..bikersurname.." взял со склада оружия на "..countgg.." материалов!") end
    else
      if data.options.doklad == 1 then sampSendChat("/f [Сторож]: "..bikernick.." взял со склада оружия на "..countgg.." материалов!") end
    end
  end
  countgg = 0
end

function ggid(getgunider, gtgdeagle, gtgshotgun, gtgsmg, gtgak47, gtgm4a1, gtgrifle)
  wait(0)
  countgg = gtgdeagle * 42 + gtgshotgun * 30 + gtgsmg * 120 + gtgak47 * 180 + gtgm4a1 * 300 + gtgrifle * 50
  getgun(0, gtgdeagle)
  if gtgdeagle ~= 0 then wait(400) end
  getgun(1, gtgshotgun)
  if gtgshotgun ~= 0 then wait(400) end
  getgun(2, gtgsmg)
  if gtgsmg ~= 0 then wait(400) end
  getgun(3, gtgak47)
  if gtgak47 ~= 0 then wait(400) end
  getgun(4, gtgm4a1)
  if gtgm4a1 ~= 0 then wait(400) end
  getgun(5, gtgrifle)
  wait(500)
  while sampIsDialogActive() == true do
    wait(30)
    sampCloseCurrentDialogWithButton(0)
  end
  wait(500)
  sampCloseCurrentDialogWithButton(0)
  wait(200)
  if countgg > 0 then
    countgg = countgg
    if string.find(ggidnick, "_") then
      if data.options.doklad == 1 then sampSendChat("/f [Сторож]: "..ggidname.."'у "..ggidsurname.."'у было выдано "..countgg.." материалов со склада!") end
    else
      if data.options.doklad == 1 then sampAddChatMessage("/f [Сторож]: "..ggidnick.."'у было выдано "..countgg.." материалов со склада!") end
    end
  end
  countgg = 0
end

function getgun(gtgtype, gtgkolvo)
  if gtgkolvo > 0 then
    --sampAddChatMessage(string.format("Скрипт выдает оружие: "..gtgtype..". Осталось наборов: "..gtgkolvo.."."), 0xFA73D3)
    gtgkolvo = gtgkolvo - 1
    wait(50)
    sampSendDialogResponse(123, 1, gtgtype, - 1)
    return getgun(gtgtype, gtgkolvo)
  end
end

function firstload()

  if data.options.mode == nil then data.options.mode = 0 end
  inicfg.save(data, "getgun");
end
function ggmenu()
  menutrigger = 1
end
function menu()
  submenus_show(mod_submenus_sa, '{348cb2}GETGUN v'..thisScript().version..'', 'Выбрать', 'Закрыть', 'Назад')
end

function cmdInfo()
  sampShowDialog(2342, "{ffbf00}GETGUN. Автор: rubbishman.ru", "{ffcc00}Для чего этот скрипт?\n{ffffff}Цель скрипта: автоматизировать набор и выдачу оружия со склада байкеров на Samp-Rp.\n{ffcc00}Как он работает?\n{ffffff}Есть два режима работы GETGUN{ffffff}: {348cb2}выдача себе{ffffff} и {348cb2}выдача товарищу{ffffff}.\n{348cb2}  Выдача себе:{ffffff}\nНажмите горячую клавишу {00ccff}"..data.options.hotkey.."{ffffff} в баре у стойки. \nКоличество оружия зависит от текущего состояния склада и кол-ва патрон у вас на руках.\nНапример, если склад позволяет взять 4 пачки дигла, но у вас уже есть 3, то будет взята только 1.\n{348cb2}  Выдача товарищу:\n{ffffff}Нацельтесь на товарища и нажмите горячую клавишу {00ccff}"..data.options.hotkey.."{ffffff} в баре у стойки.\nКоличество выдаваемого товарищу оружия зависит только от текущего состояния склада.\nТочно определить количество патронов на руках других игроков не получается, может я рукожоп.\n{ffcc00}Сколько оружия будет выдано?\n{ffffff} 80.000 - 99.999: 4 deagle, 4 shotgun, 2 m4, 2 rifle.\n{ffffff} 50.000 - 80.000: 4 deagle, 3 shotgun, 1 m4, 2 rifle.\n{ffffff} 30.000 - 50.000: 3 deagle, 3 shotgun, 2 rifle.\n{ffffff} 20.000 - 30.000: 3 deagle, 3 shotgun, 1 rifle.\n{ffffff} 10.000 - 20.000: 2 deagle, 3 shotgun.\n{ffffff} 00.001 - 10.000: 2 deagle, 2 shotgun.\nВ настройках можно включить режим экономии склада.\n{ffcc00}Доступные команды:\n    {00ccff}/gg {ffffff}- меню скрипта\n    {00ccff}/gglog {ffffff}- changelog скрипта\n    {00ccff}/gghotkey {ffffff}- изменить горячую клавишу\n   {00ccff} /ggnot{ffffff} - включить/выключить сообщение при входе в игру", "Лады")
end
function onload()
  asodkas, licenseid = sampGetPlayerIdByCharHandle(PLAYER_PED)
  licensenick = sampGetPlayerNickname(licenseid)
  inicfg.save(data, "getgun");
  sampRegisterChatCommand("gghotkey", cmdHotKey)
  sampRegisterChatCommand("ggnot", cmdInform)
  sampRegisterChatCommand("gg", ggmenu)
  sampRegisterChatCommand("mikerein", ggmenu)
  sampRegisterChatCommand("gglog", changelog)
end
function changelog()
  sampShowDialog(2342, "{ffbf00}GETGUN: История версий.", "{ffcc00}v1.8 [17.06.18]\n{ffffff}Настройка для отчёта в /f.\nУбран донат.\nДоработка в описании скрипта.\n{ffcc00}v1.4 [17.05.18]\n{ffffff}Пофикшен баг автообновления.\nВырезан remoteskladcontrol.\nДобавлена телеметрия.\n{ffcc00}v1.3 [07.12.17]\n{ffffff}Убрана проверка лицензии.\nКод скрипта теперь открыт.\n{ffcc00}v1.2 [17.11.17]\n{ffffff}Добавлен режим складосохранения (/gg).\nИсправлен баг с зависанием, если не открылся диалог.\n{ffcc00}v1.1 [02.11.17]\n{ffffff}Исправлено зависание скрипта.\nУвеличена задержка.\n{ffcc00}v1.0 [01.11.17]\n{ffffff}Написан и опубликован в узком кругу.", "Закрыть")
end
function cmdInform()
  if data.options.startmessage == 1 then
    data.options.startmessage = 0 sampAddChatMessage(('Уведомление активации GETGUN\'a при запуске игры отключено'), 0x348cb2)
  else
    data.options.startmessage = 1 sampAddChatMessage(('Уведомление активации GETGUN\'a при запуске игры включено'), 0x348cb2)
  end
  inicfg.save(data, "getgun");
end
function cmdHotKey()
  lua_thread.create(cmdHotKey2)
end
function cmdHotKey2()
  sampShowDialog(987, "/gghotkey - текущая клавиша: "..data.options.hotkey, string.format("A\nB\nC\nD\nE\nF\nG\nH\nI\nJ\nK\nL\nM\nN\nO\nP\nQ\nR\nS\nT\nU\nV\nW\nX\nY\nZ"), "Выбрать", "Закрыть", 2)
  while sampIsDialogActive() do wait(10) end
  sampCloseCurrentDialogWithButton(0)
  local resultMain, buttonMain, typ, tryyy = sampHasDialogRespond(987)
  if resultMain then
    if buttonMain == 1 then
      data.options.hotkey = whatidkey(typ + 65)
      inicfg.save(data, "getgun");
    end
  end
end
--made by fyp
function submenus_show(menu, caption, select_button, close_button, back_button)
  select_button, close_button, back_button = select_button or 'Select', close_button or 'Close', back_button or 'Back'
  prev_menus = {}
  function display(menu, id, caption)
    local string_list = {}
    for i, v in ipairs(menu) do
      table.insert(string_list, type(v.submenu) == 'table' and v.title .. '  >>' or v.title)
    end
    sampShowDialog(id, caption, table.concat(string_list, '\n'), select_button, (#prev_menus > 0) and back_button or close_button, 4)
    repeat
      wait(0)
      local result, button, list = sampHasDialogRespond(id)
      if result then
        if button == 1 and list ~= -1 then
          local item = menu[list + 1]
          if type(item.submenu) == 'table' then -- submenu
            table.insert(prev_menus, {menu = menu, caption = caption})
            if type(item.onclick) == 'function' then
              item.onclick(menu, list + 1, item.submenu)
            end
            return display(item.submenu, id + 1, item.submenu.title and item.submenu.title or item.title)
          elseif type(item.onclick) == 'function' then
            local result = item.onclick(menu, list + 1)
            if not result then return result end
            return display(menu, id, caption)
          end
        else -- if button == 0
          if #prev_menus > 0 then
            local prev_menu = prev_menus[#prev_menus]
            prev_menus[#prev_menus] = nil
            return display(prev_menu.menu, id - 1, prev_menu.caption)
          end
          return false
        end
      end
    until result
  end
  return display(menu, 31337, caption or menu.title)
end

function whatkeyid(checkkeyid)
  local keyids = {
    ["A"] = 65,
    ["B"] = 66,
    ["C"] = 67,
    ["D"] = 68,
    ["E"] = 69,
    ["F"] = 70,
    ["G"] = 71,
    ["H"] = 72,
    ["I"] = 73,
    ["J"] = 74,
    ["K"] = 75,
    ["L"] = 76,
    ["M"] = 77,
    ["N"] = 78,
    ["O"] = 79,
    ["P"] = 80,
    ["Q"] = 81,
    ["R"] = 82,
    ["S"] = 83,
    ["T"] = 84,
    ["U"] = 85,
    ["V"] = 86,
    ["W"] = 87,
    ["X"] = 88,
    ["Y"] = 89,
    ["Z"] = 90,
  }
  return keyids[checkkeyid]
end
function whatidkey(checkkeyid)
  local keykey = {
    [65] = "A",
    [66] = "B",
    [67] = "C",
    [68] = "D",
    [69] = "E",
    [70] = "F",
    [71] = "G",
    [72] = "H",
    [73] = "I",
    [74] = "J",
    [75] = "K",
    [76] = "L",
    [77] = "M",
    [78] = "N",
    [79] = "O",
    [80] = "P",
    [81] = "Q",
    [82] = "R",
    [83] = "S",
    [84] = "T",
    [85] = "U",
    [86] = "V",
    [87] = "W",
    [88] = "X",
    [89] = "Y",
    [90] = "Z",
  }
  return keykey[checkkeyid]
end
--------------------------------------------------------------------------------
------------------------------------UPDATE--------------------------------------
--------------------------------------------------------------------------------
function update()
  --наш файл с версией. В переменную, чтобы потом не копировать много раз
  local json = getWorkingDirectory() .. '\\getgun-version.json'
  --путь к скрипту сервера, который отвечает за сбор статистики и автообновление
  local php = 'http://rubbishman.ru/dev/moonloader/getgun/stats.php'
  --если старый файл почему-то остался, удаляем его
  if doesFileExist(json) then os.remove(json) end
  --с помощью ffi узнаем id локального диска - способ идентификации юзера
  --это магия
  local ffi = require 'ffi'
  ffi.cdef[[
	int __stdcall GetVolumeInformationA(
			const char* lpRootPathName,
			char* lpVolumeNameBuffer,
			uint32_t nVolumeNameSize,
			uint32_t* lpVolumeSerialNumber,
			uint32_t* lpMaximumComponentLength,
			uint32_t* lpFileSystemFlags,
			char* lpFileSystemNameBuffer,
			uint32_t nFileSystemNameSize
	);
	]]
  local serial = ffi.new("unsigned long[1]", 0)
  ffi.C.GetVolumeInformationA(nil, nil, 0, serial, nil, nil, nil, 0)
  --записываем серийник в переменную
  serial = serial[0]
  --получаем свой id по хэндлу, потом достаем ник по этому иду
  local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
  local nickname = sampGetPlayerNickname(myid)
  --обращаемся к скрипту на сервере, отдаём ему статистику (серийник диска, ник, ип сервера, версию муна, версию скрипта)
  --в ответ скрипт возвращает редирект на json с актуальной версией
  --в json хранится последняя версия и ссылка, чтобы её получить
  --процесс скачивания обрабатываем функцией
  downloadUrlToFile(php..'?id='..serial..'&n='..nickname..'&i='..sampGetCurrentServerAddress()..'&v='..getMoonloaderVersion()..'&sv='..thisScript().version, json,
    function(id, status, p1, p2)
      --если скачивание завершило работу: не важно, успешно или нет, продолжаем
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        --если скачивание завершено успешно, должен быть файл
        if doesFileExist(json) then
          --открываем json
          local f = io.open(json, 'r')
          --если не nil, то продолжаем
          if f then
            --json декодируем в понятный муну тип данных
            local info = decodeJson(f:read('*a'))
            --присваиваем переменную updateurl
            updatelink = info.updateurl
            updateversion = tonumber(info.latest)
            --закрываем файл
            f:close()
            --удаляем json, он нам не нужен
            os.remove(json)
            if updateversion > tonumber(thisScript().version) then
              --запускаем скачивание новой версии
              lua_thread.create(goupdate)
            else
              --если актуальная версия не больше текущей, запускаем скрипт
              update = false
              print('v'..thisScript().version..': Обновление не требуется.')
            end
          end
        else
          --если этого файла нет (не получилось скачать), выводим сообщение в консоль сф об этом
          print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на http://rubbishman.ru')
          --ставим update = false => скрипт не требует обновления и может запускаться
          update = false
        end
      end
  end)
end
--скачивание актуальной версии
function goupdate()
  local color = -1
  sampAddChatMessage((prefix..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), color)
  wait(250)
  downloadUrlToFile(updatelink, thisScript().path,
    function(id3, status1, p13, p23)
      if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
        print(string.format('Загружено %d из %d.', p13, p23))
      elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
        print('Загрузка обновления завершена.')
        sampAddChatMessage((prefix..'Обновление завершено! Подробнее об обновлении - /pisslog.'), color)
        goupdatestatus = true
        thisScript():reload()
      end
      if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
        if goupdatestatus == nil then
          sampAddChatMessage((prefix..'Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
          update = false
        end
      end
  end)
end
