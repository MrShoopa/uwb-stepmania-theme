local t=Def.ActorFrame{FOV=60;};
local w_PosX={-250,-150,0,150,250};
local w_PosY={20,20,0,-20,-20};
local w_Size={60,60,80,60,60};
local w_Alpha={0,1,1,1,0};
local w_RotX={  0,  0,  0,  0,  0};
local w_RotY={  0,  0,  0,  0,  0};
local w_RotZ={  0,  0,  0,  0,  0};
for i=0,2 do
	t[#t+1]=Def.Banner{
		OnCommand=cmd(playcommand,"Set");
		SetMessageCommand=function(self,params)
			self:Load(GetLVInfo(GetSelDrillLevel_Area(GetSelDrillLevel()+(i-1)).."-Jacket"));
			local _i_;
			if params then
				self:finishtweening();
				if params.Scroll=="Right" then
					_i_=i+3;
				elseif params.Scroll=="Left" then
					_i_=i+1;
				end;
				if params.Scroll=="Left" or params.Scroll=="Right" then
					self:scaletofit(-w_Size[_i_],-w_Size[_i_],w_Size[_i_],w_Size[_i_]);
					self:x(w_PosX[_i_]);
					self:y(w_PosY[_i_]);
					self:diffusealpha(w_Alpha[_i_]);
					self:rotationx(w_RotX[_i_]);
					self:rotationy(w_RotY[_i_]);
					self:rotationz(w_RotZ[_i_]);
					self:linear(0.15);
				end;
			end;
			_i_=i+2;
			self:scaletofit(-w_Size[_i_],-w_Size[_i_],w_Size[_i_],w_Size[_i_]);
			self:x(w_PosX[_i_]);
			self:y(w_PosY[_i_]);
			self:diffusealpha(w_Alpha[_i_]);
			self:rotationx(w_RotX[_i_]);
			self:rotationy(w_RotY[_i_]);
			self:rotationz(w_RotZ[_i_]);
		end;
		OffMessageCommand=cmd(bouncebegin,0.8;diffusealpha,0;rotationz,60;zoom,2);
	};
end;
return t;