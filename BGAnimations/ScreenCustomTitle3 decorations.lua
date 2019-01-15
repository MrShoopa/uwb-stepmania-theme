return Def.ActorFrame{
	Def.Actor{
		OnCommand=function(self)
			local menu=split(',',TC_GetOther('CustomMenu','Folder'));
			if menu and #menu>=3 then
				C_Init(menu[3]);
			else
				SCREENMAN:GetTopScreen():Cancel();
			end;
		end;
	};
};