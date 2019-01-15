local difname=GetUserPref_Theme("UserDifficultyName");
local t = Def.ActorFrame{
		-- [ja] Rouletteホイール内だけきちんと取得できる謎 
		SetCommand=function(self,params)
			if params.HasFocus then
				if params.Song then
					wh_SetCurrentType("Song");
					wh_SetCurrentSong(params.Song);
				elseif params.Label and params.Label~="" then
					if params.Label=="Return" then
						wh_SetCurrentType("Custom");
						wh_SetCurrentLabel("Return");
					elseif params.Label=="EXFolder" then
						wh_SetCurrentType("Custom");
						wh_SetCurrentLabel("EXFolder");
					else
						wh_SetCurrentType("Mode");
						local n='';
						if string.find(params.Label,'Beginner',0,true) then
							n=string.gsub(params.Label,'Begginer',_DifficultyNAME2(difname,'Difficulty_Beginner'));
						elseif string.find(params.Label,'Easy',0,true) then
							n=string.gsub(params.Label,'Easy',_DifficultyNAME2(difname,'Difficulty_Easy'));
						elseif string.find(params.Label,'Medium',0,true) then
							n=string.gsub(params.Label,'Medium',_DifficultyNAME2(difname,'Difficulty_Medium'));
						elseif string.find(params.Label,'Hard',0,true) then
							n=string.gsub(params.Label,'Hard',_DifficultyNAME2(difname,'Difficulty_Hard'));
						elseif string.find(params.Label,'Challenge',0,true) then
							n=string.gsub(params.Label,'Challenge',_DifficultyNAME2(difname,'Difficulty_Challenge'));
						else
							n=params.Label;
						end;
						wh_SetCurrentLabel(n);
					end;
				elseif params.Text and params.Text~="" then
					wh_SetCurrentType("Folder");
					wh_SetCurrentLabel(params.Text);
					--wh_SetCurrentLabel(GetGroups(params.Text,"name") or params.Text);
				else
					wh_SetCurrentType("Roulette");
					wh_SetCurrentLabel("Roulette");
				end;
			end;
		end;
--[[
	Def.Quad{
		--InitCommand=cmd(x,-2;);
		InitCommand=cmd(playcommand,"Set");
		SetMessageCommand=function(self,params)
			--self:Load( THEME:GetPathG("_MusicWheel","BannerFrame color"));
			self:zoomto(256,256);
			self:diffuse(0,0,0.2,1.0);
		end;
	};
	LoadActor(THEME:GetPathG("_wheel/roulette","jacket"))..{
	};
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:maxwidth(256/1.5);
			self:zoom(1.5);
			self:diffuse(1.0,0.6,0.8,1.0);
			self:strokecolor(Color("Black"));
		end;
		SetMessageCommand=function(self,params)
			self:stoptweening();
			self:settext("Random");
			self:y(-163);
			if params.HasFocus then
				self:diffusealpha(0);
			else
				self:diffusealpha(1);
			end;
			--self:strokecolor(Color("White"));
			--self:shadowlength(1);
		end;
	};
	--]]
};
return t;