local t=Def.ActorFrame{};
KillGroup();

t[#t+1]=Def.Actor{
	OnCommand=function(self)
		if not GetGroupStats() then
			SCREENMAN:SetNewScreen("ScreenSelectMusic");
		else
			SCREENMAN:SetNewScreen("ScreenHowToInstallSongs");
		end;
	end;
};

return t;
