local t=Def.ActorFrame{
	CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	OnCommand=function(self)
		self:zoomx(TC_GetMetric("Wheel","ZoomX"));
		self:zoomy(TC_GetMetric("Wheel","ZoomY"));
		self:zoomz(TC_GetMetric("Wheel","ZoomZ"));
		self:queuecommand("On2");
	end;
	On2Command=TC_GetCommand("Wheel","OnCommand");
};

local function SetWheelSize(self,offset,add)
	local offsetFromCenter=offset+add;
	if TC_GetSubColor()=='main' then
		local absOffset=math.abs(offsetFromCenter);
		if absOffset<1 then
			self:zoom(0.5+0.5*(1-absOffset));
			self:y(-50*absOffset);
			self:x(offsetFromCenter*160);
		else
			self:zoom(0.5);
			self:y(-50);
			if offsetFromCenter<0 then
				self:x(-160+(offsetFromCenter+1)*110);
			else
				self:x( 160+(offsetFromCenter-1)*110);
			end;
		end;
		self:zoomz(10);
		self:z(-absOffset);
	else
		local absOffset=math.abs(offsetFromCenter);
		self:y(540.0*math.cos(math.pi*offsetFromCenter/12)-420);
		self:x(SCREEN_WIDTH*1.0*math.sin(math.pi*offsetFromCenter/18));
		self:z(-5*absOffset);
		if absOffset<1 then
			self:zoomx(0.9+0.2*(1-absOffset));
			self:zoomy(0.9+0.1*(1-absOffset));
			self:rotationx(45*(1-absOffset));
		else
			self:zoom(0.9);
			self:rotationx(0);
		end;
		self:zoom(1);
	end;
end;

for i=-5,5 do
	t[#t+1]=LoadActor("SongWheel",i)..{
		-- [ja] 位置とか動作はこっちで指定 
		InitCommand=cmd(playcommand,"ReSize");
		SetSongMessageCommand=function(self,params)
			if params.Move then
				self:finishtweening();
				if params.Move=="Left" then
					SetWheelSize(self,i,-1);
					self:linear(0.15);
					SetWheelSize(self,i,0);
				elseif params.Move=="Right" then
					SetWheelSize(self,i,1);
					self:linear(0.15);
					SetWheelSize(self,i,0);
				end;
			end;
		end;
		ReSizeCommand=function(self)
			SetWheelSize(self,i,0);
		end;
	};
end;

return t;