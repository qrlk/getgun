require 'lib.moonloader'
--------------------------------------------------------------------------------
-------------------------------------META---------------------------------------
--------------------------------------------------------------------------------
script_name("GETGUN")
script_description("/gg")
script_author("qrlk")
script_version("25.06.2022")
script_url("https://github.com/qrlk/getgun")

-- https://github.com/qrlk/qrlk.lua.moonloader
local enable_sentry = true -- false to disable error reports to sentry.io
if enable_sentry then
  local sentry_loaded, Sentry = pcall(loadstring, [=[return {init=function(a)local b,c,d=string.match(a.dsn,"https://(.+)@(.+)/(%d+)")local e=string.format("https://%s/api/%d/store/?sentry_key=%s&sentry_version=7&sentry_data=",c,d,b)local f=string.format("local target_id = %d local target_name = \"%s\" local target_path = \"%s\" local sentry_url = \"%s\"\n",thisScript().id,thisScript().name,thisScript().path:gsub("\\","\\\\"),e)..[[require"lib.moonloader"script_name("sentry-error-reporter-for: "..target_name.." (ID: "..target_id..")")script_description("���� ������ ������������� ������ ������� '"..target_name.." (ID: "..target_id..")".."' � ���������� �� � ������� ����������� ������ Sentry.")local a=require"encoding"a.default="CP1251"local b=a.UTF8;local c="moonloader"function getVolumeSerial()local d=require"ffi"d.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local e=d.new("unsigned long[1]",0)d.C.GetVolumeInformationA(nil,nil,0,e,nil,nil,nil,0)e=e[0]return e end;function getNick()local f,g=pcall(function()local f,h=sampGetPlayerIdByCharHandle(PLAYER_PED)return sampGetPlayerNickname(h)end)if f then return g else return"unknown"end end;function getRealPath(i)if doesFileExist(i)then return i end;local j=-1;local k=getWorkingDirectory()while j*-1~=string.len(i)+1 do local l=string.sub(i,0,j)local m,n=string.find(string.sub(k,-string.len(l),-1),l)if m and n then return k:sub(0,-1*(m+string.len(l)))..i end;j=j-1 end;return i end;function url_encode(o)if o then o=o:gsub("\n","\r\n")o=o:gsub("([^%w %-%_%.%~])",function(p)return("%%%02X"):format(string.byte(p))end)o=o:gsub(" ","+")end;return o end;function parseType(q)local r=q:match("([^\n]*)\n?")local s=r:match("^.+:%d+: (.+)")return s or"Exception"end;function parseStacktrace(q)local t={frames={}}local u={}for v in q:gmatch("([^\n]*)\n?")do local w,x=v:match("^	*(.:.-):(%d+):")if not w then w,x=v:match("^	*%.%.%.(.-):(%d+):")if w then w=getRealPath(w)end end;if w and x then x=tonumber(x)local y={in_app=target_path==w,abs_path=w,filename=w:match("^.+\\(.+)$"),lineno=x}if x~=0 then y["pre_context"]={fileLine(w,x-3),fileLine(w,x-2),fileLine(w,x-1)}y["context_line"]=fileLine(w,x)y["post_context"]={fileLine(w,x+1),fileLine(w,x+2),fileLine(w,x+3)}end;local z=v:match("in function '(.-)'")if z then y["function"]=z else local A,B=v:match("in function <%.* *(.-):(%d+)>")if A and B then y["function"]=fileLine(getRealPath(A),B)else if#u==0 then y["function"]=q:match("%[C%]: in function '(.-)'\n")end end end;table.insert(u,y)end end;for j=#u,1,-1 do table.insert(t.frames,u[j])end;if#t.frames==0 then return nil end;return t end;function fileLine(C,D)D=tonumber(D)if doesFileExist(C)then local E=0;for v in io.lines(C)do E=E+1;if E==D then return v end end;return nil else return C..D end end;function onSystemMessage(q,type,i)if i and type==3 and i.id==target_id and i.name==target_name and i.path==target_path and not q:find("Script died due to an error.")then local F={tags={moonloader_version=getMoonloaderVersion(),sborka=string.match(getGameDirectory(),".+\\(.-)$")},level="error",exception={values={{type=parseType(q),value=q,mechanism={type="generic",handled=false},stacktrace=parseStacktrace(q)}}},environment="production",logger=c.." (no sampfuncs)",release=i.name.."@"..i.version,extra={uptime=os.clock()},user={id=getVolumeSerial()},sdk={name="qrlk.lua.moonloader",version="0.0.0"}}if isSampAvailable()and isSampfuncsLoaded()then F.logger=c;F.user.username=getNick().."@"..sampGetCurrentServerAddress()F.tags.game_state=sampGetGamestate()F.tags.server=sampGetCurrentServerAddress()F.tags.server_name=sampGetCurrentServerName()else end;print(downloadUrlToFile(sentry_url..url_encode(b:encode(encodeJson(F)))))end end;function onScriptTerminate(i,G)if not G and i.id==target_id then lua_thread.create(function()print("������ "..target_name.." (ID: "..target_id..")".."�������� ���� ������, ����������� ����� 60 ������")wait(60000)thisScript():unload()end)end end]]local g=os.tmpname()local h=io.open(g,"w+")h:write(f)h:close()script.load(g)os.remove(g)end}]=])
  if sentry_loaded and Sentry then
    pcall(Sentry().init, { dsn = "https://1eeb7be80e4249889e1d2973ff83d827@o1272228.ingest.sentry.io/6529785" })
  end
end

-- https://github.com/qrlk/moonloader-script-updater
local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
  local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'���������� ����������. ������� ���������� c '..thisScript().version..' �� '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('��������� %d �� %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('�������� ���������� ���������.')sampAddChatMessage(b..'���������� ���������!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'���������� ������ ��������. �������� ���������� ������..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': ���������� �� ���������.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, ������� �� �������� �������� ����������. ��������� ��� ��������� �������������� �� '..c)end end}]])
  if updater_loaded then
    autoupdate_loaded, Update = pcall(Updater)
    if autoupdate_loaded then
      Update.json_url = "https://raw.githubusercontent.com/qrlk/getgun/master/version.json?" .. tostring(os.clock())
      Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
      Update.url = "https://github.com/qrlk/getgun"
    end
  end
end
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
    title = '���������� � �������',
    onclick = function()
      wait(100)
      cmdInfo()
    end
  },
  {
    title = '��������� � ������� (��� ���� ����)',
    onclick = function()
      os.execute('explorer "http://qrlk.me/sampcontact"')
    end
  },
  {
    title = ' ',
    onclick = function()
      if licensenick == "James_Bond" then
        sampShowDialog(988, "����� ������", string.format("��������\n���������"), "�������", "�������", 2)
        while sampIsDialogActive() do wait(100) end
        local resultMain, buttonMain, id = sampHasDialogRespond(988)
        if buttonMain == 1 then
          if id == 0 then sampSendChat('/f ������������ ����� ����������������! ��� ���������: OGUREC!') end
          if id == 1 then sampSendChat('/f �������������� ����� ����������������! ��� �����������: BANAN!') end
        end
      end
    end

  },
  {
    title = '{AAAAAA}���������'
  },
  {
    title = '���/���� ����� ����������������',
    onclick = function()
      cmdChangeMode()
    end
  },
  {
    title = '��������� �������',
    submenu = {
      {
        title = '�������� ������� ���������',
        onclick = function()
          cmdHotKey()
        end
      },
      {
        title = '��������/��������� ����������� ��� �������',
        onclick = function()
          cmdInform()
        end
      },
      {
        title = '��������/��������� ����� � /f',
        onclick = function()
          cmdChangeStorojMode()
        end
      },
      {
        title = '���/���� ��������������',
        onclick = function()
          if data.options.autoupdate == 1 then
            data.options.autoupdate = 0 sampAddChatMessage(('[GETGUN]: �������������� ���������'), color)
          else
            data.options.autoupdate = 1 sampAddChatMessage(('[GETGUN]: �������������� ��������'), color)
          end
          inicfg.save(data, "getgun")
        end
      },
    }
  },
  {
    title = '������� �������� �������',
    onclick = function()
      os.execute('explorer "http://qrlk.me/samp/getgun"')
    end
  },
  {
    title = ' '
  },
  {
    title = '{AAAAAA}����������'
  },
  {
    title = '�������������� �� ������ ���������!',
    onclick = function()
      os.execute('explorer "http://vk.com/qrlk.mods"')
    end
  }
}
function main()
  while not isSampAvailable() do wait(100) end
  if data.options.autoupdate == 1 then
    -- ������ ���, ���� ������ ��������� �������� ����������
    if autoupdate_loaded and enable_autoupdate and Update then
      pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end
    -- ������ ���, ���� ������ ��������� �������� ����������
  end
  firstload()
  onload()
  if data.options.startmessage == 1 then
    sampAddChatMessage(('GETGUN v'..thisScript().version..' �������. <> by qrlk.'),
    0x348cb2)
    sampAddChatMessage(('��������� - /gg ��� /bgg. ��������� ��� ��������� - /ggnot'), 0x348cb2)
  end
  lua_thread.create(remoteskladcontrol)

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
          while string.find(checkwarehouse, '�� ������ ��������', 1, true) == nil and stopthis2 < 5 do
            wait(0)
            checkwarehouse, prefix, color1, pcolor = sampGetChatString(capture)
            capture = capture - 1
            if capture < 90 then capture = 99 stopthis2 = stopthis2 + 1 end
          end
          if checkwarehouse ~= nil and string.find(checkwarehouse, '�� ������ ��������', 1, true) then
            warehouse = tonumber(string.match(checkwarehouse, "(%d+)"))
            if data.options.mode == 0 then
              if warehouse < 200001 and warehouse > 159999 then ggid(getgunid, 4, 2, 0, 0, 1, 2) end
              if warehouse < 160001 and warehouse > 139999 then ggid(getgunid, 3, 2, 0, 0, 1, 2) end
              if warehouse < 140001 and warehouse > 89999 then ggid(getgunid, 3, 2, 0, 0, 0, 2) end
              if warehouse < 90001 and warehouse > 39999 then ggid(getgunid, 2, 1, 0, 0, 0, 1) end
              if warehouse < 40001 and warehouse > 9999 then ggid(getgunid, 2, 1, 0, 0, 0, 0) end
              if warehouse < 10001 and warehouse > 0 then ggid(getgunid, 1, 1, 0, 0, 0, 0) end
            else
              ggid(getgunid, 2, 1, 0, 0, 0, 1)
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
          while string.find(checkwarehouse, '�� ������ ��������', 1, true) == nil and stopthis1 < 5 do
            wait(0)
            checkwarehouse, prefix, color1, pcolor = sampGetChatString(capture)
            capture = capture - 1
            if capture < 90 then capture = 99 stopthis1 = stopthis1 + 1 end
          end
          if checkwarehouse ~= nil and string.find(checkwarehouse, '�� ������ ��������', 1, true) then
            warehouse = tonumber(string.match(checkwarehouse, "(%d+)"))
            if data.options.mode == 0 then
              if warehouse < 200001 and warehouse > 159999 then print(1) gg(4, 2, 0, 0, 1, 2) end
              if warehouse < 160001 and warehouse > 139999 then print(2) gg(3, 2, 0, 0, 1, 2) end
              if warehouse < 140001 and warehouse > 89999 then print(3) gg(3, 2, 0, 0, 0, 2) end
              if warehouse < 90001 and warehouse > 39999 then print(4) gg(2, 1, 0, 0, 0, 1) end
              if warehouse < 40001 and warehouse > 9999 then print(5) gg(2, 1, 0, 0, 0, 0) end
              if warehouse < 10001 and warehouse > 0 then print(6) gg(1, 1, 0, 0, 0, 0) end
            else
              gg(2, 1, 0, 0, 0, 1)
            end
          end
        end
      end
    end
  end
end

function cmdChangeMode()
  if data.options.mode == 1 then data.options.mode = 0 sampAddChatMessage('����� ���������������� �������������.', color) else data.options.mode = 1 sampAddChatMessage('����� ���������������� �����������.', color)
  end
  inicfg.save(data, "getgun")
end

function cmdChangeStorojMode()
  if data.options.doklad == 1 then data.options.doklad = 0 sampAddChatMessage('����� ������� ��������.', color) else data.options.doklad = 1 sampAddChatMessage('����� ������� �������.', color)
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
  if gtgdeagle ~= 0 then wait(50) end
  getgun(1, gtgshotgun)
  if gtgshotgun ~= 0 then wait(50) end
  getgun(2, gtgsmg)
  if gtgsmg ~= 0 then wait(50) end
  getgun(3, gtgak47)
  if gtgak47 ~= 0 then wait(50) end
  getgun(4, gtgm4a1)
  if gtgm4a1 ~= 0 then wait(50) end
  getgun(5, gtgrifle)
  wait(200)
  sampShowDialog()
  sampCloseCurrentDialogWithButton(0)
  if countgg > 0 then
    countgg = countgg
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    local bikernick = sampGetPlayerNickname(myid)
    if string.find(bikernick, "_") then
      local bikername, bikersurname = string.match(bikernick, "(%g+)_(%g+)")
      if data.options.doklad == 1 then wait(1100) sampSendChat("/f [������]: "..bikername.." "..bikersurname.." ���� �� ������ ������ �� "..countgg.." ����������!") end
    else
      if data.options.doklad == 1 then wait(1100) sampSendChat("/f [������]: "..bikernick.." ���� �� ������ ������ �� "..countgg.." ����������!") end
    end
  end
  countgg = 0
end

function ggid(getgunider, gtgdeagle, gtgshotgun, gtgsmg, gtgak47, gtgm4a1, gtgrifle)
  wait(0)
  countgg = gtgdeagle * 42 + gtgshotgun * 30 + gtgsmg * 120 + gtgak47 * 180 + gtgm4a1 * 300 + gtgrifle * 50
  getgun(0, gtgdeagle)
  if gtgdeagle ~= 0 then wait(50) end
  getgun(1, gtgshotgun)
  if gtgshotgun ~= 0 then wait(50) end
  getgun(2, gtgsmg)
  if gtgsmg ~= 0 then wait(50) end
  getgun(3, gtgak47)
  if gtgak47 ~= 0 then wait(50) end
  getgun(4, gtgm4a1)
  if gtgm4a1 ~= 0 then wait(50) end
  getgun(5, gtgrifle)
  wait(200)
  sampShowDialog()
  sampCloseCurrentDialogWithButton(0)
  if countgg > 0 then
    countgg = countgg
    if string.find(ggidnick, "_") then
      if data.options.doklad == 1 then wait(1100) sampSendChat("/f [������]: "..ggidname.."'� "..ggidsurname.."'� ���� ������ "..countgg.." ���������� �� ������!") end
    else
      if data.options.doklad == 1 then wait(1100) sampAddChatMessage("/f [������]: "..ggidnick.."'� ���� ������ "..countgg.." ���������� �� ������!") end
    end
  end
  countgg = 0
end

function getgun(gtgtype, gtgkolvo)
  if gtgkolvo > 0 then
    --sampAddChatMessage(string.format("������ ������ ������: "..gtgtype..". �������� �������: "..gtgkolvo.."."), 0xFA73D3)
    gtgkolvo = gtgkolvo - 1
    wait(50)
    sampSendDialogResponse(123, 1, gtgtype, - 1)
    return getgun(gtgtype, gtgkolvo)
  end
end
--
function firstload()
  if data.options.mode == nil then data.options.mode = 0 end
  inicfg.save(data, "getgun")
end
function ggmenu()
  menutrigger = 1
end
function menu()
  submenus_show(mod_submenus_sa, '{348cb2}GETGUN v'..thisScript().version..'', '�������', '�������', '�����')
end
function cmdInfo()
  sampShowDialog(2342, "{ffbf00}GETGUN. �����: qrlk.", "{ffcc00}��� ���� ���� ������?\n{ffffff}���� �������: ���������������� ����� � ������ ������ �� ������ �������� �� Samp-Rp.\n{ffcc00}��� �� ��������?\n{ffffff}���� ��� ������ ������ GETGUN{ffffff}: {348cb2}������ ����{ffffff} � {348cb2}������ ��������{ffffff}.\n{348cb2}  ������ ����:{ffffff}\n������� ������� ������� {00ccff}"..data.options.hotkey.."{ffffff} � ���� � ������. \n���������� ������ ������� �� �������� ��������� ������ � ���-�� ������ � ��� �� �����.\n��������, ���� ����� ��������� ����� 4 ����� �����, �� � ��� ��� ���� 3, �� ����� ����� ������ 1.\n{348cb2}  ������ ��������:\n{ffffff}���������� �� �������� � ������� ������� ������� {00ccff}"..data.options.hotkey.."{ffffff} � ���� � ������.\n���������� ����������� �������� ������ ������� ������ �� �������� ��������� ������.\n����� ���������� ���������� �������� �� ����� ������ ������� �� ����������, ����� � �������.\n{ffcc00}������� ������ ����� ������?\n{ffffff} 160.000 - 200.000: 5 deagle, 2 shotgun, 1 m4, 2 rifle.\n{ffffff} 140.000 - 160.000: 4 deagle, 2 shotgun, 1 m4, 2 rifle.\n{ffffff} 090.000 - 140.000: 3 deagle, 2 shotgun, 2 rifle.\n{ffffff} 040.000 - 090.000: 3 deagle, 1 shotgun, 1 rifle.\n{ffffff} 010.000 - 030.000: 3 deagle, 1 shotgun.\n{ffffff} 000.001 - 010.000: 2 deagle, 1 shotgun.\n� ���������� ����� �������� ����� �������� ������.\n{ffffff} ����������������: 3 deagle, 1 shotgun, 1 rifle.\n{ffcc00}��������� �������:\n    {00ccff}/gg{ffffff} ��� {00ccff}/bgg {ffffff}- ���� �������\n    {00ccff}/gghotkey {ffffff}- �������� ������� �������\n    {00ccff}/getgunchangelog {ffffff}- ������� ����������\n   {00ccff} /ggnot{ffffff} - ��������/��������� ��������� ��� ����� � ����", "����")
  --[[
	if data.options.mode == 0 then
		if warehouse < 200001 and warehouse > 159999 then gg(4, 2, 0, 0, 1, 2) end
		if warehouse < 160001 and warehouse > 139999 then gg(3, 2, 0, 0, 1, 2) end
		if warehouse < 140001 and warehouse > 89999 then gg(3, 2, 0, 0, 0, 2) end
		if warehouse < 90001 and warehouse > 29999 then gg(2, 1, 0, 0, 0, 1) end
		if warehouse < 30001 and warehouse > 9999 then gg(2, 1, 0, 0, 0, 0) end
		if warehouse < 10001 and warehouse > 0 then gg(1, 1, 0, 0, 0, 0) end
	else
		gg(3, 1, 0, 0, 0, 2)]]
end
function remoteskladcontrol()
  while true do
    wait(0)
    local text9, prefix9, color9, pcolor9 = sampGetChatString(99)
    if string.find(text9, " President  James_Bond%[%d+%]:  ������������ ����� ����������������! ��� ���������: OGUREC!") then
      wait(1000)
      data.options.mode = 1
      sampAddChatMessage('����� ���������������� �����������.', color)
      sampSendChat("/f 10-4 OGUREC, ���������� ���������.")
      inicfg.save(data, "getgun")
    end
    if string.find(text9, " President  James_Bond%[%d+%]:  �������������� ����� ����������������! ��� �����������: BANAN!") then
      wait(1000)
      data.options.mode = 0
      sampAddChatMessage('����� ���������������� �������������.', color)
      sampSendChat("/f 10-4 BANAN, ���������� ���������.")
      inicfg.save(data, "getgun")
    end
  end
end
function onload()
  asodkas, licenseid = sampGetPlayerIdByCharHandle(PLAYER_PED)
  licensenick = sampGetPlayerNickname(licenseid)
  inicfg.save(data, "getgun")
  sampRegisterChatCommand("gghotkey", cmdHotKey)
  sampRegisterChatCommand("ggnot", cmdInform)
  sampRegisterChatCommand("gg", ggmenu)
  sampRegisterChatCommand("bgg", ggmenu)
end
function cmdInform()
  if data.options.startmessage == 1 then
    data.options.startmessage = 0 sampAddChatMessage(('����������� ��������� GETGUN\'a ��� ������� ���� ���������'), 0x348cb2)
  else
    data.options.startmessage = 1 sampAddChatMessage(('����������� ��������� GETGUN\'a ��� ������� ���� ��������'), 0x348cb2)
  end
  inicfg.save(data, "getgun")
end
function cmdHotKey()
  lua_thread.create(cmdHotKey2)
end
function cmdHotKey2()
  sampShowDialog(987, "/gghotkey - ������� �������: "..data.options.hotkey, string.format("A\nB\nC\nD\nE\nF\nG\nH\nI\nJ\nK\nL\nM\nN\nO\nP\nQ\nR\nS\nT\nU\nV\nW\nX\nY\nZ"), "�������", "�������", 2)
  while sampIsDialogActive() do wait(10) end
  sampCloseCurrentDialogWithButton(0)
  local resultMain, buttonMain, typ, tryyy = sampHasDialogRespond(987)
  if resultMain then
    if buttonMain == 1 then
      data.options.hotkey = whatidkey(typ + 65)
      inicfg.save(data, "getgun")
    end
  end
end
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