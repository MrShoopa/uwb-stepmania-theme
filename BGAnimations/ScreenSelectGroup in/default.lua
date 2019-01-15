local t=Def.ActorFrame{
--[[
	Def.Actor{
		OnCommand=function(self)
			local grData=getenv("grData");
			if not grData["Last-Set"] then
				grData["Last-Set"]=true;
				setenv("grData",grData);
				SCREENMAN:SetNewScreen("ScreenSelectMusic");
			end;
		end;
	};
	--]]
	LoadActor(THEME:GetPathS("Common","invalid"))..{
		OnCommand = function(self, params)
			self:play();
		end;
	};
};

return t;
