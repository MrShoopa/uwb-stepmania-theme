local pn,difcolor,difname,meter_type=...;
local t=Def.ActorFrame{};
local GradeVar = {
	Grade_Tier01 = 0;
	Grade_Tier02 = 1;
	Grade_Tier03 = 2;
	Grade_Tier04 = 3;
	Grade_Tier05 = 4;
	Grade_Tier06 = 5;
	Grade_Tier07 = 6;
	Grade_Tier08 = 7;
	Grade_Tier09 = 8;
	Grade_Tier10 = 9;
	Grade_Tier11 = 10;
	Grade_Tier12 = 11;
	Grade_Tier13 = 12;
	Grade_Tier14 = 13;
	Grade_Tier15 = 14;
	Grade_Tier16 = 15;
	Grade_Tier17 = 16;
	Grade_Tier18 = 17;
	Grade_Tier19 = 18;
	Grade_Tier20 = 19;
	Grade_Failed = 20;
};
local song=nil;
local dif=nil;
local st=nil;
local cdif=nil;
local cst=nil;
local stt=GAMESTATE:GetCurrentStyle():GetStepsType();
local dp=0;
local sc=0;
local gr=99;
local h=14;	--[ja] 1ラインの高さ 
t[#t+1]=Def.ActorFrame{
	--[[
	LoadActor("pane base")..{
		InitCommand=function(self)
			self:diffuse(0,0,0.2,0.5);
		end;
	};
	--]]
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(250,92);
			self:fadeleft((pn==PLAYER_1) and 0.2 or 0);
			self:faderight((pn==PLAYER_1) and 0 or 0.2);
			self:diffuse(0,0,0,0.66);
			self:horizalign((pn==PLAYER_1) and right or left);
			self:x((pn==PLAYER_1) and 70 or -70);
		end;
	};
	Def.Quad{
		InitCommand=function(self)
			self:horizalign((pn==PLAYER_1) and right or left);
			self:x((pn==PLAYER_1) and 68 or -68);
			self:zoomto(32,88)
			self:diffuse(BoostColor(PlayerColor(pn),0.5));
			self:blend("BlendMode_Add");
		end;
	};
	LoadActor("pane over")..{
		InitCommand=function(self)
			self:horizalign((pn==PLAYER_1) and right or left);
			self:x((pn==PLAYER_1) and 80 or -80);
		end;
	};
};
for d=1,6 do
	t[#t+1]=Def.ActorFrame{
		InitCommand=function(self)
			self:y(-h/2-h*2+h*(d-1));
		end;
		CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
		CurrentTrailP1ChangedMessageCommand=cmd(queuecommand,"Set");
		CurrentTrailP2ChangedMessageCommand=cmd(queuecommand,"Set");
		CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set");
		CurrentStepsP2ChangedMessageCommand=cmd(queuecommand,"Set");
		OnCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			if IsEXFolder() then
				song=GetEXFSongState_Song(GetEXFCurrentSong());
			else
				song=_SONG();
			end;
			if song then
				st=song:GetOneSteps(stt,Difficulty[d]);
				dif=Difficulty[d];
				cst=GAMESTATE:GetCurrentSteps(pn);
				if cst then
					cdif=cst:GetDifficulty();
				end;
			else
				st=nil;
				dif=nil;
				cst=nil;
				cdif=nil;
			end;
			dp=0;
			sc=0;
			gr=99;
			if (song and st) then
				local pro;
				if PROFILEMAN:IsPersistentProfile(pn) then
					-- player profile
					pro=PROFILEMAN:GetProfile(pn);
				else
					-- machine profile
					pro=PROFILEMAN:GetMachineProfile();
				end;
				if pro then
					local SongOrCourse=song;
					local StepOrTrail=st;
					local hiscore=pro:GetHighScoreList(SongOrCourse,StepOrTrail):GetHighScores();
					for h=1,#hiscore do
						if hiscore[h]:GetPercentDP()*100>dp then
							dp=hiscore[h]:GetPercentDP()*100;
							sc=hiscore[h]:GetScore();
						end;
					end;
					-- Grade
					gr=99;
					for h=1,#hiscore do
						if GradeVar[hiscore[h]:GetGrade()]<gr then
							gr=GradeVar[hiscore[h]:GetGrade()];
						end;
					end;
					-- FullCombo
					fc="";
					local fcpoint=0;
					local chk='';
					for h=1,#hiscore do
						local j_ms=hiscore[h]:GetTapNoteScore('TapNoteScore_Miss');
						local j_w2=hiscore[h]:GetTapNoteScore('TapNoteScore_W2');
						local j_w3=hiscore[h]:GetTapNoteScore('TapNoteScore_W3');
						local j_w4=hiscore[h]:GetTapNoteScore('TapNoteScore_W4');
						local j_w5=hiscore[h]:GetTapNoteScore('TapNoteScore_W5');
						local j_ng=hiscore[h]:GetHoldNoteScore('HoldNoteScore_LetGo');
						local j_ht=hiscore[h]:GetTapNoteScore('TapNoteScore_HitMine');
						local j_cm=hiscore[h]:GetMaxCombo();
						local j_gd=hiscore[h]:GetGrade();
						local j_th=hiscore[h]:GetRadarValues():GetValue('RadarCategory_TapsAndHolds');
						local j_jp=j_th+hiscore[h]:GetRadarValues():GetValue('RadarCategory_Jumps');
						local j_sc=hiscore[h]:GetScore();
						local j_chk=j_ms+j_w5+j_ng+j_ht;
						if GradeVar[j_gd]~=20 and j_sc>0 then
							if j_chk+j_w4+j_w3+j_w2==0 and fcpoint<4 then
								fc="JudgmentLine_W1";
								fcpoint=4;
								break;
							elseif j_chk+j_w4+j_w3==0 and fcpoint<3 then
								fc="JudgmentLine_W2";
								fcpoint=3;
							elseif j_chk+j_w4==0 and fcpoint<2 then
								fc="JudgmentLine_W3";
								fcpoint=2;
							elseif j_chk==0 and fcpoint<1 then
								fc="JudgmentLine_W4";
								fcpoint=1;
							end;
						end;
					end;
				end;
			end;
			self:queuecommand('Set2');
		end;
		Def.Quad{
			InitCommand=function(self)
				self:horizalign((pn==PLAYER_1) and left or right);
				self:x((pn==PLAYER_1) and -65 or 65);
				self:zoomto(100,h+2)
				if pn==PLAYER_1 then
					self:fadeleft(0.8);
				else
					self:faderight(0.8);
				end;
				--self:faderight(1);
				--self:diffuse(PlayerColor(pn));
				self:blend("BlendMode_Add");
			end;
			Set2Command=function(self)
				if song and song:HasStepsTypeAndDifficulty(stt, Difficulty[d]) then
					if Difficulty[d]==dif then
						self:diffuse(_DifficultyCOLOR2(difcolor,Difficulty[d]));
					else
						self:diffuse(1,1,1,0.5);
					end;
				else
					self:diffuse(1,1,1,0.5);
				end;
				if Difficulty[d]==cdif and song then
					self:visible(true);
				else
					self:visible(false);
				end;
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(left);
				self:x((pn==PLAYER_1) and -65 or -30);
			end;
			Set2Command=function(self)
				if IsEXFolder() and not GetEXFSongState_Difficulty(GetEXFCurrentSong())[d] then
					self:zoom(0.5);
					self:maxwidth((70)/0.5);
					self:diffuse(1,1,1,0.2);
					self:strokecolor(Color("Outline"));
				elseif song and song:HasStepsTypeAndDifficulty(stt, Difficulty[d]) then
					if Difficulty[d]==cdif then
						self:zoom(0.55);
						self:maxwidth((70)/0.55);
						self:diffuse(BoostColor(_DifficultyCOLOR2(difcolor,Difficulty[d]),0.66));
						self:strokecolor(Color("White"));
					else
						self:zoom(0.5);
						self:maxwidth((70)/0.5);
						self:diffuse(_DifficultyLightCOLOR2(difcolor,Difficulty[d]));
						self:diffusealpha(0.6);
						self:strokecolor(Color("Outline"));
					end;
					self:settext(string.upper(_DifficultyNAME2(difname,Difficulty[d])));
				else
					self:zoom(0.5);
					self:maxwidth((70)/0.5);
					self:diffuse(1,1,1,0.2);
					self:strokecolor(Color("Outline"));
				end;
				self:settext(string.upper(_DifficultyNAME2(difname,Difficulty[d])));
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(right);
				self:x((pn==PLAYER_1) and 30 or 65);
				self:zoom(0.6);
				self:maxwidth(20/0.6);
			end;
			Set2Command=function(self)
				if IsEXFolder() and not GetEXFSongState_Difficulty(GetEXFCurrentSong())[d] then
					self:diffuse(1,1,1,0.2);
					self:settext("--");
					self:strokecolor(Color("Outline"));
				elseif song and song:HasStepsTypeAndDifficulty(stt, Difficulty[d]) then
					if GetEXFCurrentSong_ShowStepInfo() then
						local m=GetSongs(song,stt..'-'..Difficulty[d]) or "Err";
						self:settext(m);
					else
						self:settext("--");
					end;
					if Difficulty[d]==cdif and song then
						self:diffuse(BoostColor(_DifficultyCOLOR2(difcolor,Difficulty[d]),0.8));
						self:strokecolor(Color("White"));
					else
						self:diffuse(_DifficultyLightCOLOR2(difcolor,Difficulty[d]));
						self:diffusealpha(0.6);
						self:strokecolor(Color("Outline"));
					end;
				else
					self:diffuse(1,1,1,0.2);
					self:settext("--");
					self:strokecolor(Color("Outline"));
				end;
			end;
		};
		LoadActor(THEME:GetPathG("_GradeDisplay Small/GradeDisplayEval","List"))..{
			InitCommand=function(self)
				self:x((pn==PLAYER_1) and 50 or -55);
				self:animate(false);
				self:setstate(0);
			end;
			Set2Command=function(self)
				if (IsEXFolder() and not GetEXFSongState_Difficulty(GetEXFCurrentSong())[d])
					or not GetEXFCurrentSong_ShowHiScore() then
					self:setstate(0);
				elseif song and Difficulty[d]==dif then
					if song and ((gr<99 and sc>0) or gr==20) then
						self:setstate(math.min(gr+1,8));
					else
						self:setstate(0);
					end;
				else
					self:setstate(0);
				end;
			end;
		};
		LoadActor(THEME:GetPathG("_GradeDisplay Small/_ScreenSelectMusic","FullCombo"))..{
			InitCommand=function(self)
				self:x((pn==PLAYER_1) and 65 or -40);
				self:y(1);
				self:shadowlength(1);
				self:animate(false);
				self:setstate(0);
			end;
			Set2Command=function(self)
				if (IsEXFolder() and not GetEXFSongState_Difficulty(GetEXFCurrentSong())[d])
					or not GetEXFCurrentSong_ShowHiScore() then
					self:setstate(0);
					self:diffuse(1.0,1.0,1.0,0);
				else
					if song and Difficulty[d]==dif then
						if sc>0 and (song or course) then
							if fc=="JudgmentLine_W1" then
								self:setstate(1);
								self:diffuse(GameColor.Judgment["JudgmentLine_W1"]);
								self:glowblink();
								self:effectperiod(0.20);
								self:zoom(1);
							elseif fc=="JudgmentLine_W2" then
								self:setstate(1);
								self:diffuse(GameColor.Judgment["JudgmentLine_W2"]);
								self:glowshift();
								self:zoom(0.8);
							elseif fc=="JudgmentLine_W3" then
								self:setstate(1);
								self:diffuse(GameColor.Judgment["JudgmentLine_W3"]);
								self:stopeffect();
								self:zoom(0.6);
							elseif fc=="JudgmentLine_W4" then
								self:setstate(2);
								self:diffuse(BoostColor(GameColor.Judgment["JudgmentLine_W4"],1.5));
								self:stopeffect();
								self:zoom(1);
							else
								self:setstate(0);
								self:diffuse(1.0,1.0,1.0,0);
							end;
						else
							self:setstate(0);
							self:diffuse(1.0,1.0,1.0,0);
						end;
					else
						self:setstate(0);
						self:diffuse(1.0,1.0,1.0,0);
					end;
				end;
			end;
		};
	};
end;
return t;