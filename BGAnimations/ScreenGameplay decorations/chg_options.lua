local t=Def.ActorFrame{};
local _SMV=GetSMVersion();

-- [ja] HighSpeedリストファイル（上に書かれているものほど優先される） 
local fn={
			THEME:GetCurrentThemeDirectory().."SpeedMods.txt",
			PROFILEMAN:GetProfileDir('ProfileSlot_Machine').."SpeedMods.txt"
		};
local l="";
for i=1,#fn do
	if FILEMAN:DoesFileExist(fn[i]) then
		local f=RageFileUtil.CreateRageFile();
		f:Open(fn[i],1);
		l=f:GetLine();
		f:Close();
		f:destroy();
	end;
end;
if l==nil or l=="" then
	l="0.25x,0.5x,0.75x,1x,1.5x,2x,2.5x,3x,3.5x,4x,4.5x,5x,5.5x,6x,6.5x,7x,7.5x,8x,C250,C300,C350,C400,C450,C500,C600,C700,m500,m550,m600,m650,m700";
end;
local speeds=split(",",l);

local spd_current = {nil,nil};	-- [ja] 現在の値
local spd_number  = {1,1};		-- [ja] 配列番号
local max_bpm     = {1,1};		-- [ja] 最高BPM
local scr_current = {false,false};

-- [ja] プレイヤー別処理
for gl_pn in ivalues(PlayerNumber) do
	if GAMESTATE:IsPlayerEnabled(gl_pn) then
		local p=((gl_pn=="PlayerNumber_P1") and 1 or 2);
		t[#t+1] = Def.ActorFrame{
			-- [ja] 初期化（OnCommandのタイミングで）
			OnCommand=function(self)
				if #speeds>1 then
					-- [ja] 現在のスピードと同じ値があればその配列番号を現在の値にする 
					for s=1,#speeds do
						local modstr=GAMESTATE:GetPlayerState(gl_pn):GetPlayerOptionsString("ModsLevel_Preferred");
						if string.find(modstr,speeds[s],0,true) then
							spd_current[p] = speeds[s];
							spd_number[p]  = s;
							break;
						end;
					end;
					-- [ja] 見つからない場合は1xにする
					if not spd_current[p] then
						for s=1,#speeds do
							if speeds[s]=="1x" then
								spd_current[p] = speeds[s];
								spd_number[p]  = s;
							end;
						end;
					end;
					-- [ja] まだ見つかっていない場合はファイルが不正なので1xにする
					if not spd_current[p] then
						speeds = {'1x'};
						spd_current[p] = '1x';
						spd_number[p]  = 1;
					end;
				else
					-- [ja] ファイルが不正な場合はとりあえず等倍
					speeds = {'1x'};
					spd_current[p] = '1x';
					spd_number[p]  = 1;
				end;
				-- [ja] M速用に最高BPMを取得しておく
				local st=_STEPS2(gl_pn);
				if st then
					local td=st:GetTimingData();
					local bpms=td:GetBPMs();
					max_bpm[p]=bpms[1];
					for i=1,#bpms do
						if bpms[i]>max_bpm[p] then max_bpm[p]=bpms[i]; end;
					end;
				end;
			end;
			-- [ja] コマンド
			CodeMessageCommand=function(self,params)
				local pn = params.PlayerNumber;
				if gl_pn == pn then
					-- [ja] ドリルモード以外、またはドリルモードでリアルタイムオプション変更を許可している場合
					if not IsDrill() or GetDrillRealTimeOpt() then
						local p=((pn=="PlayerNumber_P1") and 1 or 2);
						if params.Name == "ScrollNomal" then
							MESSAGEMAN:Broadcast('ChangeScroll',{PlayerNumber=pn,Reverse=false});
						end;
						if params.Name == "ScrollReverse" then
							MESSAGEMAN:Broadcast('ChangeScroll',{PlayerNumber=pn,Reverse=true});
						end;
						if params.Name == "HiSpeedUp" then
							spd_number[p] = spd_number[p]+1;
							if spd_number[p]>#speeds then spd_number[p]=1; end;
							spd_current[p] = speeds[spd_current[p]];
							MESSAGEMAN:Broadcast('ChangeHiSpeed',{PlayerNumber=pn,Speed=spd_number[p]});
						end;
						if params.Name == "HiSpeedDown" then
							spd_number[p] = spd_number[p]-1;
							if spd_number[p]<1 then spd_number[p]=#speeds; end;
							MESSAGEMAN:Broadcast('ChangeHiSpeed',{PlayerNumber=pn,Speed=spd_number[p]});
						end;
					end;
				end;
			end;
			-- [ja] スクロール方向変更
			ChangeScrollMessageCommand = function(self,params)
				local pn = params.PlayerNumber;
				if gl_pn == pn then
					local p=((pn=="PlayerNumber_P1") and 1 or 2);

					local ps = GAMESTATE:GetPlayerState(pn);
					local po_so=ps:GetPlayerOptions('ModsLevel_Song');
					local po_pr=ps:GetPlayerOptions('ModsLevel_Preferred');

					self:finishtweening();
					scr_current[p]=params.Reverse;
					if _SMV>30 then
						-- [ja] beta4以降
						local po_so=ps:GetPlayerOptions('ModsLevel_Song');
						local po_pr=ps:GetPlayerOptions('ModsLevel_Preferred');
						po_so:Reverse(scr_current[p] and 1 or 0,5);
						po_pr:Reverse(scr_current[p] and 1 or 0,5);
					else
						-- [ja] beta3以前（面倒なので旧版みたいにアニメーションさせない）
						local modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred");
						if scr_current[p] then
							modstr = modstr .. ", 100% reverse";
						else
							modstr = modstr .. ", 0% reverse";
						end;
						ps:SetPlayerOptions("ModsLevel_Preferred", modstr);
					end;
				end;
			end;
			-- [ja] ハイスピード変更
			ChangeHiSpeedMessageCommand = function(self,params)
				local pn = params.PlayerNumber;
				if gl_pn == pn then
					local p=((pn=="PlayerNumber_P1") and 1 or 2);

					local ps = GAMESTATE:GetPlayerState(pn);
					local po_so=ps:GetPlayerOptions('ModsLevel_Song');
					local po_pr=ps:GetPlayerOptions('ModsLevel_Preferred');

					spd_current[p] = speeds[params.Speed];
					local ctmp=split("C",spd_current[p]);
					local mtmp=split("m",spd_current[p]);
					if _SMV>30 then
						-- [ja] beta4以降
						po_so:CMod(1,9999);
						po_pr:CMod(1,9999);
						if #ctmp==2 then
							-- [ja] C速
							po_so:CMod(tonumber(ctmp[2]),9999);
							po_pr:CMod(tonumber(ctmp[2]),9999);
						elseif #mtmp==2 then
							-- [ja] M速
							po_so:XMod(tonumber(mtmp[2])/max_bpm[p],9999);
							po_so:MMod(tonumber(mtmp[2]),9999);
							po_pr:XMod(tonumber(mtmp[2])/max_bpm[p],9999);
							po_pr:MMod(tonumber(mtmp[2]),9999);
						else
							-- [ja] X速
							local xtmp=split("x",spd_current[p]);
							po_so:XMod(tonumber(xtmp[1]),9999);
							po_pr:XMod(tonumber(xtmp[1]),9999);
						end;
					else
						-- [ja] beta3以前
						if #ctmp==2 then
							-- [ja] C速
							modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred")..", C1";
						elseif #mtmp==2 then
							-- [ja] M速
							modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred")..", "..tonumber(mtmp[2])/max_bpm[p].."x, m"..mtmp[2];
						else
							-- [ja] X速
							modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred")..", "..spd_current[p];
						end;
						ps:SetPlayerOptions("ModsLevel_Preferred", modstr);
					end;
				end;
			end;
			-- [ja] スピード表記
			Def.ActorFrame{
				InitCommand=cmd(x,GetStepZonePosX(gl_pn);y,SCREEN_CENTER_Y;diffusealpha,0;);
				ChangeHiSpeedMessageCommand = function(self,params)
					local pn = params.PlayerNumber;
					if gl_pn == pn then
						local p=((pn=="PlayerNumber_P1") and 1 or 2);
						self:finishtweening();
						if not IsReverse(pn) then
							self:y(SCREEN_CENTER_Y+THEME:GetMetric("Player","ReceptorArrowsYStandard")+80);
						else
							self:y(SCREEN_CENTER_Y+THEME:GetMetric("Player","ReceptorArrowsYReverse")-50);
						end;
						(cmd(diffusealpha,1;sleep,2.0;linear,0.5;diffusealpha,0))(self);
					end;
				end;
				-- [ja] 背景の黒いところ
				Def.Quad{
					InitCommand=cmd(zoomto,256,20;diffuse,Color("Black");fadeleft,0.5;faderight,0.5;);
				};
				-- [ja] ハイスピード速度
				LoadFont("Common Normal")..{
					InitCommand=cmd(diffuse,Color("White");strokecolor,Color("Outline");zoom,0.75);
					ChangeHiSpeedMessageCommand = function(self,params)
						local pn = params.PlayerNumber;
						if gl_pn == pn then
							local p=((pn=="PlayerNumber_P1") and 1 or 2);
							self:settext(speeds[params.Speed]);
						end;
					end;
				};
				-- [ja] 左カーソル
				LoadFont("Common Normal")..{
					InitCommand=cmd(diffuse,Color("White");strokecolor,Color("Outline");zoom,0.5;x,-50;settext,'&MENULEFT;');
				};
				-- [ja] 右カーソル
				LoadFont("Common Normal")..{
					InitCommand=cmd(diffuse,Color("White");strokecolor,Color("Outline");zoom,0.5;x,50;settext,'&MENURIGHT;');
				};
			};
		};
	end;
end;

return t;