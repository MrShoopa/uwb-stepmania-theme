local cp={};
local cp_key={};
local cp_hold={};
local cp_genv={};	-- [ja] アドオン内共通の変数 
local cp_lenv={};	-- [ja] 各スクリーンのローカル変数 

local key_name={
	'Start','Back','Select','Up','Down','Left','Right',
	'MenuUp','MenuDown','MenuLeft','MenuRight',
	'EffectUp','EffectDown',
};
function CPKeyReset()
	for p=1,2 do
		for k=1,#key_name do
			cp_key[""..p.."-"..key_name[k]]=false;
			cp_hold[""..p.."-"..key_name[k]]=false;
		end;
	end;
end;

-- [ja] タイトル画面に表示されるカスタムメニュー 
function CPScreen()
	local ret='';
	local menu=split(',',TC_GetOther('CustomMenu','Folder'));
	if #menu>=1 then
		ret=ret..',Custom1';
	end;
	if #menu>=2 then
		ret=ret..',Custom2';
	end;
	if #menu>=3 then
		ret=ret..',Custom3';
	end;
	if #menu>=4 then
		ret=ret..',Custom4';
	end;
	return ret;
end;
function CPScreen2()
	return 'ScreenCustomTitle2';
end;
function CPScreen3()
	return 'ScreenCustomTitle3';
end;
function CPScreen4()
	return 'ScreenCustomTitle4';
end;

local function C_Reset()
	cp={};
	CPKeyReset();
	cp_genv={};
	cp_lenv={};
end;

-- [ja] 初期化 
function C_Init(a_name)
	if cp["Name"] then
		C_SetChange(a_name);
	else
		cp["Name"]=a_name;
		C_SetLang();
		cp["Screen"]=1;
		CPKeyReset();
		cp_genv={};
		cp_lenv={};
		SCREENMAN:SetNewScreen("ScreenCustom1");
	end;
end;

-- [ja] 終了 
function C_End(s_name)
	C_Reset();
	SCREENMAN:SetNewScreen(s_name or "ScreenInit");
end;

local nextcustom='';
function C_SetChange(name)
	C_Reset();
	nextcustom=name;
	SCREENMAN:SetNewScreen("ScreenCustomChange");
end;
function C_GetChange()
	local ret=nextcustom;
	nextcustom='';
	return ret;
end;

-- [ja] キャンセル 
function C_Cancel(s_name)
	MESSAGEMAN:Broadcast("ScreenCancel",{Screen=s_name});
end;

-- [ja] 現在のカスタム名 
function C_GetCurName()
	return cp["Name"];
end;

function c_setenvg(name,var)
	cp_genv["cp-"..name]=var;
end;

function c_setenvl(name,var)
	cp_lenv["cp-"..name]=var;
end;

function c_getenvg(name)
	return cp_genv["cp-"..name];
end;

function c_getenvl(name)
	return cp_lenv["cp-"..name];
end;

function C_SetEnvG(name,var)
	c_setenvg(name,var);
end;

function C_SetEnvL(name,var)
	c_setenvl(name,var);
end;

function C_GetEnvG(name)
	return c_getenvg(name);
end;

function C_GetEnvL(name)
	return c_getenvl(name);
end;

function c_getkey(pn,k_name)
	return cp_key[((pn==PLAYER_1) and "1" or "2").."-"..k_name];
end;

function c_setkey(pn,k_name,stat)
	cp_key[((pn==PLAYER_1) and "1" or "2").."-"..k_name]=stat;
end;

function c_getholdkey(pn,k_name)
	return cp_hold[((pn==PLAYER_1) and "1" or "2").."-"..k_name];
end;

function c_setholdkey(pn,k_name,stat)
	cp_hold[((pn==PLAYER_1) and "1" or "2").."-"..k_name]=stat;
end;

--[ja] 押しているかを取得
function C_GetKey(pn,k_name)
	return c_getkey(pn,k_name);
end;
function C_SetKey(pn,k_name,stat)
	c_setkey(pn,k_name,stat);
end;

--[ja] 押し続けているかを取得
function C_GetHoldKey(pn,k_name)
	return c_getholdkey(pn,k_name);
end;
function C_SetHoldKey(pn,k_name,stat)
	c_setholdkey(pn,k_name,stat);
end;

function C_SetScreenNumber(nm)
	if nm>=1 and nm<=8 then
		cp["Screen"]=nm;
		CPKeyReset();
		cp_lenv={};
		SCREENMAN:SetNewScreen("ScreenCustom"..cp["Screen"]);
	end;
end;

function C_SetNextScreen()
	if cp["Screen"]<8 then
		cp["Screen"]=cp["Screen"]+1;
		CPKeyReset();
		cp_lenv={};
		SCREENMAN:SetNewScreen("ScreenCustom"..cp["Screen"]);
	end;
end;

function C_SetPrevScreen()
	if cp["Screen"]>1 then
		cp["Screen"]=cp["Screen"]-1;
		CPKeyReset();
		cp_lenv={};
		SCREENMAN:SetNewScreen("ScreenCustom"..cp["Screen"]);
	end;
end;

-- [ja] ディレクトリパスを返す（全体） 
function C_GetCustomDir()
	return THEME:GetCurrentThemeDirectory().."Customs/";
end;

-- [ja] ディレクトリパスを返す（機能別） 
function C_GetCustomPath()
	return C_GetCustomDir()..C_GetCurName()..'/';
end;

-- custom.ini
local cp_custom={};
function C_SetIni(c_name)
	if FILEMAN:DoesFileExist(C_GetCustomDir()..c_name.."/custom.ini") then
		local f=OpenFile(C_GetCustomPath()..c_name.."/custom.ini");
		local l_c_name=string.lower(c_name);
		local now_sec='main';
		while true do
			l=f:GetLine();
			local ll=string.lower(l);
			if f:AtEOF() then
				break;
			-- [ja] BOM考慮して .* を頭につける 
			elseif string.find(ll,"^.*%[.+%]$") then
				now_sec=split('%[',(split('%]',ll)[1]))[2];
			elseif (string.find(ll,"^.*=.*$") and (not string.find(ll,"^%/%/.*"))) then
				local text=split('=',l);
				cp_custom[l_c_name..'-'..now_sec..'-'..string.lower(text[1])]=text[2];
			end;
		end;
		CloseFile(f);
	end;
end;
function C_GetIni(c_name,sec,name)
	if cp_custom and cp_custom[""..string.lower(c_name).."-"..string.lower(sec).."-"..string.lower(name)] then
		return cp_custom[""..string.lower(c_name)..'-'..""..string.lower(sec).."-"..string.lower(name)];
	end;
	return "";
end;
-- [ja] 特定のパラメータの値を直接返す 
function C_SetIniPrm(c_name,sec,name)
	local ret='';
	if FILEMAN:DoesFileExist(C_GetCustomDir()..c_name.."/custom.ini") then
		local b=GetTextBlock(C_GetCustomDir()..c_name.."/custom.ini",sec);
		ret=GetBlockPrm(b,name);
	end;
	return ret;
end;

local cp_lang={};
-- [ja] 言語 
function C_SetLang()
	cp_lang={};
	local la={'en',THEME:GetCurLanguage()};
	for l=1,#la do
		if FILEMAN:DoesFileExist(C_GetCustomPath().."Languages/"..la[l]..".ini") then
			local f=OpenFile(C_GetCustomPath().."Languages/"..la[l]..".ini");
			local now_sec='common';
			while true do
				l=f:GetLine();
				local ll=string.lower(l);
				if f:AtEOF() then
					break;
				-- [ja] BOM考慮して .* を頭につける 
				elseif string.find(ll,"^.*%[.+%]$") then
					now_sec=split('%[',(split('%]',ll)[1]))[2];
				elseif (string.find(ll,"^.*=.*$") and (not string.find(ll,"^%/%/.*"))) then
					local text=split('=',l);
					cp_lang[now_sec..'-'..string.lower(text[1])]=text[2];
				end;
			end;
			CloseFile(f);
		end;
	end;
end;
function C_GetLang(sec,name)
	if cp_lang and cp_lang[""..string.lower(sec).."-"..string.lower(name)] then
		return cp_lang[""..string.lower(sec).."-"..string.lower(name)];
	end;
	return "";
end;