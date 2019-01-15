local haishin = 'Off';
local stage = 'Off';
if GetUserPref_Theme("UserHaishin") ~= nil then
	haishin = GetUserPref_Theme("UserHaishin");
	if GetUserPref_Theme("UserStage") ~= nil then
		stage = GetUserPref_Theme("UserStage");
	end;
end;
local tcol=GetUserPref_Theme("UserColorPath");

local t = Def.ActorFrame{};

-- [ja] ダンサー
if haishin=='Off' and stage=='On' then
	t[#t+1]=LoadActor(THEME:GetPathG("_ScreenGameplay","Dancer"));
end;

local basezoom = 0.42;  -- 基準となる拡大率

if _SONG() and haishin == "On" then
	t[#t+1]=Def.ActorFrame{
		FOV=60;
		InitCommand=cmd(Center;);
		OnCommand=function(self)
			self:zoom(1/basezoom);
			self:Center();
			self:linear(0.3);
			self:zoom(1);
			if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
				self:x(SCREEN_WIDTH*basezoom/2-20*basezoom+SCREEN_CENTER_X);
				self:rotationy(45);
			else
				self:x(-SCREEN_WIDTH*basezoom/2+20*basezoom+SCREEN_CENTER_X);
				self:rotationy(-45);
			end;
		end;
		LoadActor(THEME:GetPathG("_Haishin","Mask"))..{
			BeginCommand=function(self)
				self:visible(true);
				local zx=basezoom*(0.75/(SCREEN_HEIGHT/SCREEN_WIDTH));
				self:zoomx(zx);
				self:zoomy(basezoom);
			end;
		};
		LoadActor(THEME:GetPathG("_Gameplay","BGA"),_SONG())..{
			BeginCommand=function(self)
				self:zoom(basezoom);
			end;
		};
		LoadActor(THEME:GetPathG("_Haishin","Mask"))..{
			BeginCommand=function(self)
				self:visible(true);
				local zx=basezoom*(0.75/(SCREEN_HEIGHT/SCREEN_WIDTH));
				self:zoomx(zx);
				self:zoomy(basezoom);
				self:MaskSource();
			end;
		};
	};
	t[#t+1]=Def.ActorFrame{
		FOV=60;
		InitCommand=cmd(Center;);
		Def.Quad{
			InitCommand=cmd(diffuse,Color("Black");zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;MaskDest;)
		};
	};
	t[#t+1]=Def.ActorFrame{
		FOV=60;
		InitCommand=cmd(Center;);
		OnCommand=function(self)
			self:zoom(1/basezoom);
			self:Center();
			self:linear(0.3);
			self:zoom(1);
			if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
				self:x(SCREEN_WIDTH*basezoom/2-20*basezoom+SCREEN_CENTER_X);
				self:rotationy(45);
			else
				self:x(-SCREEN_WIDTH*basezoom/2+20*basezoom+SCREEN_CENTER_X);
				self:rotationy(-45);
			end;
		end;
		LoadActor(THEME:GetPathG(tcol.."_Haishin","Display"))..{
			BeginCommand=function(self)
				self:visible(true);
				local zx=basezoom*(0.75/(SCREEN_HEIGHT/SCREEN_WIDTH));
				self:zoomx(zx);
				self:zoomy(basezoom);
				self:clearzbuffer(true);
			end;
		};
	};
	t[#t+1]=Def.ActorFrame{
		FOV=60;
		InitCommand=cmd(Center;);
		Def.Sprite{
			InitCommand=function(self)
				local bn=SONGMAN:GetSongGroupBannerPath(_SONG():GetGroupName());
				if bn then
					self:Load(bn);
				end;
				self:scaletofit( 0,0,192,60 );
				self:y(SCREEN_HEIGHT*4/5-20-SCREEN_CENTER_Y);
				if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
					self:horizalign(left);
					self:x(SCREEN_WIDTH*3/5-70-SCREEN_CENTER_X);
				else
					self:horizalign(right);
					self:x(SCREEN_WIDTH*2/5+70-SCREEN_CENTER_X);
				end;
			end;
			OnCommand=function(self)
				self:diffusealpha(0);
				self:addy(10);
				self:linear(0.3);
				self:addy(-10);
				self:diffusealpha(1);
			end;
		};
	};
end;
t[#t+1]=Def.ActorFrame{
	LoadActor("ScreenFilter");
};
local cs_rival = (GetUserPref_Theme("UserCSRival") == 'On') and true or false;
if cs_rival then
    if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
        local p1name = PROFILEMAN:GetPlayerName(PLAYER_1);
        if p1name and p1name~='' then
            t[#t+1]=LoadActor("csla_rival",PLAYER_1);
        end;
    end;
    if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
        local p2name = PROFILEMAN:GetPlayerName(PLAYER_2);
        if p2name and p2name~='' then
            t[#t+1]=LoadActor("csla_rival",PLAYER_2);
        end;
    end;
end;

return t;
