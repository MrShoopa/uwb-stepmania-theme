local t=Def.ActorFrame{};

if TC_GetwaieiMode()==2 then
	t[#t+1]=LoadActor('waiei2');
else
	t[#t+1]=Def.ActorFrame{
		OnCommand=function(self)
			self:Center();
			self:diffusealpha(1);
		end;
		Def.Quad{
			BeginCommand=function(self)
				self:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT);
				self:diffuse(0,0,0,1);
			end;
		};
		Def.Sprite{
			BeginCommand=function(self)
				self:LoadFromCurrentSongBackground();
				self:scaletofit(-SCREEN_CENTER_X,-SCREEN_CENTER_Y,SCREEN_CENTER_X,SCREEN_CENTER_Y);
				self:diffusealpha(PREFSMAN:GetPreference("BGBrightness"));
			end;
		};
	};
	t[#t+1]=LoadActor('waiei1');
end;

return t;
