return Def.ActorFrame{
	Def.Actor{
		OnCommand=function(self)
			local menu=split(',',TC_GetOther('CustomMenu','Folder'));
			if menu and #menu>=4 then
				C_Init(menu[4]);
			else
				SCREENMAN:GetTopScreen():Cancel();
			end;
		end;
	};
};