local bg=GetDRInfo("Background");
local bgm=GetDRInfo("Bgm");

local t=Def.ActorFrame{};
if bg and bg~="" and FILEMAN:DoesFileExist(bg) then
	t[#t+1]=LoadActor(bg)..{
		InitCommand=function(self)
			if not string.find(string.lower(bg),"%.lua$") then
				self:Center();
			end;
		end;
	};
else
	t[#t+1]=LoadActor(THEME:GetPathB("ScreenWithMenuElements","background"))..{};
end;
t[#t+1]=Def.ActorFrame{
	-- BGM 
	Def.Sound {
		InitCommand=function(self)
			if bgm and bgm~="" and FILEMAN:DoesFileExist(bgm) then
				self:load(bgm);
			else
				self:load(THEME:GetPathS("_DrillDifficulty","music"));
			end;
			self:stop();
			self:queuecommand("Play");
		end;
		PlayCommand=cmd(play);
	};
};
return t;