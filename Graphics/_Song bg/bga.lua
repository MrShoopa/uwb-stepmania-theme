local scale = GetwaieiBulrSize();
local function GetSongBG(song)
	if song and song:HasBackground() then
		g=song:GetBackgroundPath()
	else
		g=THEME:GetPathG('common','fallback background');
	end;
	return g;
end

return Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(
			horizalign,left;
			vertalign,top;
			zoomto,SCREEN_WIDTH/scale,SCREEN_HEIGHT/scale;
			diffuse,0,0,0,1
		);
	};
	LoadActor(THEME:GetPathG('_Gameplay','BGA'),_SONG2())..{
		InitCommand=cmd(
			x,SCREEN_CENTER_X/scale;
			y,SCREEN_CENTER_Y/scale;
			zoom,1/scale;
		);
	};
	Def.Quad{
		InitCommand=cmd(
			horizalign,left;
			vertalign,top;
			zoomto,SCREEN_WIDTH/scale,SCREEN_HEIGHT/scale;
			diffuse,0,0,0,1.0-PREFSMAN:GetPreference('BGBrightness')
		);
	};
	Def.ActorProxy{
		Name = "ProxyP1";
		OnCommand=function(self)
			if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
				self:x(0);
				self:y(0);
				self:SetTarget(SCREENMAN:GetTopScreen():GetChild('PlayerP1'));
			end;
		end;
	};
	Def.ActorProxy{
		Name = "ProxyP2";
		OnCommand=function(self)
			if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
				self:x(0);
				self:y(0);
				self:SetTarget(SCREENMAN:GetTopScreen():GetChild('PlayerP2'));
			end;
		end;
	};
};