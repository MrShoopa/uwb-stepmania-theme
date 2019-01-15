local sys_selgroup=1;
local t;
local wheel_sel="";
local g="";
local wib;
local title={};
local song;
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
				--title[1]="EXFolder";
				title[1]=GetGroups(GetEXFLastPlayedGroup(),'exf_name');
			else
				title[1]="仮置き";
			end;
		elseif wheel_sel=="Folder" then
			title[1]=GetGroups(wh_GetCurrentLabel(),"name") or wh_GetCurrentLabel();
		else
			if wheel_sel=="Mode" then
				title[1]=wh_GetCurrentLabel();
			else
				title[1]="Roulette";
			end;
		end;
	end;
	OnCommand=function(self)
		self:playcommand("Set");
	end;
	OffCommand=function(self)
		self:zoom(1);
	end;
	LoadActor("waiei2_frame")..{
		InitCommand=function(self)
			self:x(160);
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:diffuse(0,0,0.5,1);
			self:strokecolor(1.0,1.0,1.0,1.0);
			self:maxwidth(270);
			self:horizalign(left);
			self:x(40);
		end;
		SetCommand=function(self)
			if wheel_sel=="Song" then
				if title[2]~="" then
					self:y(5);
				else
					self:y(10);
				end;
			elseif wheel_sel=="Custom" then
				self:y(10);
			else
				self:y(10);
			end;
			self:settext(title[1]);
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:diffuse(0,0,0.5,1);
			self:strokecolor(1.0,1.0,1.0,1.0);
			self:maxwidth(270/0.65);
			self:zoom(0.65);
			self:horizalign(left);
			self:x(40);
			self:y(25);
		end;
		SetCommand=function(self)
			if wheel_sel=="Song" and title[2]~="" then
				self:settext(title[2]);
			else
				self:settext("");
			end;
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:diffuse(0,0,0,0.8);
			self:strokecolor(1.0,1.0,1.0,1.0);
			self:maxwidth(270/0.9);
			self:zoom(0.9);
			self:horizalign(left);
			self:x(40);
			self:y(40);
		end;
		SetCommand=function(self)
			if IsEXFolder() then
				self:settext(GetEXFSongState_Artist(GetEXFCurrentSong()));
			elseif wheel_sel=="Custom" then
				if wh_GetCurrentLabel()=="EXFolder" then
					self:settext(""..THEME:GetString("ScreenSelectMusic","EXFolder"));
				else
					self:settext(""..THEME:GetString("ScreenSelectMusic","Return"));
				end;
			elseif wheel_sel~="Song" then
				self:settext("");
			else
				if title[2]~="" then
					self:y(42);
				else
					self:y(40);
				end;
				if song then
					self:settext(song:GetDisplayArtist());
				else
					self:settext("");
				end;
			end;
		end;
	};
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(270,40);
			self:x(-140);
			self:y(5);
			self:diffuse(0,0,0,0.3);
		end;
		ReSizeCommand=function(self)
			self:finishtweening();
			self:linear(0.05);
			self:zoomto(270,getenv("BannerHeight")+14);
		end;
	};
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(260,40);
			self:x(-140);
			self:y(5);
			--self:diffuse(1,1,1,0.5);
			self:diffuse(0,0.1,0.5,0.5);
			--self:blend("BlendMode_Add");
		end;
		ReSizeCommand=function(self)
			self:finishtweening();
			self:linear(0.05);
			self:zoomto(260,getenv("BannerHeight")+4);
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
			elseif wheel_sel=="Folder" then
				g=SONGMAN:GetSongGroupBannerPath(wh_GetCurrentLabel());
				cache=true;
				if g=="" then
					g=THEME:GetPathG("Common fallback","banner");
					fallbn=true;
					cache=false;
				end;
			elseif wheel_sel=="Song" then
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
			elseif wheel_sel=="Custom" then
				if wh_GetCurrentLabel()=="EXFolder" then
					--g=THEME:GetPathG("_wheel/exfolder","banner");
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
			self:scaletofit(-128,-128,128,128);
			local cr=math.max((self:GetHeight()-(self:GetWidth()*0.48))/2/self:GetHeight(),0.0);
			self:croptop(cr);
			self:cropbottom(cr);
			self:x(-140);
			self:y(5);
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
			self:scaletofit(-128,-128,128,128);
			local cr=math.max((self:GetHeight()-(self:GetWidth()*0.48))/2/self:GetHeight(),0.0);
			self:croptop(cr);
			self:cropbottom(cr);
			self:x(-140);
			self:y(5);
			self:rate(0.5);
		end;
	};
	LoadActor(TC_GetPath("BannerFrame","split"))..{
		InitCommand=cmd(visible,false;animate,false;);
		OnCommand=cmd(playcommand,"Set");
		SetMessageCommand=function(self)
			if _SONG() then
				local song=_SONG();
				if GetEXFCurrentSong_ShowBPMTime() then
					self:stoptweening();
					self:x(140);
					self:y(-25);
					local st=GAMESTATE:GetCurrentStyle():GetStepsType();
					local f=false;
					for i=1,5 do	-- [ja] EDITは考慮しない
						if song:HasStepsTypeAndDifficulty(st,Difficulty[i]) then
							if song:IsStepsUsingDifferentTiming(song:GetOneSteps(st,Difficulty[i])) then
								f=true;
								break;
							end;
						end;
					end;
					if f then
						self:visible(true);
					else
						self:visible(false);
					end;
				else
					self:visible(false);
				end;
			else
				self:visible(false);
			end;
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	};
	LoadActor(TC_GetPath("BannerFrame","long_marathon"))..{
		InitCommand=cmd(visible,false;animate,false;);
		OnCommand=cmd(playcommand,"Set");
		SetMessageCommand=function(self)
			local song=_SONG();
			if song then
				if GetEXFCurrentSong_ShowBPMTime() then
					self:stoptweening();
					self:x(280);
					self:animate(false);
					self:y(-25);
					if song:IsLong() then
						self:setstate(0);
						self:visible(true);
					elseif song:IsMarathon() then
						self:setstate(1);
						self:visible(true);
					else
						self:visible(false);
					end;
				else
					self:visible(false);
				end;
			else
				self:visible(false);
			end;
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
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