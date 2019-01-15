local difn=GetUserPref_Theme("UserDifficultyName");
local difc=GetUserPref_Theme("UserDifficultyColor");
local meter_type=GetUserPref_Theme("UserMeterType");

local WHEEL_CENTER_X=SCREEN_CENTER_X-80;
local WHEEL_CENTER_Y=SCREEN_CENTER_Y+60;
local BANNER_CENTER_X=WHEEL_CENTER_X;
local BANNER_CENTER_Y=WHEEL_CENTER_Y-190;
local STATS_CENTER_X=WHEEL_CENTER_X-120;
local STATS_CENTER_Y=WHEEL_CENTER_Y+110;
local SCORE_CENTER_X=WHEEL_CENTER_X+100;
local SCORE_CENTER_Y=STATS_CENTER_Y;
local SONG_CENTER_X=math.max(SCREEN_CENTER_X+200,SCREEN_RIGHT-180);
local SONG_CENTER_Y=SCREEN_CENTER_Y;

local t=Def.ActorFrame{};
local t2=Def.ActorFrame{};

if CntLVInfo()>0 then
	t2[#t2+1]=Def.ActorFrame{
		OnCommand=cmd(playcommand,"Set");
-- Banner / Wheel 
		Def.Banner{
			SetMessageCommand=function(self)
				self:Load(GetLVInfo(GetSelDrillLevel().."-Banner"));
				self:scaletofit(-150,-48,150,48);
				self:x(BANNER_CENTER_X);
				self:y(BANNER_CENTER_Y);
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=cmd(maxwidth,300;);
			SetMessageCommand=function(self)
				self:diffuse(Str2Color(GetLVInfo(GetSelDrillLevel().."-Color")));
				local c1=Str2Color(GetLVInfo(GetSelDrillLevel().."-Color"))[1];
				local c2=Str2Color(GetLVInfo(GetSelDrillLevel().."-Color"))[2];
				if tonumber(c2)<0.8 then
					self:strokecolor(Color("White"));
				else
					self:strokecolor(Color("Outline"));
				end;
				self:settext(GetLVInfo(GetSelDrillLevel().."-Name"));
				self:x(WHEEL_CENTER_X);
				self:y(WHEEL_CENTER_Y-118);
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=cmd(zoom,0.65;maxwidth,300/0.65;
				diffuse,waieiColor("Text");strokecolor,Color("White");
				x,WHEEL_CENTER_X;y,WHEEL_CENTER_Y-96);
			SetMessageCommand=function(self)
				self:settext(""..GetSelDrillLevel().."/"..CntLVInfo());
			end;
		};
		LoadActor("wheel")..{
			InitCommand=function(self)
				self:x(WHEEL_CENTER_X);
				self:y(WHEEL_CENTER_Y);
			end;
		};
		LoadActor(THEME:GetPathG("EditMenu","Left"))..{
			InitCommand=function(self)
				self:x(WHEEL_CENTER_X-110);
				self:y(WHEEL_CENTER_Y-60);
			end;
		};
		LoadActor(THEME:GetPathG("EditMenu","Right"))..{
			InitCommand=function(self)
				self:x(WHEEL_CENTER_X+110);
				self:y(WHEEL_CENTER_Y+60);
			end;
		};
-- Stats 
		Def.Quad{
			InitCommand=function(self)
				self:x(STATS_CENTER_X);
				self:y(STATS_CENTER_Y);
				self:zoomto(174,48);
				self:diffuse(Color("White"));
				self:diffusealpha(0.8);
			end;
		};
		LoadActor(THEME:GetPathG("_Drills/small drill","result"))..{
			InitCommand=function(self)
				self:x(STATS_CENTER_X);
				self:y(STATS_CENTER_Y);
				self:animate(false);
			end;
			SetMessageCommand=function(self)
				if GetLVScore(""..GetSelDrillLevel().."-DP") then
					if GetLVScore(""..GetSelDrillLevel().."-Clear") then
						self:setstate(0);
					elseif GetLVScore(""..GetSelDrillLevel().."-DP")>0 then
						self:setstate(1);
					else
						self:setstate(2);
					end;
				else
					self:setstate(2);
				end;
			end;
		};
-- Score 
		Def.Quad{
			InitCommand=function(self)
				self:x(SCORE_CENTER_X);
				self:y(SCORE_CENTER_Y);
				self:zoomto(174,48);
				self:diffuse(Color("White"));
				self:diffusealpha(0.8);
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(left);
				self:diffuse(waieiColor("Text"));
				self:strokecolor(Color("White"));
				self:maxwidth(150/0.75);
				self:x(SCORE_CENTER_X-75);
				self:y(SCORE_CENTER_Y-10);
				self:zoom(0.75);
			end;
			SetMessageCommand=function(self)
				self:settext("Score : "..string.format("%1.2f",GetLVScore(""..GetSelDrillLevel().."-DP")*100).."%");
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(left);
				self:diffuse(waieiColor("Text"));
				self:strokecolor(Color("White"));
				self:maxwidth(150/0.75);
				self:x(SCORE_CENTER_X-75);
				self:y(SCORE_CENTER_Y+10);
				self:zoom(0.75);
			end;
			SetMessageCommand=function(self)
				self:settext("ClearRate : "..GetLVScore(""..GetSelDrillLevel().."-ClearCnt")
					.."/"..GetLVScore(""..GetSelDrillLevel().."-PlayCnt"));
			end;
		};
-- SongList-BG 
		Def.Quad{
			InitCommand=function(self)
				self:zoomto(220,360);
				self:x(SONG_CENTER_X);
				self:y(SONG_CENTER_Y);
				self:diffuse(Color("White"));
				self:diffusealpha(0.8);
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(right);
				self:diffuse(waieiColor("Red"));
				self:strokecolor(Color("White"));
				self:x(SONG_CENTER_X+100);
				self:y(SONG_CENTER_Y+190);
				self:zoom(0.75);
			end;
			SetMessageCommand=function(self)
				local m=#GetLVInfo(GetSelDrillLevel().."-Song");
				if m==6 then
					self:settext("&MENUDOWN; And more (1 song)");
				elseif m>6 then
					self:settext("&MENUDOWN; And more ("..(m-5).." songs)");
				else
					self:settext("");
				end;
			end;
		};
		LoadActor("songs",difn,difc,meter_type)..{
			InitCommand=function(self)
				self:x(SONG_CENTER_X);
				self:y(SONG_CENTER_Y);
			end;
		};
	};
end;

t2.OffMessageCommand=function(self)
	self:accelerate(GetwaieiScreenOutSec());
	self:x(-SCREEN_CENTER_X);
	self:y(SCREEN_CENTER_Y);
	self:zoomx(2);
	self:zoomy(0);
end;
t[#t+1]=t2;

t[#t+1]=Def.ActorFrame{
	LoadActor(THEME:GetPathG("ScreenWithMenuElements","header"))..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_TOP);
		end;
	};
	LoadActor(THEME:GetPathG("ScreenWithMenuElements","footer"))..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_BOTTOM);
		end;
	};
	LoadActor(THEME:GetPathG("ScreenWithMenuElements","help"))..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_BOTTOM-16);
			(cmd(SetSecsBetweenSwitches,4;zoom,0.675;maxwidth,(SCREEN_WIDTH-300)/0.675;shadowlength,1;strokecolor,Color("Black");draworder,105;zoomy,0;zoom,1*0.675;linear,0.175))(self);
		end;
	};
};
return t;