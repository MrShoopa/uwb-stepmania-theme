local t=Def.ActorFrame{
	CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	OnCommand=function(self)
	-- [ja] 通常選曲と微妙に違うんや…
		local prmZoomX=TC_GetMetric("Wheel","ZoomX")*tonumber(TC_GetRatioPrm(TC_GetMetric("Wheel","ZoomRatio")));
		local prmZoomY=TC_GetMetric("Wheel","ZoomY")*tonumber(TC_GetRatioPrm(TC_GetMetric("Wheel","ZoomRatio")));
		local prmZoomZ=TC_GetMetric("Wheel","ZoomZ")*tonumber(TC_GetRatioPrm(TC_GetMetric("Wheel","ZoomRatio")));
		self:zoomx(prmZoomX);
		self:zoomy(prmZoomY);
		self:zoomz(prmZoomZ);
		self:rotationx(TC_GetMetric("Wheel","RotateX"));
		self:rotationy(TC_GetMetric("Wheel","RotateY"));
		self:rotationz(TC_GetMetric("Wheel","RotateZ"));
		self:addx(TC_GetMetric("Wheel","PosX"));
		self:addy(TC_GetMetric("Wheel","PosY"));
		self:queuecommand("On2");
	end;
	On2Command=TC_GetCommand("Wheel","OnCommand");
};

local function SetWheelSize(self,offset,add)
	local offsetFromCenter=offset+add;	local absOffset=math.abs(offsetFromCenter);
	local styleOffset = (TC_GetMetric("Wheel","Style")==0) and offsetFromCenter or absOffset;
	local offset = (offsetFromCenter>=0) and 1 or -1;
	if absOffset<1 then
		self:zoomx(TC_GetMetric("Wheel","CZoomX")+(TC_GetMetric("Wheel","SZoomX")-TC_GetMetric("Wheel","CZoomX"))*absOffset);
		self:zoomy(TC_GetMetric("Wheel","CZoomY")+(TC_GetMetric("Wheel","SZoomY")-TC_GetMetric("Wheel","CZoomY"))*absOffset);
		self:zoomz(TC_GetMetric("Wheel","CZoomZ")+(TC_GetMetric("Wheel","SZoomZ")-TC_GetMetric("Wheel","CZoomZ"))*absOffset);
		if TC_GetMetric("Wheel","Flow")=='X' then
			self:rotationx(TC_GetMetric("Wheel","CRotateX")+(TC_GetMetric("Wheel","SRotateX")-TC_GetMetric("Wheel","CRotateX"))*absOffset);
			self:rotationy(TC_GetMetric("Wheel","CRotateY")+(TC_GetMetric("Wheel","SRotateY")-TC_GetMetric("Wheel","CRotateY"))*offsetFromCenter);
			self:rotationz(TC_GetMetric("Wheel","CRotateZ")+(TC_GetMetric("Wheel","SRotateZ")-TC_GetMetric("Wheel","CRotateZ"))*offsetFromCenter);
			self:x(TC_GetMetric("Wheel","CPosX")+TC_GetMetric("Wheel","SPosX")*offsetFromCenter);
			self:y(TC_GetMetric("Wheel","CPosY")+TC_GetMetric("Wheel","SPosY")*styleOffset);
			self:z(TC_GetMetric("Wheel","CPosZ")+TC_GetMetric("Wheel","SPosZ")*styleOffset);
		else
			self:rotationx(TC_GetMetric("Wheel","CRotateX")+(TC_GetMetric("Wheel","SRotateX")-TC_GetMetric("Wheel","CRotateX"))*offsetFromCenter);
			self:rotationy(TC_GetMetric("Wheel","CRotateY")+(TC_GetMetric("Wheel","SRotateY")-TC_GetMetric("Wheel","CRotateY"))*absOffset);
			self:rotationz(TC_GetMetric("Wheel","CRotateZ")+(TC_GetMetric("Wheel","SRotateZ")-TC_GetMetric("Wheel","CRotateZ"))*offsetFromCenter);
			self:x(TC_GetMetric("Wheel","CPosX")+TC_GetMetric("Wheel","SPosX")*styleOffset);
			self:y(TC_GetMetric("Wheel","CPosY")+TC_GetMetric("Wheel","SPosY")*offsetFromCenter);
			self:z(TC_GetMetric("Wheel","CPosZ")+TC_GetMetric("Wheel","SPosZ")*styleOffset);
		end;
	else
		local sideOffsetS  = (offsetFromCenter>=0) and offsetFromCenter-1 or offsetFromCenter+1;
		local absOffsetS   = absOffset-1;
		local styleOffsetS = (TC_GetMetric("Wheel","Style")==0) and sideOffsetS or absOffsetS;
		local offsetS      = (TC_GetMetric("Wheel","Style")==0) and offset or math.abs(offset);
		self:zoomx(TC_GetMetric("Wheel","SZoomX")+TC_GetMetric("Wheel","AddSZoomX")*absOffsetS);
		self:zoomy(TC_GetMetric("Wheel","SZoomY")+TC_GetMetric("Wheel","AddSZoomY")*absOffsetS);
		self:zoomz(TC_GetMetric("Wheel","SZoomZ")+TC_GetMetric("Wheel","AddSZoomZ")*absOffsetS);
		if TC_GetMetric("Wheel","Flow")=='X' then
			self:rotationx(TC_GetMetric("Wheel","SRotateX")+TC_GetMetric("Wheel","AddSRotateX")*absOffsetS);
			self:rotationy(TC_GetMetric("Wheel","SRotateY")*offset+TC_GetMetric("Wheel","AddSRotateY")*sideOffsetS);
			self:rotationz(TC_GetMetric("Wheel","SRotateZ")*offset+TC_GetMetric("Wheel","AddSRotateZ")*sideOffsetS);
			self:x(TC_GetMetric("Wheel","CPosX")+TC_GetMetric("Wheel","SPosX")*offset+TC_GetMetric("Wheel","AddSPosX")*sideOffsetS);
			self:y(TC_GetMetric("Wheel","CPosY")+TC_GetMetric("Wheel","SPosY")*offsetS+TC_GetMetric("Wheel","AddSPosY")*styleOffsetS);
			self:z(TC_GetMetric("Wheel","CPosZ")+TC_GetMetric("Wheel","SPosZ")*offsetS+TC_GetMetric("Wheel","AddSPosZ")*styleOffsetS);
		else
			self:rotationx(TC_GetMetric("Wheel","SRotateX")*offset+TC_GetMetric("Wheel","AddSRotateX")*sideOffsetS);
			self:rotationy(TC_GetMetric("Wheel","SRotateY")+TC_GetMetric("Wheel","AddSRotateY")*absOffsetS);
			self:rotationz(TC_GetMetric("Wheel","SRotateZ")*offset+TC_GetMetric("Wheel","AddSRotateZ")*sideOffsetS);
			self:x(TC_GetMetric("Wheel","CPosX")+TC_GetMetric("Wheel","SPosX")*offsetS+TC_GetMetric("Wheel","AddSPosX")*styleOffsetS);
			self:y(TC_GetMetric("Wheel","CPosY")+TC_GetMetric("Wheel","SPosY")*offset+TC_GetMetric("Wheel","AddSPosY")*sideOffsetS);
			self:z(TC_GetMetric("Wheel","CPosZ")+TC_GetMetric("Wheel","SPosZ")*offsetS+TC_GetMetric("Wheel","AddSPosZ")*styleOffsetS);
		end;
	end;

	self:z(-absOffset);
	self:zoomz(1);
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
					self:linear(0.08);
					SetWheelSize(self,i,0);
				elseif params.Move=="Right" then
					SetWheelSize(self,i,1);
					self:linear(0.08);
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