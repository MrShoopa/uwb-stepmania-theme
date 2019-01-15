local pn,lifeWidth,difcolor,difname,mt=...;
local t=Def.ActorFrame{};

local ax={100,-100};
local p=(pn==PLAYER_1) and 1 or 2;
local stt;
if _SONG2() then
	stt = GAMESTATE:GetCurrentStyle():GetStepsType();
else
	stt = 'StepsType_Dance_Single';
end;
local song;
local st;
local dif;
t[#t+1]=Def.ActorFrame{
	InitCommand=cmd(playcommand,"Set");
	SetCommand=function(self)
		self:player(pn);
		song = _SONG2();
		st=_STEPS2(pn);
		if st and song then
			dif=st:GetDifficulty();
		end;
		if p==1 then
			(cmd(x,SCREEN_CENTER_X-lifeWidth-lifeWidth/4-SCREEN_WIDTH/16+50;
				y,SCREEN_BOTTOM-46;))(self);
		else
			(cmd(x,SCREEN_CENTER_X+lifeWidth+lifeWidth/4+SCREEN_WIDTH/16-50;
				y,SCREEN_BOTTOM-46;))(self);
		end;
		self:queuecommand('Set2');
	end;
	OnCommand=cmd(diffusealpha,0;addx,-ax[p];sleep,0.5;linear,0.25;addx,ax[p];diffusealpha,1;);
	OffCommand=cmd(diffusealpha,1;sleep,0.25;linear,0.25;addx,-ax[p];diffusealpha,0);
	CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	BeginCommand=cmd(playcommand,"Set");
	LoadActor(THEME:GetPathG("_LifeMeterBar/LifeMeterBar","Difficulty"))..{
		InitCommand=cmd(horizalign,right;vertalign,bottom;);
		Set2Command=function(self)
			if st and song then
				self:diffuse(_DifficultyCOLOR2(difcolor,dif));
			else
				self:diffuse(CustomDifficultyToColor("Difficulty_Edit"));
			end;
			if p==2 then
				self:rotationy(180);
			end;
		end;
	};
	LoadFont("Common normal")..{
		InitCommand=cmd(horizalign,(p==1) and left or right;vertalign,bottom;x,(p==1) and -100 or 100;y,-2);
		Set2Command=function(self)
			if st and song then
				self:diffuse(_DifficultyLightCOLOR2(difcolor,dif));
				self:strokecolor(ColorDarkTone(_DifficultyCOLOR2(difcolor,dif)));
				self:settextf("%s",string.upper(_DifficultyNAME2(difname,dif)));
			else
				self:diffuse(CustomDifficultyToLightColor("Difficulty_Edit"));
				self:strokecolor(CustomDifficultyToDarkColor("Difficulty_Edit"));
				self:settext("----");
			end;
			(cmd(zoom,0.55;maxwidth,90;))(self);
		end;
	};
	LoadFont("Common normal")..{
		InitCommand=cmd(horizalign,(p==2) and left or right;vertalign,top;x,(p==1) and -18 or 18;y,-10);
		Set2Command=function(self)
			if st and song then
				self:diffuse(_DifficultyLightCOLOR2(difcolor,dif));
				self:strokecolor(ColorDarkTone(_DifficultyCOLOR2(difcolor,dif)));
				if song:HasStepsTypeAndDifficulty(stt,dif) then
					if mt=='DDR X' then
						self:settext(GetConvertDifficulty_DDRX(song,st,GetNoLoadSongPrm(song,'metertype')));
					elseif mt=='LV100' then
						self:settext(GetConvertDifficulty_LV100(song,st));
					else
						self:settext(st:GetMeter());
					end;
				else
					self:settext("--");
				end;
			else
				self:diffuse(CustomDifficultyToLightColor("Difficulty_Edit"));
				self:strokecolor(CustomDifficultyToDarkColor("Difficulty_Edit"));
				self:settext("--");
			end;
			(cmd(zoom,0.9;maxwidth,90;))(self);
		end;
	};
};

return t;