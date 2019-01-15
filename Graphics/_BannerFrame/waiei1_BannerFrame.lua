local sys_selgroup=1;
local t;
local wheel_sel="";
local g="";
local wib;
local title={};
local lms={
	Split=false,
	LorM=false
};
setenv("Update","false");
setenv("BannerHeight",80);
t=Def.ActorFrame{
	CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
	SetCommand=function(self)
		wheel_sel=wh_GetCurrentType() or "";
		if IsEXFolder() then
			song=GetEXFSongState_Song(GetEXFCurrentSong());
			title[1]=GetEXFSongState_Title(GetEXFCurrentSong());
			title[2]=GetEXFSongState_SubTitle(GetEXFCurrentSong());
		elseif wheel_sel=="Song" then
			song=wh_GetCurrentSong();
			local folder=song:GetSongDir();
			title=SplitTitle(song:GetDisplayMainTitle());
			if title[2]=="" then
				title[2]=song:GetDisplaySubTitle();
			end;
		elseif wheel_sel=="Custom" then
			if wh_GetCurrentLabel()=="EXFolder" then
				title[1]="EXFolder";
			else
				title[1]="仮置き";
			end;
		else
			if wheel_sel=="Mode" then
				title[1]=wh_GetCurrentLabel();
			else
				title[1]="Roulette";
			end;
		end;
	end;
	OnCommand=function(self)
		self:x(-192);
		self:y(45);
		self:playcommand("Set");
	end;
	OffCommand=function(self)
		self:zoom(1);
	end;
	LoadActor("waiei1_frame")..{
		InitCommand=function(self)
			self:x(-4);
		end;
	};
	Def.Banner{
		SetCommand=function(self)
			self:stoptweening();
			local cache=false;
			local fallbn=false;
			g="";
			if GAMESTATE:IsCourseMode() then
				local course=_COURSE();
				if course and course:HasBanner() then
					g=course:GetBannerPath();
				else
					g=THEME:GetPathG("Common fallback","banner");
					fallbn=true;
				end;
			elseif IsEXFolder() then
				--EXFolder
				g=GetEXFSongState_Banner(GetEXFCurrentSong());
				fallbn=false;
			elseif wheel_sel=="Song" then
				local song=_SONG();
				if song and song:HasBanner() and not song:HasPreviewVid() then
					g=song:GetBannerPath();
					cache=true;
				elseif song:HasPreviewVid() then
					g=song:GetPreviewVidPath();
					cache=false;
				else
					g=THEME:GetPathG("Common fallback","banner");
					fallbn=true;
				end;
			elseif wheel_sel=="Folder" then
				g=SONGMAN:GetSongGroupBannerPath(wh_GetCurrentLabel());
				cache=true;
				if g=="" then
					g=THEME:GetPathG("Common fallback","banner");
					fallbn=true;
					cache=false;
				end;
			elseif wheel_sel=="Custom" then
				if wh_GetCurrentLabel()=="EXFolder" then
					g=GetGroups(GetEXFLastPlayedGroup(),'exf_banner');
					fallbn=true;
				else
					g=THEME:GetPathG("Common fallback","banner");	--仮置き 
					if g==THEME:GetPathG("Common fallback","banner") then
						fallbn=true;
					end;
				end;
			elseif wheel_sel=="Roulette" then
				g=THEME:GetPathG("_wheel/roulette","banner");
				fallbn=true;
			elseif wheel_sel=="Mode" then
				g=THEME:GetPathG("Common fallback","banner");
				fallbn=true;
			end;
			if cache then
				self:LoadFromCachedBanner(g);
			else
				self:Load( g );
			end;
			self:scaletofit(-92,-92,92,92);
			local cr=math.max((self:GetHeight()-(self:GetWidth()*0.3125))/2/self:GetHeight(),0.0);
			self:croptop(cr);
			self:cropbottom(cr);
			setenv("Update","true");
			setenv("BannerHeight",(self:GetHeight()-self:GetHeight()*cr*2)*256/self:GetWidth());
			if cache then
				self:sleep(0.1);
				self:queuecommand("BannerLoad");
			end;
		end;
		BannerLoadCommand=function(self)
			if wheel_sel=="Folder" then
				self:Load(g);
			else
				self:Load(GetMainBannerPath(_SONG()));
			end;
			self:scaletofit(-92,-92,92,92);
			local cr=math.max((self:GetHeight()-(self:GetWidth()*0.3125))/2/self:GetHeight(),0.0);
			self:croptop(cr);
			self:cropbottom(cr);
			self:rate(0.5);
		end;
	};
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(184,60);
			self:diffuse(0,0,0,0.5);
		end;
	};
	LoadActor(TC_GetPath("BannerFrame","split"))..{
		InitCommand=cmd(visible,false;animate,false;x,-45;y,15);
		OnCommand=cmd(playcommand,"Set");
		SetMessageCommand=function(self)
			if _SONG() then
				if GetEXFCurrentSong_ShowBPMTime() then
				--	self:stoptweening();
					local st=GAMESTATE:GetCurrentStyle():GetStepsType();
					local f=false;
					local song=_SONG();
					for i=1,6 do
						if song:HasStepsTypeAndDifficulty(st,Difficulty[i]) then
							if song:IsStepsUsingDifferentTiming(song:GetOneSteps(st,Difficulty[i])) then
								f=true;
								break;
							end;
						end;
					end;
					if f then
						self:visible(true);
						lms.Split=true;
					else
						self:visible(false);
						lms.Split=false;
					end;
				else
					self:visible(false);
					lms.Split=false;
				end;
			else
				self:visible(false);
				lms.Split=false;
			end;
		end;
	};
	LoadActor(TC_GetPath("BannerFrame","long_marathon"))..{
		InitCommand=cmd(visible,false;animate,false;x,58;y,15);
		OnCommand=cmd(playcommand,"Set");
		SetMessageCommand=function(self)
			local song=_SONG();
			if song then
				if GetEXFCurrentSong_ShowBPMTime() then
				--	self:stoptweening();
					if song:IsLong() then
						self:setstate(0);
						self:visible(true);
						lms.LorM=true;
					elseif song:IsMarathon() then
						self:setstate(1);
						self:visible(true);
						lms.LorM=true;
					else
						self:visible(false);
						lms.LorM=false;
					end;
				else
					self:visible(false);
					lms.LorM=false;
				end;
			else
				self:visible(false);
				lms.LorM=false;
			end;
		end;
	};
	Def.Actor{
		SetMessageCommand=function(self)
			MESSAGEMAN:Broadcast("SetY",lms);
		end;
	};
};

local function Update(self)
	if getenv("Update")=="true" then
		self:queuecommand("ReSize");
		setenv("Update","false");
	end;
end;

t.InitCommand=cmd(SetUpdateFunction,Update);
return t;