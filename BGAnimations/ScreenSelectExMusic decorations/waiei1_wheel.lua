local t=Def.ActorFrame{};

local function SetWheelSize(self,offset,add)
	local offsetFromCenter=offset+add;
	if SCREEN_HEIGHT/SCREEN_WIDTH<0.65 then
		if offsetFromCenter<=-1 then
			self:zoom(0.5);
			self:x(1.0*offsetFromCenter*110-50);
			self:y(0);
		elseif offsetFromCenter>=1 then
			self:zoom(0.5);
			self:x(1.0*offsetFromCenter*110+50);
			self:y(0);
		else
			self:zoom(0.5+(0.5-(math.abs(offsetFromCenter)*0.5)));
			self:x(1.0*offsetFromCenter*160);
			self:y(-48+(math.abs(offsetFromCenter)*48));
		end;
	else
		if offsetFromCenter<=-1 then
			self:zoom(0.4);
			self:x(1.0*offsetFromCenter*85-60);
			self:y(12);
		elseif offsetFromCenter>=1 then
			self:zoom(0.4);
			self:x(1.0*offsetFromCenter*85+60);
			self:y(12);
		else
			self:zoom(0.4+(0.6-(math.abs(offsetFromCenter)*0.6)));
			self:x(1.0*offsetFromCenter*145);
			self:y(-48+(math.abs(offsetFromCenter)*48)+math.abs(offsetFromCenter)*12);
		end;
	end;
end;

for i=-4,4 do
	t[#t+1]=Def.ActorFrame{
		FOV=60;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		InitCommand=cmd(zoomz,1;);
		LoadActor("SongWheel",i)..{
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
	};
end;

return t;