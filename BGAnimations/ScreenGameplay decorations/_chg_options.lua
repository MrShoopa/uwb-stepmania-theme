local function SetwaieiPlayerOptions_39Mini(bMini,cl,reverse,piur,sec)
	for i=1,#cl do
		cl[i]:finishtweening();
		cl[i]:linear(sec);
		if bMini then
			cl[i]:zoom(0.5);
			cl[i]:x(0);
			cl[i]:addx(32*(i-2.5));	--TODO
			if reverse then
				if piur then
					cl[i]:y((THEME:GetMetric("Player","ReceptorArrowsYStandard")+10)/2);
				else
					cl[i]:y((THEME:GetMetric("Player","ReceptorArrowsYReverse")+5)/2);		-- [ja] なぜか+5px 
				end;
			else
				if piur then
					cl[i]:y((THEME:GetMetric("Player","ReceptorArrowsYReverse")+5)/2);
				else
					cl[i]:y((THEME:GetMetric("Player","ReceptorArrowsYStandard")+10)/2);	-- [ja] なぜか（略） 
				end;
			end;
		else
			cl[i]:zoom(1);
			cl[i]:x(0);
			cl[i]:y(0);
		end;
	end;
end;
local function SetwaieiPlayerOptions_PIUReverse(bPIUR,cl,sec)
	for i=1,#cl do
		cl[i]:finishtweening();
		cl[i]:linear(sec);
		if bPIUR then
			cl[i]:rotationx(180);
		else
			cl[i]:rotationx(0);
		end;
	end;
end;

local function SetwaieiPlayerOptions(prm,pn,b,sec,scroll,scroll_piur)
	local bOption=b;
	local nm=ToEnumShortString(pn);
	local p=(pn==PLAYER_1) and 1 or 2;
	local c=SCREENMAN:GetTopScreen():GetChild('PlayerP'..p);
	if c then
		local ps = GAMESTATE:GetPlayerState('PlayerNumber_P'..p);
		local po = ps:GetPlayerOptions("ModsLevel_Preferred");
		local modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred");
		local reverse=false;
		if string.find(modstr,"^.*Reverse.*") and (not scroll[p]) then
			reverse=true;
		else
			reverse=scroll[p];
		end;
		local piur=scroll_piur[p];
		n=c:GetChild('NoteField');
		if GetSMVersion()>=50 and n then
			local cl=n:get_column_actors();
			if prm=="3.9 Mini" then
				SetwaieiPlayerOptions_39Mini(bOption,cl,reverse,piur,sec);
			elseif prm=="PIU Reverse" then
				SetwaieiPlayerOptions_PIUReverse(bOption,cl,sec);
			end;
		end;
	end;
	return bOption;
end;

local t=Def.ActorFrame{};
local _SMV=GetSMVersion();
-- [ja] スピード、スクロール切り替え
local speed_cs={"",""};
local speed_ce={"",""};
local speed_cnt={0,0};
local scroll={false,false};
local scroll_per={0,0};
local scroll_cnt={0,0};
local scroll_piur={GetwaieiPlayerOptions(PLAYER_1,"PIU Reverse"),GetwaieiPlayerOptions(PLAYER_2,"PIU Reverse")};
local scroll_mini={GetwaieiPlayerOptions(PLAYER_1,"3.9 Mini"),GetwaieiPlayerOptions(PLAYER_2,"3.9 Mini")};
local speeds="";
local fn1=THEME:GetCurrentThemeDirectory().."_UserCustom/SpeedMods.txt";
local fn2=""..PROFILEMAN:GetProfileDir('ProfileSlot_Machine').."SpeedMods.txt";
local l="";
if FILEMAN:DoesFileExist(fn1) then
	local f=RageFileUtil.CreateRageFile();
	f:Open(fn1,1);
	l=f:GetLine();
	f:Close();
	f:destroy();
elseif FILEMAN:DoesFileExist(fn2) then
	local f=RageFileUtil.CreateRageFile();
	f:Open(fn2,1);
	l=f:GetLine();
	f:Close();
	f:destroy();
end;
if l==nil or l=="" then
	l="0.25x,0.5x,0.75x,1x,1.5x,2x,2.5x,3x,3.5x,4x,4.5x,5x,5.5x,6x,6.5x,7x,7.5x,8x,C250,C300,C350,C400,C450,C500,C600,C700,m500,m550,m600,m650,m700";
else
end;
speeds=split(",",l);
local now_speed_t={1,1};
local now_speed_s={"nil","nil"};
local bpm_h={1,1};
for pn in ivalues(PlayerNumber) do
	t[#t+1] = Def.Actor{
		OnCommand=function(self)
			local p=((pn=="PlayerNumber_P1") and 1 or 2);
			if #speeds>1 then
				for i=1,#speeds do
					local modstr=GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString("ModsLevel_Preferred");
					if string.find(modstr,speeds[i],0,true) then
						now_speed_t[p]=i;
						now_speed_s[p]=speeds[i];
						break;
					end;
				end;
				if now_speed_s[p]=="nil" then
					for i=1,#speeds do
						if speeds[i]=="1x" then
							now_speed_t[p]=i;
							now_speed_s[p]=speeds[i];
						end;
					end;
				end;
				local _st=GAMESTATE:GetCurrentSteps(pn);
				if _st then
					local _td=_st:GetTimingData();
					local bpms=_td:GetBPMs();
					bpm_h[p]=bpms[1];
					for i=1,#bpms do
						if bpms[i]>bpm_h[p] then bpm_h[p]=bpms[i]; end;
					end;
				end;
			end;
		end;
	};
end;

speedscroll = Def.ActorFrame{
	Def.Actor{
		OnCommand=function(self)
			if GAMESTATE:IsCourseMode() then
				if _COURSE() then
					if _COURSE():IsOni() then
						for p=1,2 do
							if GAMESTATE:IsPlayerEnabled("PlayerNumber_P"..p) then
								local ps = GAMESTATE:GetPlayerState("PlayerNumber_P"..p);
								local po = ps:GetPlayerOptions("ModsLevel_Preferred");
								local modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred")..","..now_speed_s[1];
								ps:SetPlayerOptions("ModsLevel_Preferred", modstr);
							end;
						end;
					end;
				end;
			else
				for p=1,2 do
					scroll_mini[p]=SetwaieiPlayerOptions("3.9 Mini","PlayerNumber_P"..p,scroll_mini[p],0,scroll,scroll_piur);
					scroll_piur[p]=SetwaieiPlayerOptions("PIU Reverse","PlayerNumber_P"..p,scroll_piur[p],0,scroll,scroll_piur);
				end;
			end;
		end;
		CodeMessageCommand=function(self,params)
			if not IsDrill() or GetDrillRealTimeOpt() then
				local pn = params.PlayerNumber;
				local p=((pn=="PlayerNumber_P1") and 1 or 2);
				local ps = GAMESTATE:GetPlayerState(pn);
				local po = ps:GetPlayerOptions("ModsLevel_Preferred");
				local modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred");
				if string.find(modstr,"^.*Reverse.*") and (not scroll[p]) then
					scroll[p]=true;
					scroll_per[p]=100;
				end;
				if params.Name == "ScrollNomal" then
					scroll_cnt[p]=25;
					scroll[p]=false;
					if _SMV>30 then
						local po_so=ps:GetPlayerOptions('ModsLevel_Song');
						local po_pr=ps:GetPlayerOptions('ModsLevel_Preferred');
						po_so:Reverse(0,5);
						po_pr:Reverse(0,5);
					end;
					scroll_mini[p]=SetwaieiPlayerOptions("3.9 Mini","PlayerNumber_P"..p,scroll_mini[p],0,scroll,scroll_piur);
				elseif params.Name == "ScrollReverse" then
					scroll_cnt[p]=25;
					scroll[p]=true;
					if _SMV>30 then
						local po_so=ps:GetPlayerOptions('ModsLevel_Song');
						local po_pr=ps:GetPlayerOptions('ModsLevel_Preferred');
						po_so:Reverse(1,5);
						po_pr:Reverse(1,5);
					end;
					scroll_mini[p]=SetwaieiPlayerOptions("3.9 Mini","PlayerNumber_P"..p,scroll_mini[p],0,scroll,scroll_piur);
				elseif params.Name == "HiSpeedUp" then
					speed_cnt[p]=25;
					now_speed_t[p]=now_speed_t[p]+1;
					if now_speed_t[p]>#speeds then now_speed_t[p]=1; end;
					local ctmp=split("C",speeds[now_speed_t[p]]);
					local mtmp=split("m",speeds[now_speed_t[p]]);
					if _SMV<=30 then
						if #ctmp==2 then
							modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred")..", C1";
							ps:SetPlayerOptions("ModsLevel_Preferred", modstr);
						end;
						if #mtmp==2 then
							modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred")..", "..tonumber(mtmp[2])/bpm_h[1].."x, m"..mtmp[2];
						else
							modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred")..", "..speeds[now_speed_t[p]];
						end;
						ps:SetPlayerOptions("ModsLevel_Preferred", modstr);
					else
						local po_so=ps:GetPlayerOptions('ModsLevel_Song');
						local po_pr=ps:GetPlayerOptions('ModsLevel_Preferred');
						po_so:CMod(1,9999);
						po_pr:CMod(1,9999);
						if #ctmp==2 then
							po_so:CMod(tonumber(ctmp[2]),9999);
							po_pr:CMod(tonumber(ctmp[2]),9999);
						elseif #mtmp==2 then
							po_so:XMod(tonumber(mtmp[2])/bpm_h[1],9999);
							po_so:MMod(tonumber(mtmp[2]),9999);
							po_pr:XMod(tonumber(mtmp[2])/bpm_h[1],9999);
							po_pr:MMod(tonumber(mtmp[2]),9999);
						else
							local xtmp=split("x",speeds[now_speed_t[p]]);
							po_so:XMod(tonumber(xtmp[1]),9999);
							po_pr:XMod(tonumber(xtmp[1]),9999);
						end;
					end;
				elseif params.Name == "HiSpeedDown" then
					speed_cnt[p]=25;
					now_speed_t[p]=now_speed_t[p]-1;
					if now_speed_t[p]<1 then now_speed_t[p]=#speeds; end;
					local ctmp=split("C",speeds[now_speed_t[p]]);
					local mtmp=split("m",speeds[now_speed_t[p]]);
					if _SMV<=30 then
						if #ctmp==2 then
							modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred")..", C1";
							ps:SetPlayerOptions("ModsLevel_Preferred", modstr);
						end;
						if #mtmp==2 then
							modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred")..", "..tonumber(mtmp[2])/bpm_h[1].."x, m"..mtmp[2];
						else
							modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred")..", "..speeds[now_speed_t[p]];
						end;
						ps:SetPlayerOptions("ModsLevel_Preferred", modstr);
					else
						local po_so=ps:GetPlayerOptions('ModsLevel_Song');
						local po_pr=ps:GetPlayerOptions('ModsLevel_Preferred');
						po_so:CMod(1,9999);
						po_pr:CMod(1,9999);
						if #ctmp==2 then
							po_so:CMod(tonumber(ctmp[2]),9999);
							po_pr:CMod(tonumber(ctmp[2]),9999);
						elseif #mtmp==2 then
							po_so:XMod(tonumber(mtmp[2])/bpm_h[1],9999);
							po_so:MMod(tonumber(mtmp[2]),9999);
							po_pr:XMod(tonumber(mtmp[2])/bpm_h[1],9999);
							po_pr:MMod(tonumber(mtmp[2]),9999);
						else
							local xtmp=split("x",speeds[now_speed_t[p]]);
							po_so:XMod(tonumber(xtmp[1]),9999);
							po_pr:XMod(tonumber(xtmp[1]),9999);
						end;
					end;
				elseif params.Name == "ScrollPIUNomal" and scroll_piur[p] then
					-- Child('PlayerPX'):Child('NoteField'):get_column_actors() でカラム単位で取れる？（テーブルで返る） 
					scroll_piur[p]=SetwaieiPlayerOptions("PIU Reverse","PlayerNumber_P"..p,false,0.2,scroll,scroll_piur);
				elseif params.Name == "ScrollPIUReverse" and not scroll_piur[p] then
					scroll_piur[p]=SetwaieiPlayerOptions("PIU Reverse","PlayerNumber_P"..p,true,0.2,scroll,scroll_piur);
				end;
			end;
		end;
	};
};
local function spsc_update(self)
	for p=1,2 do
		local pn="PlayerNumber_P"..p;
		if GAMESTATE:IsPlayerEnabled(pn) then
			local ps = GAMESTATE:GetPlayerState(pn);
			if scroll_cnt[p]>0 then
				if scroll[p]==true then
					scroll_per[p]=scroll_per[p]+(100-scroll_per[p])/scroll_cnt[p];
				else
					scroll_per[p]=scroll_per[p]-scroll_per[p]/scroll_cnt[p];
				end;
				if _SMV<=30 then
					local modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred");
					modstr = modstr .. ", " .. scroll_per[p] .. "% reverse";
					ps:SetPlayerOptions("ModsLevel_Preferred", modstr);
				end;
				scroll_cnt[p]=scroll_cnt[p]-1;
			end;
		end;
	end;
end;

speedscroll.InitCommand=cmd(SetUpdateFunction,spsc_update;);
t[#t+1] = speedscroll;

-- [ja] 倍速表示 
for pn in ivalues(PlayerNumber) do
	if GAMESTATE:IsPlayerEnabled(pn) then
		t[#t+1]=Def.ActorFrame{
			CodeMessageCommand=function(self,params)
				if not IsDrill() or GetDrillRealTimeOpt() then
					local pn = params.PlayerNumber;
					if params.PlayerNumber==pn
						and (params.Name == "HiSpeedUp" or params.Name == "HiSpeedDown") then
						self:playcommand("Set");
					end;
				end;
			end;
			Def.Quad{
				InitCommand=cmd(zoomto,256,80;x,GetStepZonePosX(pn);y,SCREEN_CENTER_Y;
					diffuse,Color("Black");fadeleft,0.5;faderight,0.5;diffusealpha,0;);
				SetCommand=function(self)
					local p=((pn=="PlayerNumber_P1") and 1 or 2);
					self:finishtweening();
					if not IsReverse(pn) and not scroll_piur[p] then
						self:y(SCREEN_CENTER_Y+THEME:GetMetric("Player","ReceptorArrowsYStandard")+80);
					else
						self:y(SCREEN_CENTER_Y+THEME:GetMetric("Player","ReceptorArrowsYReverse")-80);
					end;
					(cmd(finishtweening;diffusealpha,1;sleep,2.0;linear,0.5;diffusealpha,0))(self);
				end;
			};
			LoadFont("Common Normal")..{
				InitCommand=cmd(x,GetStepZonePosX(pn);
					diffuse,Color("White");strokecolor,Color("Outline");diffusealpha,0;);
				SetCommand=function(self)
					local p=((pn=="PlayerNumber_P1") and 1 or 2);
					self:finishtweening();
					if not IsReverse(pn) and not scroll_piur[p] then
						self:y(SCREEN_CENTER_Y+THEME:GetMetric("Player","ReceptorArrowsYStandard")+80);
					else
						self:y(SCREEN_CENTER_Y+THEME:GetMetric("Player","ReceptorArrowsYReverse")-80);
					end;
					self:settext(speeds[now_speed_t[p]]);
					(cmd(diffusealpha,1;sleep,2.0;linear,0.5;diffusealpha,0))(self);
				end;
			};
		};
	end;
end;

return t;