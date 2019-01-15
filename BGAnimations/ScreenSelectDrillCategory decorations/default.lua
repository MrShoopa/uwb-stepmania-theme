local jud=GetUserPref_Theme("UserJudgementLabel");

local WHEEL_CENTER_X=SCREEN_CENTER_X-80;
local WHEEL_CENTER_Y=SCREEN_CENTER_Y+60;
local BANNER_CENTER_X=WHEEL_CENTER_X;
local BANNER_CENTER_Y=WHEEL_CENTER_Y-190;
local STATS_CENTER_X=WHEEL_CENTER_X+100;
local STATS_CENTER_Y=WHEEL_CENTER_Y+110;
local INFO_CENTER_X=math.max(SCREEN_CENTER_X+200,SCREEN_RIGHT-180);
local INFO_CENTER_Y=SCREEN_CENTER_Y;

local t=Def.ActorFrame{};
local t2=Def.ActorFrame{};

if CntDRFile()>0 then
	t2[#t2+1]=Def.ActorFrame{
		OnCommand=cmd(playcommand,"Set");
-- Banner / Wheel 
		Def.Banner{
			SetMessageCommand=function(self)
				self:Load(GetDRInfo(GetDRFile(GetSelDrillCategory()).."-Banner"));
				self:scaletofit(-150,-48,150,48);
				self:x(BANNER_CENTER_X);
				self:y(BANNER_CENTER_Y);
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=cmd(maxwidth,300;);
			SetMessageCommand=function(self)
				self:diffuse(Str2Color(GetDRInfo(GetDRFile(GetSelDrillCategory()).."-Color")));
				local c1=Str2Color(GetDRInfo(GetDRFile(GetSelDrillCategory()).."-Color"))[1];
				local c2=Str2Color(GetDRInfo(GetDRFile(GetSelDrillCategory()).."-Color"))[2];
				if tonumber(c2)<0.8 then
					self:strokecolor(Color("White"));
				else
					self:strokecolor(Color("Outline"));
				end;
				self:settext(GetDRInfo(GetDRFile(GetSelDrillCategory()).."-Title"));
				self:x(WHEEL_CENTER_X);
				self:y(WHEEL_CENTER_Y-118);
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=cmd(zoom,0.65;maxwidth,300/0.65;
				diffuse,waieiColor("Text");strokecolor,Color("White");
				x,WHEEL_CENTER_X;y,WHEEL_CENTER_Y-96);
			SetMessageCommand=function(self)
				self:settext(""..GetSelDrillCategory().."/"..CntDRFile());
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
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(left);
				self:diffuse(waieiColor("Text"));
				self:strokecolor(Color("White"));
				self:x(STATS_CENTER_X-82);
				self:y(STATS_CENTER_Y-16);
				self:zoom(0.5);
				self:settext("Cleared Level");
			end;
			SetMessageCommand=function(self)
				if GetDRInfo(GetDRFile(GetSelDrillCategory()).."-ClearName")=="NO DATA" then
					self:diffuse(Color("Black"));
					self:diffusealpha(0.3);
				else
					self:diffuse(waieiColor("Text"));
					self:diffusealpha(1.0);
				end;
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:diffuse(waieiColor("Text"));
				self:strokecolor(Color("White"));
				self:x(STATS_CENTER_X);
				self:y(STATS_CENTER_Y+5);
			end;
			SetMessageCommand=function(self)
				if GetDRInfo(GetDRFile(GetSelDrillCategory()).."-ClearName")=="NO DATA" then
					self:diffuse(Color("Black"));
					self:diffusealpha(0.3);
				else
					self:diffuse(waieiColor("Text"));
					self:diffusealpha(1.0);
				end;
				self:settext(GetDRInfo(GetDRFile(GetSelDrillCategory()).."-ClearName"));
			end;
		};
-- Information
		Def.Quad{
			InitCommand=function(self)
				self:zoomto(220,360);
				self:x(INFO_CENTER_X);
				self:y(INFO_CENTER_Y);
				self:diffuse(Color("White"));
				self:diffusealpha(0.8);
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(left);
				self:diffuse(waieiColor("Dark"));
				self:strokecolor(Color("White"));
				self:x(INFO_CENTER_X-100);
				self:y(INFO_CENTER_Y-160);
				self:zoom(0.65);
				self:settext("PlayStyle : ");
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				local style=string.upper(GetDRInfo(GetDRFile(GetSelDrillCategory()).."-Style"));
				self:horizalign(right);
				self:diffuse(waieiColor("Text"));
				self:strokecolor(Color("White"));
				self:x(INFO_CENTER_X+100);
				self:y(INFO_CENTER_Y-160);
				self:settext(style);
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(left);
				self:diffuse(waieiColor("Dark"));
				self:strokecolor(Color("White"));
				self:x(INFO_CENTER_X-100);
				self:y(INFO_CENTER_Y-120);
				self:zoom(0.65);
				self:settext("Best\nController : ");
			end;
		};
		LoadActor(THEME:GetPathG("_Drills/drill","controllers"))..{
			InitCommand=function(self)
				self:x(INFO_CENTER_X+50);
				self:y(INFO_CENTER_Y-95);
				self:animate(false);
			end;
			SetMessageCommand=function(self)
				local ctrl=string.upper(GetDRInfo(GetDRFile(GetSelDrillCategory()).."-Ctrl"));
				if ctrl=="PAD" then
					self:setstate(0);
				elseif ctrl=="KEY" then
					self:setstate(1);
				else
					self:setstate(2);
				end;
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(left);
				self:diffuse(waieiColor("Dark"));
				self:strokecolor(Color("White"));
				self:x(INFO_CENTER_X-100);
				self:y(INFO_CENTER_Y-30);
				self:zoom(0.65);
				self:settext("ClearBorder : ");
			end;
		};
		Def.Quad{
			InitCommand=function(self)
				self:horizalign(left);
				self:diffuse(waieiColor("Dark"));
				self:x(INFO_CENTER_X-100-1);
				self:y(INFO_CENTER_Y-10);
				self:zoomto(200+2,10+2);
			end;
		};
		Def.Quad{
			InitCommand=function(self)
				self:horizalign(left);
				self:diffuse(waieiColor("Text"));
				self:diffusetopedge(Color("White"));
				self:x(INFO_CENTER_X-100);
				self:y(INFO_CENTER_Y-10);
				self:zoomto(200,10);
			end;
		};
		Def.Quad{
			InitCommand=function(self)
				self:horizalign(right);
				self:diffuse(Color("Yellow"));
				self:diffusetopedge(Color("White"));
				self:x(INFO_CENTER_X+100);
				self:y(INFO_CENTER_Y-10);
			end;
			SetMessageCommand=function(self)
				self:zoomto((100-tonumber(GetDRInfo(GetDRFile(GetSelDrillCategory()).."-Border")))*2,10);
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(right);
				self:diffuse(waieiColor("Text"));
				self:strokecolor(Color("White"));
				self:x(INFO_CENTER_X+100);
				self:y(INFO_CENTER_Y-30);
			end;
			SetMessageCommand=function(self)
				self:settext(GetDRInfo(GetDRFile(GetSelDrillCategory()).."-Border").."%");
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(left);
				self:diffuse(waieiColor("Dark"));
				self:strokecolor(Color("White"));
				self:x(INFO_CENTER_X-100);
				self:y(INFO_CENTER_Y+20);
				self:zoom(0.65);
				self:settext("LifeMeter : ");
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(right);
				self:x(INFO_CENTER_X+100);
				self:y(INFO_CENTER_Y+20);
				self:maxwidth(110);
			end;
			SetMessageCommand=function(self)
				local lf=string.upper(GetDRInfo(GetDRFile(GetSelDrillCategory()).."-Life"));
				self:strokecolor(Color("White"));
				if lf=="NORMAL" or lf=="NORECOVER" or lf=="HARD" then
					self:diffuse(waieiColor("Text"));
					self:settext(lf);
				elseif lf=="HARDNORECOVER" then
					self:diffuse(waieiColor("Text"));
					self:settext("HARD NORECOVER");
				elseif lf=="SUDDENDEATH" or lf=="ULTIMATE" then
					self:diffuse(waieiColor("Red"));
					self:settext(lf);
				elseif lf=="FC" or lf=="W3FC" then
					self:strokecolor(Color("Outline"));
					self:diffuse(GameColor.Judgment["JudgmentLine_W3"]);
					self:settext("FULLCOMBO");
				elseif lf=="PFC" or lf=="W2FC" then
					self:strokecolor(Color("Outline"));
					self:diffuse(GameColor.Judgment["JudgmentLine_W2"]);
					self:settext(_JudgementLabel2(jud,"JudgmentLine_W2").." FC");
				elseif lf=="MFC" or lf=="W1FC" then
					self:strokecolor(Color("Outline"));
					self:diffuse(GameColor.Judgment["JudgmentLine_W1"]);
					self:settext(_JudgementLabel2(jud,"JudgmentLine_W1").." FC");
				elseif lf=="1" then
					self:diffuse(waieiColor("Red"));
					self:settext(lf.." Life");
				else
					self:diffuse(waieiColor("Text"));
					self:settext(lf.." Lives");
				end;
			end;
		};
		LoadActor(THEME:GetPathG("_Drills/drill","life"))..{
			InitCommand=function(self)
				self:x(INFO_CENTER_X);
				self:y(INFO_CENTER_Y+45);
				self:animate(false);
			end;
			SetMessageCommand=function(self)
				local lf=string.upper(GetDRInfo(GetDRFile(GetSelDrillCategory()).."-Life"));
				if lf=="NORMAL" or lf=="NORECOVER" or lf=="HARD"
					or lf=="HARDNORECOVER" or lf=="SUDDENDEATH"
					or lf=="ULTIMATE" then
					self:setstate(0);
				elseif lf=="1" or lf=="FC" or lf=="W3FC"
					or lf=="PFC" or lf=="W2FC"
					or lf=="MFC" or lf=="W1FC" then
					self:setstate(2);
				else
					self:setstate(1);
				end;
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(left);
				self:diffuse(waieiColor("Dark"));
				self:strokecolor(Color("White"));
				self:x(INFO_CENTER_X-100);
				self:y(INFO_CENTER_Y+80);
				self:zoom(0.65);
				self:settext("LifeDifficulty : ");
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(right);
				self:diffuse(waieiColor("Text"));
				self:strokecolor(Color("White"));
				self:x(INFO_CENTER_X+100);
				self:y(INFO_CENTER_Y+80);
			end;
			SetMessageCommand=function(self)
				self:settext(GetDRInfo(GetDRFile(GetSelDrillCategory()).."-LDif"));
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(left);
				self:diffuse(waieiColor("Dark"));
				self:strokecolor(Color("White"));
				self:x(INFO_CENTER_X-100);
				self:y(INFO_CENTER_Y+105);
				self:zoom(0.65);
				self:settext("TimingDifficulty : ");
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(right);
				self:diffuse(waieiColor("Text"));
				self:strokecolor(Color("White"));
				self:x(INFO_CENTER_X+100);
				self:y(INFO_CENTER_Y+105);
			end;
			SetMessageCommand=function(self)
				self:settext(GetDRInfo(GetDRFile(GetSelDrillCategory()).."-TDif"));
			end;
		};
		LoadActor(THEME:GetPathG("_Drills/drill","options1"))..{
			InitCommand=function(self)
				self:x(INFO_CENTER_X-45);
				self:y(INFO_CENTER_Y+150);
				self:animate(false);
			end;
			SetMessageCommand=function(self)
				if GetDRInfo(GetDRFile(GetSelDrillCategory()).."-SOpt")=="true" then
					self:setstate(0);
				else
					self:setstate(1);
				end;
			end;
		};
		LoadActor(THEME:GetPathG("_Drills/drill","options2"))..{
			InitCommand=function(self)
				self:x(INFO_CENTER_X+45);
				self:y(INFO_CENTER_Y+150);
				self:animate(false);
			end;
			SetMessageCommand=function(self)
				if GetDRInfo(GetDRFile(GetSelDrillCategory()).."-ROpt")=="true" then
					self:setstate(0);
				else
					self:setstate(1);
				end;
			end;
		};
	};
else
	t2[#t2+1]=Def.ActorFrame{
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:x(SCREEN_CENTER_X+_HS2);
				self:y(SCREEN_CENTER_Y);
				self:diffuse(Color("White"));
				self:strokecolor(waieiColor("Text"));
				self:settext(THEME:GetString("ScreenSelectDrillCategory","Missing"));
			end;
		};
	};
end;
t2.OffMessageCommand=function(self)
	self:accelerate(_TT.S_OUT);
	self:x(-SCREEN_CENTER_X);
	self:y(SCREEN_CENTER_Y);
	self:zoomx(2);
	self:zoomy(0);
end;
t[#t+1]=t2;
-- Header/Footer 
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