local playMode = GAMESTATE:GetPlayMode()
if playMode ~= 'PlayMode_Regular' and playMode ~= 'PlayMode_Rave' and playMode ~= 'PlayMode_Battle' then
	curStage = playMode;
end;
local sStage = GAMESTATE:GetCurrentStage();
local tRemap = {
	Stage_1st		= 1,
	Stage_2nd		= 2,
	Stage_3rd		= 3,
	Stage_4th		= 4,
	Stage_5th		= 5,
	Stage_6th		= 6,
};

-- [ja] 歌詞の隠し機能を初期化（この画面で↑↑←→↓と入力） 
Setwaiei("LyricEgg",false);

if tRemap[sStage] == PREFSMAN:GetPreference("SongsPerPlay") then
	sStage = "Stage_Final";
elseif GAMESTATE:IsCourseMode() then
	local course=GAMESTATE:GetCurrentCourse();
	if course:IsNonstop() then
		sStage = "Stage_Nonstop";
	elseif course:IsOni() then
		sStage = "Stage_Oni";
	elseif course:IsEndless() then
		sStage = "Stage_Endless";
	else
		sStage = sStage;
	end;
else
	sStage = sStage;
end;

local tcol=GetUserPref_Theme("UserColorPath");
local haishin=GetUserPref_Theme("UserHaishin");
local basezoom=0.42;
local t = Def.ActorFrame {FOV=60;};
if GAMESTATE:IsCourseMode() then
	t[#t+1] = LoadActor("CourseDisplay",tcol,haishin,basezoom);
else
	t[#t+1] = Def.Actor {
		InitCommand=cmd(Center);
	--	BeginCommand=cmd(LoadFromCurrentSongBackground);
		OnCommand=function(self)
		--	self:diffusealpha(PREFSMAN:GetPreference("BGBrightness"));
			if haishin=="On" then
				local bgs = GetUserPref_Theme("UserBGScale");
				if not bgs then
					bgs = 'Fit';
				end;
				local bgr;
				if GetSMParameter(_SONG(),"bgaspectratio")=="" then
					bgr=1.333333;
				else
					bgr=tonumber(GetSMParameter(_SONG(),"bgaspectratio"));
				end;
				self:scaletofit( 0,0,SCREEN_WIDTH,SCREEN_HEIGHT );
				if bgs == 'Cover' or
					math.abs(PREFSMAN:GetPreference("DisplayAspectRatio")-bgr)<= 0.01 then
					self:scaletocover( 0,0,SCREEN_WIDTH*basezoom,SCREEN_HEIGHT*basezoom );
				else
					self:scaletofit( -SCREEN_CENTER_X*basezoom,-SCREEN_CENTER_Y*basezoom,SCREEN_CENTER_X*basezoom,SCREEN_CENTER_Y*basezoom );
				end;
				self:y(SCREEN_CENTER_Y);
				if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
					self:x(SCREEN_CENTER_X+SCREEN_WIDTH*basezoom/2-20*basezoom);
					self:rotationy(45);
				else
					self:x(SCREEN_CENTER_X-SCREEN_WIDTH*basezoom/2+20*basezoom);
					self:rotationy(-45);
				end;
			else
				self:scale_or_crop_background();
			end;
		end;
	};
	t[#t+1] = LoadActor(THEME:GetPathG("_Haishin","Mask")).. {
		InitCommand=cmd(Center;visible,(haishin=="On") and true or false;);
		OnCommand=function(self)
			local zx=basezoom*(0.75/(SCREEN_HEIGHT/SCREEN_WIDTH));
			self:zoomto(SCREEN_WIDTH*1.05,SCREEN_HEIGHT*1.09);
			if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
				self:x(SCREEN_CENTER_X+SCREEN_WIDTH*basezoom/2-20*basezoom);
				self:rotationy(45);
			else
				self:x(SCREEN_CENTER_X-SCREEN_WIDTH*basezoom/2+20*basezoom);
				self:rotationy(-45);
			end;
			self:zoomx(zx);
			self:zoomy(basezoom);
			self:MaskSource();
		end;
	};
	t[#t+1] = Def.Quad{
		InitCommand=cmd(Center;visible,(haishin=="On") and true or false;diffuse,Color("Black");zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;MaskDest;)
	};
	t[#t+1] = LoadActor(THEME:GetPathG(tcol.."_Haishin","Display")).. {
		InitCommand=cmd(Center;visible,(haishin=="On") and true or false;);
		OnCommand=function(self)
			local zx=basezoom*(0.75/(SCREEN_HEIGHT/SCREEN_WIDTH));
			self:diffusealpha(0);
			self:diffusealpha(1);
			if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
				self:x(SCREEN_CENTER_X+SCREEN_WIDTH*basezoom/2-20*basezoom);
				self:rotationy(45);
			else
				self:x(SCREEN_CENTER_X-SCREEN_WIDTH*basezoom/2+20*basezoom);
				self:rotationy(-45);
			end;
			self:zoomx(zx);
			self:zoomy(basezoom);
		end;
	};
end;

t[#t+1]=Def.ActorFrame{
	OnCommand=function(self)
		self:Center();
		self:diffusealpha(0);
		self:linear(0.5);
		self:diffusealpha(1);
	end;
	Def.Quad{
		BeginCommand=function(self)
			self:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT);
			self:diffuse(0,0,0,1);
		end;
	};
	Def.Sprite{
		BeginCommand=function(self)
			self:LoadFromCurrentSongBackground();
			self:scaletofit(-SCREEN_CENTER_X,-SCREEN_CENTER_Y,SCREEN_CENTER_X,SCREEN_CENTER_Y);
			self:diffusealpha(PREFSMAN:GetPreference("BGBrightness"));
		end;
	};
};


t[#t+1] = LoadActor("songinfo");

local ano_stage={
	Stage_1st="1",
	Stage_2nd="2",
	Stage_3rd="3",
	Stage_4th="4",
	Stage_5th="5",
	Stage_6th="6",
	Stage_Final="final",
	Stage_Extra1="extra1",
	Stage_Extra2="extra2",
	Stage_Nonstop="1",
	Stage_Oni="oni",
	Stage_Endless="endless",
	Stage_Event="event",
};

if not IsDrill() then
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-15);
		OnCommand=function(self)
			SOUND:PlayAnnouncer("stage " .. ano_stage[sStage]);
		end;
		
		LoadActor( THEME:GetPathG("ScreenStageInformation", "Stage " .. ToEnumShortString(sStage) ) ) .. {
			OnCommand=function(self)
				if TC_GetwaieiMode()==2 then
					(cmd(diffusealpha,0;linear,0.2;diffusealpha,1;diffusealpha,1;sleep,1.3;linear,0.2;diffusealpha,0))(self);
				else
					(cmd(zoom,0.8;diffusealpha,0;addx,-60;linear,0.25;diffusealpha,1;addx,60;sleep,1.5;linear,0.25;addx,60;diffusealpha,0))(self);
				end;
			end;
		};
		LoadActor( THEME:GetPathG("ScreenStageInformation", "Stage " .. ToEnumShortString(sStage) ) ) .. {
			OnCommand=function(self)
				if TC_GetwaieiMode()==2 then
					(cmd(zoom,1.01;blend,"BlendMode_Add";diffusealpha,0;sleep,0.6;diffusealpha,1;linear,1.0;diffusealpha,0;))(self);
				else
					(cmd(visible,false))(self);
				end;
			end;
		};
	};
else
	local stage_cnt={"1st","2nd","3rd","4th","5th","6th","extra1","final"};
	local ano_stage_drill={"1","2","3","4","5","6","7"};
	local stcnt=1;
	if GetDrillStage()>=GetDrillMaxStage() then
		stcnt=8;
	else
		stcnt=math.min(GetDrillStage(),7)
	end;
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-15);
		OnCommand=function(self)
			if math.min(GetDrillStage(),7)<=#ano_stage_drill then
				SOUND:PlayAnnouncer("stage " .. ano_stage_drill[math.min(GetDrillStage(),7)]);
			end;
		end;
		
		LoadActor( THEME:GetPathG("ScreenStageInformation", "Stage " .. stage_cnt[stcnt] ) ) .. {
			OnCommand=function(self)
				if TC_GetwaieiMode()==2 then
					(cmd(diffusealpha,0;linear,0.2;diffusealpha,1;diffusealpha,1;sleep,1.3;linear,0.2;diffusealpha,0))(self);
				else
					(cmd(zoom,0.8;diffusealpha,0;addx,-60;linear,0.25;diffusealpha,1;addx,60;sleep,1.5;linear,0.25;addx,60;diffusealpha,0))(self);
				end;
			end;
		};
		LoadActor( THEME:GetPathG("ScreenStageInformation", "Stage " .. stage_cnt[stcnt] ) ) .. {
			OnCommand=function(self)
				if TC_GetwaieiMode()==2 then
					(cmd(zoom,1.01;blend,"BlendMode_Add";diffusealpha,0;sleep,0.6;diffusealpha,1;linear,1.0;diffusealpha,0;))(self);
				else
					(cmd(visible,false))(self);
				end;
			end;
		};
	};
end;
t[#t+1] = Def.ActorFrame {
	Def.Actor{
		InitCommand=function(self)
			EnableUltimate(true);
			SetUltimateLife(false);
			EXF_ScreenStageInformation_Init();
		end;
		CodeCommand=function(self,params)
			if not IsDrill() and not IsEXFolder()
				and not GAMESTATE:IsExtraStage() and not GAMESTATE:IsExtraStage2() then
				if params.Name=="UltimateLife" and not IsUltimateLife() then
					SetUltimateLife(true);
				end;
			end;
		end;
	};
};

return t