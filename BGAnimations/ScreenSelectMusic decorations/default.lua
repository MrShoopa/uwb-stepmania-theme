local t = LoadFallbackB();
local t2= Def.ActorFrame{};
if not IsDrill() then

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

t[#t+1] = StandardDecorationFromFileOptional("AlternateHelpDisplay","AlternateHelpDisplay");

--[[
t[#t+1]=LoadActor(THEME:GetPathG("_Filter","blur"),
THEME:GetPathB("ScreenWithMenuElements","background"),
10,true,"")..{
	OnCommand=cmd(finishtweening;diffusealpha,0;linear,0.5;diffusealpha,0.7);
	OffCommand=cmd(finishtweening);
};
--]]
t2[#t2+1] = Def.ActorFrame{
	GoToEXFMessageCommand=cmd(playcommand,"Off");
	CodeCommand=function(self,params)
		if params.Name=="Test" then
		end;
	end;
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
			self:y(THEME:GetMetric("ScreenSelectMusic","MusicWheelY")-48);
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
		SetCommand=function(self)
			self:stoptweening();
			self:diffusealpha(1.0);
			self:sleep(0.2);
			self:linear(0.3);
			self:diffusealpha(0.0);
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
	};
	--[[
	Def.ActorFrame{
		FOV=90;
		LoadActor("wheel")..{
			CodeMessageCommand=function(self,params)
				if params.Name=="Left" then
					MESSAGEMAN:Broadcast("SetSong",{Move="Left"});
				elseif params.Name=="Right" then
					MESSAGEMAN:Broadcast("SetSong",{Move="Right"});
				end;
			end;
		};
		InitCommand=function(self)
			self:x(THEME:GetMetric("ScreenSelectMusic","MusicWheelX"));
			self:y(THEME:GetMetric("ScreenSelectMusic","MusicWheelY")-40);
			self:zoom(tonumber(TC_GetRatioPrm(TC_GetMetric("Wheel","ZoomRatio"))));
			self:addx(tonumber(TC_GetRatioPrm(TC_GetMetric("Wheel","PositionXRatio"))));
			self:addy(tonumber(TC_GetRatioPrm(TC_GetMetric("Wheel","PositionYRatio"))));
			self:addz(tonumber(TC_GetRatioPrm(TC_GetMetric("Wheel","PositionZRatio"))));
		end;
	};
	--]]
	Def.ActorProxy{
		OnCommand=function(self)
			local wheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
			self:SetTarget(wheel);
			local prmZoomX=TC_GetMetric("Wheel","ZoomX")*tonumber(TC_GetRatioPrm(TC_GetMetric("Wheel","ZoomRatio")));
			local prmZoomY=TC_GetMetric("Wheel","ZoomY")*tonumber(TC_GetRatioPrm(TC_GetMetric("Wheel","ZoomRatio")));
			local prmZoomZ=TC_GetMetric("Wheel","ZoomZ")*tonumber(TC_GetRatioPrm(TC_GetMetric("Wheel","ZoomRatio")));
			self:halign(SCREEN_WIDTH/2);
			self:valign(SCREEN_HEIGHT/2);
			self:zoomx(prmZoomX);
			self:zoomy(prmZoomY);
			self:zoomz(prmZoomZ);
			self:rotationx(TC_GetMetric("Wheel","RotateX"));
			self:rotationy(TC_GetMetric("Wheel","RotateY"));
			self:rotationz(TC_GetMetric("Wheel","RotateZ"));
			self:x(GAMESTATE:IsCourseMode() and -105 or 0);
			-- [ja] ProxyにZoomを適応させるとズレるので修正 
			self:addx(SCREEN_CENTER_X+TC_GetMetric("Wheel","PosX"));
			self:addy(SCREEN_CENTER_Y+TC_GetMetric("Wheel","PosY"));
			--(cmd(rotationy,0;linear,3;rotationy,3600))(self);
			self:queuecommand("On2");
		end;
		On2Command=TC_GetCommand("Wheel","OnCommand");
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
				if TC_GetwaieiMode()==2 then
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
			end;
		};
	};
--	StandardDecorationFromFileOptional("DifficultyList","DifficultyList");
--	StandardDecorationFromFileOptional("CourseContentsList","CourseContentsList");
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
	};
	StandardDecorationFromFileOptional("SegmentDisplay","SegmentDisplay");

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
	};
	StandardDecorationFromFileOptional("TimeLabel","TimeLabel");

	StandardDecorationFromFileOptional("SortOrderFrame","SortOrderFrame") .. {};
	StandardDecorationFromFileOptional("SortOrder","SortOrderText") .. {
		BeginCommand=cmd(playcommand,"Set");
		SortOrderChangedMessageCommand=cmd(playcommand,"Set";);
		SetCommand=function(self)
			local s = SortOrderToLocalizedString( GAMESTATE:GetSortOrder() );
			self:settext( s );
			self:playcommand("Sort");
		end;
	};
};

if not GAMESTATE:IsCourseMode() then
-- not CourseMode
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
	GoToEXFMessageCommand=cmd(playcommand,"Off");
	StandardDecorationFromFileOptional("StageDisplay","StageDisplay");
	StandardDecorationFromFileOptional("CustomCDTitle","CDTitle");

	StandardDecorationFromFileOptional("PaneDisplayTextP1","PaneDisplayTextP1");
	StandardDecorationFromFileOptional("PaneDisplayTextP2","PaneDisplayTextP2");

	LoadActor(THEME:GetPathG("_ScreenSelectMusic","Pane/diflist"),PLAYER_1,difcolor,difname,meter_type)..{
		InitCommand=function(self)
			self:horizalign((TC_GetwaieiMode()==2) and right or center)
			self:x(SCREEN_CENTER_X-((TC_GetwaieiMode()==2) and (157-15*(854-SCREEN_WIDTH)/214) or 0));
			self:y(SCREEN_HEIGHT-((TC_GetwaieiMode()==2) and 153 or 158));
			self:player(PLAYER_1);
		end;
		OnCommand=cmd(addy,200;bouncebegin,0.15;addy,-200;);
		OffCommand=cmd(bouncebegin,0.15;addx,-300;zoomy,0;);
	};
	LoadActor(THEME:GetPathG("_ScreenSelectMusic","Pane/diflist"),PLAYER_2,difcolor,difname,meter_type)..{
		InitCommand=function(self)
			self:horizalign((TC_GetwaieiMode()==2) and left or center)
			self:x(SCREEN_CENTER_X+((TC_GetwaieiMode()==2) and (157-15*(854-SCREEN_WIDTH)/214) or 0));
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
	};
	StandardDecorationFromFileOptional( "GrooveRadarP2", "GrooveRadarP2" )..{
		InitCommand=function(self)
			self:player(PLAYER_2);
		end;
	};
	
	-- [ja] 隠し
	LoadActor("viewscore")..{
		InitCommand=cmd(y,-30);
	};

};
t[#t+1]=Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(Center;visible,false;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;blend,"BlendMode_Add";diffuse,Color("Blue"););
		GoToEXFMessageCommand = function(self)
			self:visible(true);
			(cmd(diffusealpha,0;
				linear,0.25;diffusealpha,1;linear,0.75;diffusealpha,0;))(self);
		end;
	};
	LoadActor(THEME:GetPathG("_Ready","Background"))..{
		InitCommand=cmd(Center;visible,false);
		GoToEXFMessageCommand = function(self)
			self:visible(true);
			(cmd(diffusealpha,0;zoom,3;Center;
				linear,0.25;diffusealpha,1;zoomy,1.5;zoomtowidth,SCREEN_WIDTH;
				sleep,1.0;linear,0.25;zoomy,0;sleep,0.25;diffusealpha,0;))(self);
		end;
	};
	LoadActor(THEME:GetPathG("ScreenStageInformation","Goodluck"))..{
		InitCommand=cmd(Center;visible,false;blend,"BlendMode_Add");
		GoToEXFMessageCommand = function(self)
			self:visible(true);
			(cmd(zoom,2;diffusealpha,0;
				linear,0.25;zoom,1;diffusealpha,1;sleep,1.0;
				linear,0.25;diffusealpha,0))(self);
		end;
	};
	LoadActor(THEME:GetPathG("ScreenStageInformation","Goodluck"))..{
		InitCommand=cmd(Center;visible,false;blend,"BlendMode_Add");
		GoToEXFMessageCommand = function(self)
			self:visible(true);
			(cmd(zoom,1;diffusealpha,0;
				sleep,0.25;zoom,1;diffusealpha,1;
				linear,0.25;zoom,1.3;diffusealpha,0))(self);
		end;
	};
};
else
-- CourseMode
	t[#t+1]=StandardDecorationFromFileOptional("NumCourseSongs","NumCourseSongs")..{
		InitCommand=cmd(horizalign,right);
		SetCommand=function(self)
			local curSelection= nil;
			local sAppend = "";
			if GAMESTATE:IsCourseMode() then
				curSelection = GAMESTATE:GetCurrentCourse();
				if curSelection then
					sAppend = (curSelection:GetEstimatedNumStages() == 1) and "Stage" or "Stages";
					self:visible(true);
					self:settext( curSelection:GetEstimatedNumStages() .. " " .. sAppend);
				else
					self:visible(false);
				end;
			else
				self:visible(false);
			end;
		end;
		CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
	};
	t[#t+1]=LoadActor("course");
end;

t[#t+1]= t2;

end;	-- if not getenv("Drill") then
return t