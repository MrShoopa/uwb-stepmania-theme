local bg=GetDRInfo("ResultBackground");

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
return t;