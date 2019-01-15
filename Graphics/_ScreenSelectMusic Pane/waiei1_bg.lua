local difcolor,difname,meter_type=...;
local song=nil;
local dif=nil;
local st=nil;
local stt=GAMESTATE:GetCurrentStyle():GetStepsType();
local h=20;	--[ja] 1ラインの高さ 

local t=Def.ActorFrame{
	LoadActor(TC_GetPath("Pane","bottom"))..{
		InitCommand=cmd(vertalign,top;x,0;y,65);
		OnCommand=cmd(zoomx,3;zoomy,0;diffusealpha,0;linear,0.2;zoomx,1;zoomy,1;diffusealpha,1;);
		OffCommand=cmd(stoptweening;linear,0.2;zoomx,3;diffusealpha,0);
	};
	Def.Quad{
		InitCommand=cmd(zoomto,1,24;diffuse,Color("White");
			vertalign,top;y,76;diffusealpha,0.5;rotationz,20;
			visible,GAMESTATE:GetNumPlayersEnabled()>1);
		OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		PlayerJoinedMessageCommand=cmd(playcommand,"Init");
	};
	LoadActor(TC_GetPath("Pane","side"))..{
		InitCommand=cmd(x,-310+50;diffuse,Color("White"););
		OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
	};
	LoadActor(TC_GetPath("Pane","side"))..{
		InitCommand=cmd(rotationy,180;x,310-50+1;diffuse,Color("White"););
		OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
	};
	Def.Quad {
		InitCommand=cmd(zoomto,620,130;);
		OnCommand=cmd(diffuse,Color("Black");diffusealpha,0;linear,0.35;diffusealpha,0.5);
		OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
	};
	Def.Quad {
		InitCommand=cmd(zoomto,80,130;x,-201);
		OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		OnCommand=cmd(player,PLAYER_1;diffuse,PlayerColor(PLAYER_1);diffusealpha,0;linear,0.35;diffusealpha,0.5;diffuseleftedge,0,0,0,0;);
		PlayerJoinedMessageCommand=cmd(playcommand,"On");
	};
	Def.Quad {
		InitCommand=cmd(zoomto,40,130;x,-141);
		OnCommand=cmd(player,PLAYER_1;diffuse,PlayerColor(PLAYER_1);diffusealpha,0;linear,0.35;diffusealpha,0.5;diffuserightedge,0,0,0,0;);
		OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		PlayerJoinedMessageCommand=cmd(playcommand,"On");
	};
	Def.Quad {
		InitCommand=cmd(zoomto,80,130;x,200);
		OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		OnCommand=cmd(player,PLAYER_2;diffuse,PlayerColor(PLAYER_2);diffusealpha,0;linear,0.35;diffusealpha,0.8;diffuserightedge,0,0,0,0;);
		PlayerJoinedMessageCommand=cmd(playcommand,"On");
	};
	Def.Quad {
		InitCommand=cmd(zoomto,40,130;x,140);
		OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		OnCommand=cmd(player,PLAYER_2;diffuse,PlayerColor(PLAYER_2);diffusealpha,0;linear,0.35;diffusealpha,0.8;diffuseleftedge,0,0,0,0;);
		PlayerJoinedMessageCommand=cmd(playcommand,"On");
	};
};

for diff=0,6 do
	t[#t+1]=Def.ActorFrame{
		Def.Quad {
			InitCommand=function(self)
				self:zoomto(360,2);
				self:x(0);
				self:y((diff-3)*h);
				self:diffuse(Color("White"));
				self:diffusealpha(0.8);
				self:fadeleft(1);
				self:faderight(1);
			end;
			OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		};
	};
end;

for d=1,6 do
	t[#t+1]=Def.ActorFrame{
		InitCommand=function(self)
			self:y((d-3)*h-h/2);
		end;
		CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
		CurrentTrailP1ChangedMessageCommand=cmd(queuecommand,"Set");
		CurrentTrailP2ChangedMessageCommand=cmd(queuecommand,"Set");
		CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set");
		CurrentStepsP2ChangedMessageCommand=cmd(queuecommand,"Set");
		OnCommand=cmd(zoomx,2;zoomy,0;linear,0.2;zoomx,1;zoomy,1;queuecommand,"Set");
		OffCommand=cmd(linear,0.2;zoomx,2;zoomy,0;);
		SetCommand=function(self)
			song=_SONG();
			if song then
				st=song:GetOneSteps(stt,Difficulty[d]);
				dif=Difficulty[d];
			else
				st=nil;
				dif=nil;
			end;
			self:queuecommand('Set2');
		end;
		LoadFont("waiei1 main")..{
			InitCommand=function(self)
				self:horizalign(left);
				self:x(-42);
				self:y(-1);
			end;
			Set2Command=function(self)
				if IsEXFolder() and not GetEXFSongState_Difficulty(GetEXFCurrentSong())[d] then
					self:diffuse(1,1,1,0.2);
				elseif song and song:HasStepsTypeAndDifficulty(stt, Difficulty[d]) then
					self:diffuse(_DifficultyLightCOLOR2(difcolor,Difficulty[d]));
				else
					self:diffuse(1,1,1,0.2);
				end;
				self:zoom(0.6);
				self:maxwidth((65)/0.6);
				self:strokecolor(Color("Outline"));
				--[[
				if Difficulty[d]=='Difficulty_Edit' then
					local st=GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber());
					if st then
						self:settext(st:GetDescription());
					else
						self:settext(string.upper(_DifficultyNAME2(difname,Difficulty[d])));
					end;
				else
				--]]
					self:settext(string.upper(_DifficultyNAME2(difname,Difficulty[d])));
				--end;
			end;
		};
		LoadFont("waiei1 main")..{
			InitCommand=function(self)
				self:horizalign(right);
				self:x(45);
				self:y(-1);
				self:zoom(0.65);
				self:maxwidth(20/0.65);
			end;
			Set2Command=function(self)
				self:strokecolor(Color("Outline"));
				if IsEXFolder() and not GetEXFSongState_Difficulty(GetEXFCurrentSong())[d] then
					self:diffuse(1,1,1,0.2);
					self:settext("--");
				elseif song and song:HasStepsTypeAndDifficulty(stt, Difficulty[d]) then
					if GetEXFCurrentSong_ShowStepInfo() then
						local m=GetSongs(song,stt..'-'..Difficulty[d]) or "Err";
						self:settext(m);
					else
						self:settext("--");
					end;
					self:diffuse(_DifficultyLightCOLOR2(difcolor,Difficulty[d]));
				else
					self:diffuse(1,1,1,0.2);
					self:settext("--");
				end;
			end;
		};
	};
end;

return t;