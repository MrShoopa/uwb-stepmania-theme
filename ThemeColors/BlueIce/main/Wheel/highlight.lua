return Def.ActorFrame{
	LoadActor("_wheel highlight")..{
		InitCommand=function(self)
			if SCREEN_WIDTH/SCREEN_HEIGHT>1.65 then
				self:y(20);
				self:zoom(1);
			elseif SCREEN_WIDTH/SCREEN_HEIGHT>1.5 then
				self:y(20*0.92);
				self:zoom(0.92);
			else
				self:y(20*0.85);
				self:zoom(0.85);
			end;
		end;
	};
};
