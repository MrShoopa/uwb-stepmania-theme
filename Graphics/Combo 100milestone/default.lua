local ShowFlashyCombo;

if GetUserPref_Theme("DF_FlashyCombos")
 and GetUserPref_Theme("DF_FlashyCombos")=='On' then
	ShowFlashyCombo=true;
else
	ShowFlashyCombo=false;
end;

return Def.ActorFrame {
	LoadActor("explosion") .. {
		InitCommand=cmd(playcommand,"Set");
		OnCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			self:diffusealpha(0);
			self:blend('BlendMode_Add');
			self:visible(ShowFlashyCombo);
		end;
		MilestoneCommand=cmd(zoomx,0;zoomy,1;diffusealpha,1;linear,0.5;zoomx,3;zoomy,0;diffusealpha,0);
	};
	LoadActor("explosion") .. {
		InitCommand=cmd(playcommand,"Set");
		OnCommand=cmd(playcommand,"Set");
		SetCommand=cmd(diffusealpha,0;blend,'BlendMode_Add';visible,ShowFlashyCombo);
		MilestoneCommand=cmd(zoomx,1;zoomy,0;diffusealpha,1;linear,0.5;zoomx,1;zoomy,1;diffusealpha,0);
	};
};