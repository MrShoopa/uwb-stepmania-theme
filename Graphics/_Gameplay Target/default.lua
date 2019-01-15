--[[
	[ja] ライバル表示
	mini ： trueの場合、+-と名前、アバター表示のみの簡易的なもの
--]]
local pn,rn,mini=...;
local p=(pn==PLAYER_1) and 1 or 2;
local t=Def.ActorFrame{};
local player_rival='';

if GetPlayerSaveProfileFile(pn)~='' then
	player_rival=GetBlockPrm(GetTextBlock(GetPlayerSaveProfileFile(pn),'Rival'),rn);
end;
if player_rival=='' then
    if rn == 1 then
        player_rival = 'hiscore';
    else
        return t;
    end;
end;

local RIVAL_WIN_COLOR = Color('Blue');
local RIVAL_LOSE_COLOR = Color('Red');
local RIVAL_DRAW_COLOR = {0.8,0.8,0.8,1.0};

local rival_name        = '';
local rival_avatar      = '';
local rival_avatar_mode = 0;	-- [ja] 0：固定画像　1：waieiアバター　2：CSアバター 
local rival_special     = 0;	-- [ja] 0：通常ライバル　1：ハイスコア 
local rival_dp          = 0;
if player_rival then
	rival_name = GetCSRivalName(player_rival);
	-- [ja] CSRealScoreフォルダ内のライバル情報を取得 
	local chkdir = './CSRealScore/'..player_rival..'/';
	if FILEMAN:DoesFileExist(chkdir..'waieiAvatar.ini') then
		-- [ja] waieiアバター 
		rival_avatar      = chkdir..'waieiAvatar.ini';
		rival_avatar_mode = 1;
	elseif FileExist(chkdir..'CSAvatar') then
		-- [ja] CSアバター 
		rival_avatar      = GetFileExist(chkdir..'CSAvatar');
		rival_avatar_mode = 2;
	else
		if string.lower(player_rival)=='hiscore'
			or string.lower(player_rival)=='highscore' then
			-- [ja] ハイスコア 
			rival_name    = 'High Score';
			rival_avatar  = GetNoImageAvatar('hiscore');
			rival_special = 1;
		else
			-- [ja] アバターなしの場合ランダム画像 
			if rival_name=='' then
				rival_avatar = GetNoImageAvatar(DayOfYear()%9+1);
			else
				rival_avatar = GetNoImageAvatar(tonumber(string.byte(rival_name))%9+1);
			end;
		end;
		rival_avatar_mode = 0;
	end;
end;
-- [ja] 不正なアバター画像 
if rival_avatar=='' then
	rival_avatar      = THEME:GetPathG('','_blank');
	rival_avatar_mode = 0;
end;

-- [ja] ライバルのダンスポイントを取得 
if rival_special==1 then
	-- [ja] ハイスコア 
	local pf;
	if nm==""..ToEnumShortString(pn) then
		pf=PROFILEMAN:GetMachineProfile();
	else
		if PROFILEMAN:IsPersistentProfile(pn) then
			-- player profile
			pf=PROFILEMAN:GetProfile(pn);
		else
			-- machine profile
			pf=PROFILEMAN:GetMachineProfile();
		end;
	end;
	target_hi=pf:GetHighScoreList(_SONG(),GAMESTATE:GetCurrentSteps(pn)):GetHighScores();
	rival_dp = GetScoreData(target_hi,"dp");	-- [ja] 99 waiei.lua 
else
	-- [ja] 通常ライバル 
	local txt = GetCSRivalParameter(_SONG2(),_STEPS2(pn),player_rival);
	rival_dp  = GetCSRivalPercent(_STEPS2(pn),txt);
end;

local rival_current;
if mini then
	-- [ja] 小表示
	local box_size_x = 160;
	local box_size_y =  60;
	t[#t+1]=Def.ActorFrame{
		TargetScoreMessageCommand = function(self,params)
			--[[
				params.PlayerNumber = プレイヤー番号
				params.DPPlayer = プレイヤーの現在のダンスポイント
				params.DPCurrent = 全体のステップ数から見た現在のパーセント
			--]]
			if params.PlayerNumber==pn then
				self:playcommand('UpdateRival',{
					PlayerNumber = pn,
					RivalNumber  = rn,
					DPRival   = round(rival_dp*params.DPCurrent*10000)*0.01,
					DPPlayer  = round(params.DPPlayer*10000)*0.01,
					DPCurrent = params.DPCurrent,
				});
			end;
		end;
		-- [ja] 勝敗によって色が変わる背景
		Def.Quad{
			InitCommand=function(self)
				(cmd(zoomto,box_size_x,box_size_y;diffuse,RIVAL_DRAW_COLOR;))(self);
				if pn==PLAYER_1 then
					self:fadeleft(0.25);
				else
					self:faderight(0.25);
				end;
				self:diffusealpha(0.6);
			end;
			UpdateRivalCommand = function(self,params)
				if params.PlayerNumber == pn and params.RivalNumber == rn and rival_dp>0 then
					if params.DPPlayer>params.DPRival then
						self:diffuse(RIVAL_WIN_COLOR);
						MESSAGEMAN:Broadcast('AvatarChanged',{id=3+5*p+rn,t=AVATAR_LOSE});
					elseif params.DPPlayer<params.DPRival then
						self:diffuse(RIVAL_LOSE_COLOR);
						MESSAGEMAN:Broadcast('AvatarChanged',{id=3+5*p+rn,t=AVATAR_WIN});
					else
						self:diffuse(RIVAL_DRAW_COLOR);
						MESSAGEMAN:Broadcast('AvatarChanged',{id=3+5*p+rn,t=AVATAR_NORMAL});
					end;
					self:diffusealpha(0.6);
				end;
			end;
		};
		-- [ja] パーセント
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				(cmd(zoom,0.7;diffuse,RIVAL_DRAW_COLOR;strokecolor,Color("Black");y,-10))(self);
				if pn==PLAYER_1 then
					self:x(5);
					self:horizalign(right);
				else
					self:x(-5);
					self:horizalign(left);
				end;
				self:settext((rival_dp>0) and "0.00%" or "NO PLAY");
			end;
			UpdateRivalCommand = function(self,params)
				if params.PlayerNumber == pn and params.RivalNumber == rn and rival_dp>0 then
					self:finishtweening();
					if params.DPPlayer>params.DPRival then
						add_ch = '+';
						self:diffuse(ColorLightTone(RIVAL_WIN_COLOR));
					elseif params.DPPlayer<params.DPRival then
						add_ch = '-';
						self:diffuse(ColorLightTone(RIVAL_LOSE_COLOR));
					else
						add_ch = '';
						self:diffuse(RIVAL_DRAW_COLOR);
					end;
					self:settextf("%s%4.2f%%",add_ch,math.abs(params.DPPlayer - params.DPRival));
					self:zoom(1.0);
					self:linear(0.02);
					self:zoom(0.7);
				end;
			end;
		};
		-- [ja] 名前
		LoadFont('Common Normal')..{
			InitCommand=function(self)
				(cmd(zoom,0.6;diffuse,BoostColor(PlayerColor(pn),1.8);strokecolor,Color("Outline");y,10;skewx,-0.2))(self);
				if rival_name~='' then
					self:visible(true);
					if pn==PLAYER_1 then
						self:x(5);
						self:horizalign(right);
					else
						self:x(-5);
						self:horizalign(left);
					end;
					self:settext(rival_name);
				else
					self:visible(false);
				end;
			end;
		};
		-- [ja] アバター
		LoadActor(THEME:GetPathG('_Avatar','graphics/rival'),3+5*p+rn,rival_avatar)..{
			InitCommand=function(self)
				self:zoom(0.6);
				if pn==PLAYER_1 then
					self:x(45);
					self:horizalign(left);
				else
					self:x(-45);
					self:horizalign(right);
					if rival_mode==1 then
						self:rotationy(180);
					end;
				end;
			end;
		};
	};
else
	-- [ja] 大表示
	local box_size_x = 256;
	local box_size_y =  18;
	t[#t+1]=Def.ActorFrame{
		TargetScoreMessageCommand = function(self,params)
			--[[
				params.PlayerNumber = プレイヤー番号
				params.DPPlayer = プレイヤーの現在のダンスポイント
				params.DPCurrent = 全体のステップ数から見た現在のパーセント
			--]]
			if params.PlayerNumber==pn then
				self:playcommand('UpdateRival',{
					PlayerNumber = pn,
					RivalNumber  = rn,
					DPRival   = round(rival_dp*params.DPCurrent*10000)*0.01,
					DPPlayer  = round(params.DPPlayer*10000)*0.01,
					DPCurrent = params.DPCurrent,
				});
			end;
		end;
		-- [ja] 背景
		Def.Quad{
			InitCommand=cmd(zoomto,box_size_x+2,box_size_y+2;y,-9;diffuse,0,0,0,0.5);
		};
		-- [ja] +-表示背景
		Def.Quad{
			InitCommand=cmd(zoomto,box_size_x/3+2,16;x,box_size_x/3;y,9;diffuse,0,0,0,0.5);
		};
		-- [ja] ライバルのスコア
		Def.Quad{
			InitCommand=cmd(zoomto,0,box_size_y;horizalign,left;x,-box_size_x/2;y,-9;diffuse,1,1,1,0.5;);
			UpdateRivalCommand = function(self,params)
				if params.PlayerNumber == pn and params.RivalNumber == rn then
					self:finishtweening();
					self:zoomx(params.DPRival*box_size_x/100);
				end;
			end;
		};
		-- [ja] プレイヤーのスコア
		Def.Quad{
			InitCommand=cmd(zoomto,0,box_size_y;horizalign,left;x,-box_size_x/2;y,-9;diffuse,PlayerColor(pn);diffusealpha,0.5;);
			UpdateRivalCommand = function(self,params)
				if params.PlayerNumber == pn and params.RivalNumber == rn then
					self:finishtweening();
					self:zoomx(params.DPPlayer*box_size_x/100);
				end;
			end;
		};
		-- [ja] パーセント（+-）
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				(cmd(zoom,0.7;diffuse,RIVAL_DRAW_COLOR;strokecolor,Color("Outline");x,box_size_x/2-42;y,7))(self);
				self:settext((rival_dp>0) and "0.00%" or "NO PLAY");
			end;
			UpdateRivalCommand = function(self,params)
				if params.PlayerNumber == pn and params.RivalNumber == rn and rival_dp>0 then
					self:finishtweening();
					if params.DPPlayer>params.DPRival then
						add_ch = '+';
						self:diffuse(ColorLightTone(RIVAL_WIN_COLOR));
						MESSAGEMAN:Broadcast('AvatarChanged',{id=3+5*p+rn,t=AVATAR_LOSE});
						MESSAGEMAN:Broadcast('AvatarChanged',{id=p,t=AVATAR_WIN});
					elseif params.DPPlayer<params.DPRival then
						add_ch = '-';
						self:diffuse(ColorLightTone(RIVAL_LOSE_COLOR));
						MESSAGEMAN:Broadcast('AvatarChanged',{id=3+5*p+rn,t=AVATAR_WIN});
						MESSAGEMAN:Broadcast('AvatarChanged',{id=p,t=AVATAR_LOSE});
					else
						add_ch = '';
						self:diffuse(RIVAL_DRAW_COLOR);
						MESSAGEMAN:Broadcast('AvatarChanged',{id=3+5*p+rn,t=AVATAR_NORMAL});
						MESSAGEMAN:Broadcast('AvatarChanged',{id=p,t=AVATAR_NORMAL});
					end;
					self:settextf("%s%4.2f%%",add_ch,math.abs(params.DPPlayer - params.DPRival));
					self:zoom(1.0);
					self:linear(0.02);
					self:zoom(0.7);
				end;
			end;
		};
		-- [ja] パーセント
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				(cmd(zoom,0.8;diffuse,RIVAL_DRAW_COLOR;strokecolor,Color("Outline");x,box_size_x/2-42;y,-9))(self);
				self:settext("0.00%");
			end;
			UpdateRivalCommand = function(self,params)
				if params.PlayerNumber == pn and params.RivalNumber == rn then
					self:finishtweening();
					if params.DPPlayer>params.DPRival then
						self:diffuse(ColorLightTone(RIVAL_WIN_COLOR));
					elseif params.DPPlayer<params.DPRival then
						self:diffuse(ColorLightTone(RIVAL_LOSE_COLOR));
					else
						self:diffuse(RIVAL_DRAW_COLOR);
					end;
					self:settextf("%4.2f%%",params.DPPlayer);
					self:zoom(1.0);
					self:linear(0.02);
					self:zoom(0.8);
				end;
			end;
		};
		Def.ActorFrame{
			-- [ja] 名前
			LoadFont('Common Normal')..{
				InitCommand=function(self)
					(cmd(zoom,0.6;diffuse,BoostColor(PlayerColor(pn),1.8);strokecolor,Color("Outline");y,36;skewx,-0.2))(self);	-- y or -45-9
					if rival_name~='' then
						self:visible(true);
						if pn==PLAYER_1 then
							self:x(box_size_x/2-70);
							self:horizalign(right);
						else
							self:x(-box_size_x/2+70);
							self:horizalign(left);
						end;
						self:settext(rival_name);
					else
						self:visible(false);
					end;
				end;
			};
			-- [ja] アバター
			LoadActor(THEME:GetPathG('_Avatar','graphics/rival'),3+5*p+rn,rival_avatar)..{
				InitCommand=function(self)
					if pn==PLAYER_1 then
						self:x(box_size_x/2-32);
					else
						self:x(-box_size_x/2+32);
						if rival_mode==1 then
							self:rotationy(180);
						end;
					end;
					self:y(46);	-- or -40-9
					self:zoom(0.6);
				end;
			};
			OnCommand=cmd(y,IsReverse(pn) and -95 or 0);
			SetScrollNomalMessageCommand=function(self,params)
				if params.PlayerNumber==pn then
					-- [ja] 通常スクロール
					self:stoptweening();
					self:linear(0.2);
					self:y(0);
				end;
			end;
			SetScrollReverseMessageCommand=function(self,params)
				if params.PlayerNumber==pn then
					-- [ja] Reverseスクロール
					self:stoptweening();
					self:linear(0.2);
					self:y(-95);
				end;
			end;
		};
		-- [ja] プレイヤーアバター
		LoadActor(THEME:GetPathG('_Avatar','graphics'),p,GetPlayerAvatar(pn))..{
			InitCommand=function(self)
				if SCREEN_WIDTH/SCREEN_HEIGHT>1.777 then
					if pn==PLAYER_1 then
						self:x(-box_size_x/2-42);
						self:rotationy(180);
					else
						self:x(box_size_x/2+42);
					end;
					self:y(0);
					self:zoom(0.75);
				elseif SCREEN_WIDTH/SCREEN_HEIGHT>=1.6 then
					if pn==PLAYER_1 then
						self:x(-box_size_x/2-36);
						self:rotationy(180);
					else
						self:x(box_size_x/2+36);
					end;
					self:y(0);
					self:zoom(0.66);
				else
					if pn==PLAYER_1 then
						self:x(-box_size_x/2+36);
						self:rotationy(180);
					else
						self:x(box_size_x/2-36);
					end;
					--self:y((not params.target_rev) and 40 or -45);
					self:y(40);
					self:zoom(0.6);
				end;
			end;
			OnCommand=cmd(y,(SCREEN_WIDTH/SCREEN_HEIGHT<1.6 and IsReverse(pn)) and -95 or 0);
			SetScrollNomalMessageCommand=function(self,params)
				if SCREEN_WIDTH/SCREEN_HEIGHT<1.6 and params.PlayerNumber==pn then
					-- [ja] 通常スクロール
					self:stoptweening();
					self:linear(0.2);
					self:y(0);
				end;
			end;
			SetScrollReverseMessageCommand=function(self,params)
				if SCREEN_WIDTH/SCREEN_HEIGHT<1.6 and params.PlayerNumber==pn then
					-- [ja] Reverseスクロール
					self:stoptweening();
					self:linear(0.2);
					self:y(-95);
				end;
			end;
		};
	};
end;

return t;