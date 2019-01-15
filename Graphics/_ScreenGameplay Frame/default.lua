local sname = Var "LoadingScreen";
local lifeWidth=SCREEN_WIDTH/4;
local haishin = GetUserPref_Theme("UserHaishin") or 'Off';
local t = Def.ActorFrame{};

t[#t+1]= Def.ActorFrame{
	-- [ja] ゲームフレーム
	LoadActor("waiei"..TC_GetwaieiMode().."_Frame",lifeWidth,haishin);
	-- [ja] ライフメーター
	LoadActor(THEME:GetPathG("_ScreenGameplay","Life"),lifeWidth+((TC_GetwaieiMode()==2) and 50 or 0),haishin,PLAYER_1)..{
		InitCommand=function(self)
			self:visible(GAMESTATE:IsPlayerEnabled(PLAYER_1));
			self:x(THEME:GetMetric("ScreenGameplay","LifeMeterBarP1X"));
			self:y(THEME:GetMetric("ScreenGameplay","LifeMeterBarP1Y"));
		end;
	};
	LoadActor(THEME:GetPathG("_ScreenGameplay","Life"),lifeWidth+((TC_GetwaieiMode()==2) and 50 or 0),haishin,PLAYER_2)..{
		InitCommand=function(self)
			self:visible(GAMESTATE:IsPlayerEnabled(PLAYER_2)
				or sname=="ScreenHowToPlay");
			self:x(THEME:GetMetric("ScreenGameplay","LifeMeterBarP2X"));
			self:y(THEME:GetMetric("ScreenGameplay","LifeMeterBarP2Y"));
		end;
	};
};
if sname~="ScreenHowToPlay" then
	t[#t+1]= Def.ActorFrame{
		-- [ja] スコアフレーム
		StandardDecorationFromFileOptional("ScoreFrameP1","ScoreFrameP1")..{
			OffCommand=cmd(sleep,0.5;linear,0.2;diffusealpha,0);
		};
		StandardDecorationFromFileOptional("ScoreFrameP2","ScoreFrameP2")..{
			OffCommand=cmd(sleep,0.5;linear,0.2;diffusealpha,0);
		};
	};
end;

-- [ja] ステージ表示
t[#t+1] = StandardDecorationFromFileOptional("StageDisplay","StageDisplay");

t[#t+1]= Def.Quad{
	InitCommand=cmd(diffuse,0,0,0,1;zoomto,SCREEN_WIDTH,20;vertalign,bottom;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM);
	OnCommand=cmd(diffusealpha,0;addy,20;linear,0.25;addy,-20;diffusealpha,1;diffusetopedge,0,0,0,0.5);
};

return t;