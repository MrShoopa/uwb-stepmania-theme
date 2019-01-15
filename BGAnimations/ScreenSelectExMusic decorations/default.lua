-- [ja] ルール
--[[
	基本的にキー操作とサウンドはoverlayのほうで設定 
	楽曲情報や必要な変数、画面遷移もすべてoverlayで処理 
	他はあくまで表示内容だけ設定 
--]]

local bgs = GetUserPref_Theme("UserBGScale");
if not bgs then
	bgs = 'Fit';
end;
local haishin=GetUserPref_Theme("UserHaishin");
if not haishin then
	haishin="Off";
end;
local difcolor=GetUserPref_Theme("UserDifficultyColor");
local difname=GetUserPref_Theme("UserDifficultyName");
local meter_type=GetUserPref_Theme("UserMeterType");

local t = LoadFallbackB();
local t2 = Def.ActorFrame{
	OnCommand=function(self)
		self:sleep(0.5);
		self:decelerate(GetwaieiScreenInSec());
	end;
	OffCommand=function(self)
		self:accelerate(GetwaieiScreenOutSec());
	end;
	StartMessageCommand=cmd(playcommand,"Off");
	LoadActor(THEME:GetPathG("ScreenWithMenuElements","header"))..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_TOP);
		end;
	};
	LoadActor(THEME:GetPathG("_wheel/waiei1","under"))..{
		InitCommand=function(self)
			self:visible(TC_GetwaieiMode()~=2);
			self:x(THEME:GetMetric("ScreenSelectMusic","MusicWheelX"));
			self:y(THEME:GetMetric("ScreenSelectMusic","MusicWheelY")-88);
		end;
		OnCommand=function(self)
			self:finishtweening();
			self:diffusealpha(0.0);
			self:zoomx(1.5);
			self:zoomy(0.5);
			self:linear(0.2);
			self:zoomx(1.0);
			self:zoomy(1.0);
			self:diffusealpha(1.0);
			self:linear(0.3);
			self:diffusealpha(0.0);
		end;
		SetSongMessageCommand=function(self,params)
			if params.Move and
				params.Move=="Left" or
				params.Move=="Right" then
				self:stoptweening();
				self:diffusealpha(1.0);
				self:sleep(0.2);
				self:linear(0.3);
				self:diffusealpha(0.0);
			end;
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		OffCommand=cmd(diffusealpha,0);
	};
	LoadActor("waiei"..TC_GetwaieiMode().."_wheel")..{
		InitCommand=function(self)
			self:x(THEME:GetMetric("ScreenSelectMusic","MusicWheelX"));
			self:y(THEME:GetMetric("ScreenSelectMusic","MusicWheelY")-40);
		end;
		OnCommand=function(self)
			self:SetDrawByZPosition(true);
			self:zoomz(1);
			self:fov(90);
			self:addy(400);
			self:addz(-200);
			self:linear(0.2);
			self:addy(-400);
			self:addz(200);
		end;
		OffCommand=THEME:GetMetric("ScreenSelectMusic","MusicWheelOffCommand");
	};
	StandardDecorationFromFileOptional("BannerFrame","BannerFrame")..{
		OnCommand=function(self)
			self:rotationx(90);
			self:linear(0.2);
			self:rotationx(0);
		end;
		OffCommand=function(self)
			self:linear(0.2);
			self:rotationx(90);
		end;
	};
	Def.ActorFrame{
		FOV=90;
		OnCommand=function(self)
			self:x(THEME:GetMetric("ScreenSelectMusic","MusicWheelX")+TC_GetMetric("Wheel","PosX")+TC_GetMetric("Wheel","LightPosX"));
			self:y(THEME:GetMetric("ScreenSelectMusic","MusicWheelY")+TC_GetMetric("Wheel","PosY")+TC_GetMetric("Wheel","LightPosY"));
			self:z(TC_GetMetric("Wheel","PosZ")+TC_GetMetric("Wheel","LightPosZ"));
			self:effectclock("bgm");
			self:diffuseshift();
			self:effectcolor1(color("1,1,1,0.5"));
			self:effectcolor2(Color("White"));
			self:zoomy(0);
			self:sleep(0.3);
			self:linear(0.2);
			self:zoomx(TC_GetMetric("Wheel","ZoomX")*tonumber(TC_GetRatioPrm(TC_GetMetric("Wheel","ZoomRatio"))));
			self:zoomy(TC_GetMetric("Wheel","ZoomY")*tonumber(TC_GetRatioPrm(TC_GetMetric("Wheel","ZoomRatio"))));
			self:zoomz(TC_GetMetric("Wheel","ZoomZ")*tonumber(TC_GetRatioPrm(TC_GetMetric("Wheel","ZoomRatio"))));
			self:rotationx(TC_GetMetric("Wheel","RotateX"));
			self:rotationy(TC_GetMetric("Wheel","RotateY"));
			self:rotationz(TC_GetMetric("Wheel","RotateZ"));
		end;
		OffCommand=function(self)
			self:linear(0.1);
			self:zoomx(0);
		end;
		LoadActor(TC_GetPath("Wheel","highlight"))..{
			OnCommand=function(self)
				self:zoomx(TC_GetMetric("Wheel","CZoomX"));
				self:zoomy(TC_GetMetric("Wheel","CZoomY"));
				self:zoomz(TC_GetMetric("Wheel","CZoomZ"));
				self:rotationx(TC_GetMetric("Wheel","CRotateX"));
				self:rotationy(TC_GetMetric("Wheel","CRotateY"));
				self:rotationz(TC_GetMetric("Wheel","CRotateZ"));
				if TC_GetMetric("Wheel","Flow")=='X' then
					self:x(TC_GetMetric("Wheel","CPosX"));
					self:y(TC_GetMetric("Wheel","CPosY"));
				else
					self:x(TC_GetMetric("Wheel","CPosX"));
					self:y(TC_GetMetric("Wheel","CPosY"));
				end;
			end;
		};
	};
	StandardDecorationFromFileOptional("StageDisplay","StageDisplay");
	StandardDecorationFromFileOptional("BPMDisplay","BPMDisplay")..{
		SetYMessageCommand=function(self,params)
			self:stoptweening();
			self:linear(0.1);
			if params.Split then
				self:y(THEME:GetMetric("ScreenSelectMusic","BPMDisplayY"));
				-- [ja] どういうわけかきちんと移動してくれないことがあるのでその現象になったら強制的に動くように対応 
				while(THEME:GetMetric("ScreenSelectMusic","BPMDisplayY")~=self:GetY()) do
					self:stoptweening();
					self:y(THEME:GetMetric("ScreenSelectMusic","BPMDisplayY"));
				end;
			else
				self:y(THEME:GetMetric("ScreenSelectMusic","BPMDisplayY")+10);
				while(THEME:GetMetric("ScreenSelectMusic","BPMDisplayY")+10~=self:GetY()) do
					self:stoptweening();
					self:y(THEME:GetMetric("ScreenSelectMusic","BPMDisplayY")+10);
				end;
			end;
		end;
		OffCommand=THEME:GetMetric("ScreenSelectMusic","BPMDisplayOffCommand");
	};
	StandardDecorationFromFileOptional("BPMLabel","BPMLabel")..{
		SetYMessageCommand=function(self,params)
			self:stoptweening();
			self:linear(0.1);
			if params.Split then
				self:y(THEME:GetMetric("ScreenSelectMusic","BPMLabelY"));
			else
				self:y(THEME:GetMetric("ScreenSelectMusic","BPMLabelY")+10);
			end;
		end;
		OffCommand=THEME:GetMetric("ScreenSelectMusic","BPMLabelOffCommand");
	};
	StandardDecorationFromFileOptional("SongTime","SongTime")..{
		SetYMessageCommand=function(self,params)
			self:stoptweening();
			self:linear(0.1);
			if params.LorM then
				self:y(THEME:GetMetric("ScreenSelectMusic","SongTimeY"));
			else
				self:y(THEME:GetMetric("ScreenSelectMusic","SongTimeY")+10);
			end;
		end;
		OffCommand=THEME:GetMetric("ScreenSelectMusic","SongTimeOffCommand");
	};
	StandardDecorationFromFileOptional("TimeLabel","TimeLabel")..{
		OffCommand=THEME:GetMetric("ScreenSelectMusic","TimeLabelOffCommand");
	};
};
if TC_GetwaieiMode()==1 then
	t2[#t2+1] = LoadActor(THEME:GetPathG("_ScreenSelectMusic","Pane/waiei1_bg"),difcolor,difname,meter_type)..{
		GoToEXFMessageCommand=cmd(playcommand,"Off");
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y+95);
		end;
	};
end;
t2[#t2+1] = Def.ActorFrame{

	StandardDecorationFromFileOptional("PaneDisplayTextP1","PaneDisplayTextP1")..{
		OffCommand=THEME:GetMetric("ScreenSelectMusic","PaneDisplayTextP1OffCommand");
	};
	StandardDecorationFromFileOptional("PaneDisplayTextP2","PaneDisplayTextP2")..{
		OffCommand=THEME:GetMetric("ScreenSelectMusic","PaneDisplayTextP2OffCommand");
	};

	LoadActor(THEME:GetPathG("_ScreenSelectMusic","Pane/diflist"),PLAYER_1,difcolor,difname,meter_type)..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X-((TC_GetwaieiMode()==2) and 155+(854-SCREEN_WIDTH)*10/214 or 0));
			self:y(SCREEN_HEIGHT-((TC_GetwaieiMode()==2) and 153 or 158));
			self:player(PLAYER_1);
		end;
		OnCommand=cmd(addy,200;bouncebegin,0.15;addy,-200;);
		OffCommand=cmd(bouncebegin,0.15;addx,-300;zoomy,0;);
	};
	LoadActor(THEME:GetPathG("_ScreenSelectMusic","Pane/diflist"),PLAYER_2,difcolor,difname,meter_type)..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X+((TC_GetwaieiMode()==2) and 155-(854-SCREEN_WIDTH)*10/214 or 0));
			self:y(SCREEN_HEIGHT-((TC_GetwaieiMode()==2) and 153 or 158));
			self:player(PLAYER_2);
		end;
		OnCommand=cmd(addy,200;bouncebegin,0.15;addy,-200;);
		OffCommand=cmd(bouncebegin,0.15;addx,300;zoomy,0;);
	};
	-- GrooveRadar
	StandardDecorationFromFileOptional( "GrooveRadarP1", "GrooveRadarP1" )..{
		InitCommand=function(self)
			self:player(PLAYER_1);
		end;
		OffCommand=THEME:GetMetric("ScreenSelectMusic","GrooveRadarP1OffCommand");
	};
	StandardDecorationFromFileOptional( "GrooveRadarP2", "GrooveRadarP2" )..{
		InitCommand=function(self)
			self:player(PLAYER_2);
		end;
		OffCommand=THEME:GetMetric("ScreenSelectMusic","GrooveRadarP2OffCommand");
	};
};

t[#t+1] = t2;
return t;