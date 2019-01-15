local sname = Var "LoadingScreen";
local lifeWidth=SCREEN_WIDTH/4;
local haishin="Off";
local t = Def.ActorFrame{};
if TC_GetwaieiMode()==2 then
	t[#t+1]= Def.ActorFrame{
		LoadActor("waiei2_Frame",lifeWidth,haishin);
		LoadActor(THEME:GetPathG("_ScreenGameplay","Life/waiei2"),lifeWidth+50,haishin,PLAYER_1)..{
			InitCommand=function(self)
				self:visible(GAMESTATE:IsPlayerEnabled(PLAYER_1));
				self:x(THEME:GetMetric("ScreenGameplay","LifeMeterBarP1X"));
				self:y(THEME:GetMetric("ScreenGameplay","LifeMeterBarP1Y"));
			end;
		};
		LoadActor(THEME:GetPathG("_ScreenGameplay","Life/waiei2"),lifeWidth+50,haishin,PLAYER_2)..{
			InitCommand=function(self)
				self:visible(GAMESTATE:IsPlayerEnabled(PLAYER_2)
					or sname=="ScreenHowToPlay");
				self:x(THEME:GetMetric("ScreenGameplay","LifeMeterBarP2X"));
				self:y(THEME:GetMetric("ScreenGameplay","LifeMeterBarP2Y"));
			end;
		};
	};
else
	t[#t+1]= Def.ActorFrame{
		LoadActor("waiei1_Frame",lifeWidth,haishin);
		LoadActor(THEME:GetPathG("_ScreenGameplay","Life/waiei1"),lifeWidth,haishin,PLAYER_1)..{
			InitCommand=function(self)
				self:visible(GAMESTATE:IsPlayerEnabled(PLAYER_1));
				self:x(THEME:GetMetric("ScreenGameplay","LifeMeterBarP1X"));
				self:y(THEME:GetMetric("ScreenGameplay","LifeMeterBarP1Y"));
			end;
		};
		LoadActor(THEME:GetPathG("_ScreenGameplay","Life/waiei1"),lifeWidth,haishin,PLAYER_2)..{
			InitCommand=function(self)
				self:visible(GAMESTATE:IsPlayerEnabled(PLAYER_2)
					or sname=="ScreenHowToPlay");
				self:x(THEME:GetMetric("ScreenGameplay","LifeMeterBarP2X"));
				self:y(THEME:GetMetric("ScreenGameplay","LifeMeterBarP2Y"));
			end;
		};
	};
end;
	t[#t+1]= Def.Quad{
		InitCommand=cmd(diffuse,0,0,0,1;zoomto,SCREEN_WIDTH,20;vertalign,bottom;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM);
		OnCommand=cmd(diffusealpha,0;addy,20;linear,0.25;addy,-20;diffusealpha,1;diffusetopedge,0,0,0,0.5);
	};
return t;