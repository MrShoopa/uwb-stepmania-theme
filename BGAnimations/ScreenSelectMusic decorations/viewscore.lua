local t=Def.ActorFrame{};

--[ja] 表示フラグ用変数
local draw_f={false,false};
local draw_a=0.2;
local draw_h=120;

local song;

for pn in ivalues(PlayerNumber) do
	local jd={W1=0,W2=0,W3=0,W4=0,W5=0,
		Miss=0,Held=0,MaxCombo=0,NG=0,Taps=0,LN=0};
	local jdp={W1=0,W2=0,W3=0,W4=0,W5=0,
		Miss=0,Held=0,NG=0};
	local p=(pn==PLAYER_1) and 1 or 2;
	t[#t+1]=Def.ActorFrame{
		CodeCommand=function(self, params)
			self:finishtweening();
			if pn==params.PlayerNumber then
				if params.Name=="ViewScore" then
					if draw_f[p] then
						draw_f[p]=false;
						self:queuecommand("Hidden");
					else
						draw_f[p]=true;
						self:queuecommand("Draw");
						self:queuecommand("ReadScore");
					end;
				end;
			end;
		end;
		InitCommand=cmd(playcommand,"Hidden";
			y,THEME:GetMetric("ScreenSelectMusic","MusicWheelY")+65;);
		HiddenCommand=cmd(zoomy,1;linear,draw_a;zoomy,0);
		DrawCommand=cmd(zoomy,0;linear,draw_a;zoomy,1);
		FolderCommand=cmd(zoomy,0);
		SongCommand=cmd(zoomy,1);
		OffCommand=function(self)
			if draw_f[p] then
				self:playcommand("Hidden");
			end;
		end;
		--[ja] ついでなので読み込み処理もここでしておこう、うん 
		CurrentSongChangedMessageCommand=cmd(playcommand,"ReadScore");
		CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
		PlayerJoinedMessageCommand=cmd(playcommand,"Set");
		SetCommand=cmd(finishtweening;sleep,0.3;queuecommand,"ReadScore");
		ReadScoreCommand=function(self)
			if draw_f[p] then
				song=_SONG();
				if not song then
					self:queuecommand("Folder");
					jd["Taps"]=0;
					jd["LN"]=0;
					jd["MaxCombo"]=0;
					jd["W1"]=0;
					jd["W2"]=0;
					jd["W3"]=0;
					jd["W4"]=0;
					jd["W5"]=0;
					jd["Miss"]=0;
					jd["Held"]=0;
					jd["NG"]=0;
				else
					self:queuecommand("Song");
					if PROFILEMAN:IsPersistentProfile(pn) then
						profile = PROFILEMAN:GetProfile(pn);
					else
						profile = PROFILEMAN:GetMachineProfile();
					end;
					scorelist = profile:GetHighScoreList(song,GAMESTATE:GetCurrentSteps(pn)):GetHighScores();
					hiscore=GetScoreData(scorelist,"hiscore");
					jd={W1=0,W2=0,W3=0,W4=0,W5=0,Miss=0,Held=0,MaxCombo=0,NG=0,Taps=0,LN=0};
					jdp={W1=0,W2=0,W3=0,W4=0,W5=0,Miss=0,Held=0,NG=0};
					if hiscore then
						jd["MaxCombo"]=GetScoreData(scorelist,"maxcombo");
						jd["W1"]=hiscore:GetTapNoteScore('TapNoteScore_W1');
						jd["W2"]=hiscore:GetTapNoteScore('TapNoteScore_W2');
						jd["W3"]=hiscore:GetTapNoteScore('TapNoteScore_W3');
						jd["W4"]=hiscore:GetTapNoteScore('TapNoteScore_W4');
						jd["W5"]=hiscore:GetTapNoteScore('TapNoteScore_W5');
						jd["Miss"]=hiscore:GetTapNoteScore('TapNoteScore_Miss');
						jd["Held"]=hiscore:GetHoldNoteScore('HoldNoteScore_Held');
						jd["NG"]=hiscore:GetHoldNoteScore('HoldNoteScore_LetGo');
					end;
					jd["Taps"]=math.max(yaGetRD( pn, 'RadarCategory_TapsAndHolds'),1);
					jd["LN"]=math.max(yaGetRD( pn, 'RadarCategory_Holds')+yaGetRD( pn, 'RadarCategory_Rolls'),1);
					jdp["W1"]=math.min(draw_h*jd["W1"]/jd["Taps"],draw_h);
					jdp["W2"]=math.min(draw_h*jd["W2"]/jd["Taps"],draw_h);
					jdp["W3"]=math.min(draw_h*jd["W3"]/jd["Taps"],draw_h);
					jdp["W4"]=math.min(draw_h*jd["W4"]/jd["Taps"],draw_h);
					jdp["W5"]=math.min(draw_h*jd["W5"]/jd["Taps"],draw_h);
					jdp["Miss"]=math.min(draw_h*jd["Miss"]/jd["Taps"],draw_h);
					jdp["Held"]=math.min(draw_h*jd["Held"]/jd["LN"],draw_h);
					jdp["NG"]=math.min(draw_h*jd["NG"]/jd["LN"],draw_h);
				end;
			end;
		end;

		Def.Quad{
			InitCommand=cmd(zoomto,180,140;
				horizalign,(pn==PLAYER_1) and left or right;vertalign,top;
				diffuse,Color("Black");
				x,(pn==PLAYER_1) and SCREEN_LEFT or SCREEN_RIGHT;
				fadeleft,(pn==PLAYER_1) and 0 or 0.5;
				faderight,(pn==PLAYER_1) and 0.5 or 0;);
			HiddenCommand=cmd(linear,draw_a;diffusealpha,0;);
			DrawCommand=cmd(linear,draw_a;diffusealpha,0.8;);
		};
		
		--[[
		LoadFont("Common Normal")..{
			InitCommand=cmd(diffuse,GameColor.Judgment["JudgmentLine_W1"];
				strokecolor,Color("Outline");maxwidth,100;
				horizalign,(pn==PLAYER_1) and left or right;vertalign,top;
				zoom,0.75;y,10;
				x,(pn==PLAYER_1) and SCREEN_LEFT+30 or SCREEN_RIGHT-30;
				settext,"Loading");
			SetCommand=cmd(settext,"Loading");
			ReadScoreCommand=cmd(settext,_JudgementLabel("JudgmentLine_W1"));
		};
		--]]

		Def.Quad{
			InitCommand=cmd(zoomto,8,draw_h+2;
				horizalign,(pn==PLAYER_1) and left or right;vertalign,top;
				diffuse,Color("Black");
				x,(pn==PLAYER_1) and SCREEN_LEFT+4 or SCREEN_RIGHT-4
				y,9);
		};

		Def.Quad{
			InitCommand=cmd(zoomto,8,draw_h+2;
				horizalign,(pn==PLAYER_1) and left or right;vertalign,top;
				diffuse,Color("Black");
				x,(pn==PLAYER_1) and SCREEN_LEFT+14 or SCREEN_RIGHT-14
				y,9);
		};
		
		-- W1
		LoadFont("Common Normal")..{
			InitCommand=cmd(diffuse,GameColor.Judgment["JudgmentLine_W1"];
				strokecolor,Color("Outline");maxwidth,100;
				horizalign,right;vertalign,top;
				zoom,0.75;y,10;
				x,(pn==PLAYER_1) and SCREEN_LEFT+105 or SCREEN_RIGHT-81;
				settext,"Loading");
			SetCommand=cmd(vertalign,top;
				horizalign,(pn==PLAYER_1) and left or right;
				x,(pn==PLAYER_1) and SCREEN_LEFT+30 or SCREEN_RIGHT-30;
				settext,"Loading");
			ReadScoreCommand=cmd(horizalign,right;vertalign,top;
				x,(pn==PLAYER_1) and SCREEN_LEFT+105 or SCREEN_RIGHT-81;
				settext,_JudgementLabel("JudgmentLine_W1"));
		};
		LoadFont("Common Normal")..{
			InitCommand=cmd(diffuse,GameColor.Judgment["JudgmentLine_W1"];
				strokecolor,Color("Outline");maxwidth,60;
				horizalign,left;vertalign,top;
				zoom,0.6;y,13;
				x,(pn==PLAYER_1) and SCREEN_LEFT+120 or SCREEN_RIGHT-66;
				settext,"");
			SetCommand=cmd(settext,"");
			ReadScoreCommand=cmd(settextf,"%04d",jd["W1"]);
		};
		Def.Quad{
			InitCommand=cmd(zoomto,6,1;
				horizalign,(pn==PLAYER_1) and left or right;vertalign,top;
				diffuse,Color("Black");
				x,(pn==PLAYER_1) and SCREEN_LEFT+5 or SCREEN_RIGHT-5);
			SetCommand=cmd(zoom,0;);
			ReadScoreCommand=cmd(zoomto,6,jdp["W1"];
				horizalign,(pn==PLAYER_1) and left or right;vertalign,top;
				diffuse,GameColor.Judgment["JudgmentLine_W1"];
				y,10+draw_h-jdp["Miss"]-jdp["W5"]-jdp["W4"]-jdp["W3"]-jdp["W2"]-jdp["W1"]);
		};
		
		-- W2
		LoadFont("Common Normal")..{
			InitCommand=cmd(diffuse,GameColor.Judgment["JudgmentLine_W2"];
				strokecolor,Color("Outline");maxwidth,100;
				horizalign,right;vertalign,top;
				zoom,0.75;y,25;
				x,(pn==PLAYER_1) and SCREEN_LEFT+105 or SCREEN_RIGHT-81;
				settext,"");
			SetCommand=cmd(settext,"");
			ReadScoreCommand=cmd(settext,_JudgementLabel("JudgmentLine_W2"));
		};
		LoadFont("Common Normal")..{
			InitCommand=cmd(diffuse,GameColor.Judgment["JudgmentLine_W2"];
				strokecolor,Color("Outline");maxwidth,60;
				horizalign,left;vertalign,top;
				zoom,0.6;y,28;
				x,(pn==PLAYER_1) and SCREEN_LEFT+120 or SCREEN_RIGHT-66;
				settext,"");
			SetCommand=cmd(settext,"");
			ReadScoreCommand=cmd(settextf,"%04d",jd["W2"]);
		};
		Def.Quad{
			InitCommand=cmd(zoomto,6,1;
				horizalign,(pn==PLAYER_1) and left or right;vertalign,top;
				diffuse,Color("Black");
				x,(pn==PLAYER_1) and SCREEN_LEFT+5 or SCREEN_RIGHT-5);
			SetCommand=cmd(zoom,0;);
			ReadScoreCommand=cmd(zoomto,6,jdp["W2"];
				horizalign,(pn==PLAYER_1) and left or right;vertalign,top;
				diffuse,GameColor.Judgment["JudgmentLine_W2"];
				y,10+draw_h-jdp["Miss"]-jdp["W5"]-jdp["W4"]-jdp["W3"]-jdp["W2"]);
		};
		
		-- W3
		LoadFont("Common Normal")..{
			InitCommand=cmd(diffuse,GameColor.Judgment["JudgmentLine_W3"];
				strokecolor,Color("Outline");maxwidth,100;
				horizalign,right;vertalign,top;
				zoom,0.75;y,40;
				x,(pn==PLAYER_1) and SCREEN_LEFT+105 or SCREEN_RIGHT-81;
				settext,"");
			SetCommand=cmd(settext,"");
			ReadScoreCommand=cmd(settext,_JudgementLabel("JudgmentLine_W3"));
		};
		LoadFont("Common Normal")..{
			InitCommand=cmd(diffuse,GameColor.Judgment["JudgmentLine_W3"];
				strokecolor,Color("Outline");maxwidth,60;
				horizalign,left;vertalign,top;
				zoom,0.6;y,43;
				x,(pn==PLAYER_1) and SCREEN_LEFT+120 or SCREEN_RIGHT-66;
				settext,"");
			SetCommand=cmd(settext,"");
			ReadScoreCommand=cmd(settextf,"%04d",jd["W3"]);
		};
		Def.Quad{
			InitCommand=cmd(zoomto,6,1;
				horizalign,(pn==PLAYER_1) and left or right;vertalign,top;
				diffuse,Color("Black");
				x,(pn==PLAYER_1) and SCREEN_LEFT+5 or SCREEN_RIGHT-5);
			SetCommand=cmd(zoom,0;);
			ReadScoreCommand=cmd(zoomto,6,jdp["W3"];
				horizalign,(pn==PLAYER_1) and left or right;vertalign,top;
				diffuse,GameColor.Judgment["JudgmentLine_W3"];
				y,10+draw_h-jdp["Miss"]-jdp["W5"]-jdp["W4"]-jdp["W3"]);
		};
		
		-- W4
		LoadFont("Common Normal")..{
			InitCommand=cmd(diffuse,BoostColor(GameColor.Judgment["JudgmentLine_W4"],1.5);
				strokecolor,Color("Outline");maxwidth,100;
				horizalign,right;vertalign,top;
				zoom,0.75;y,55;
				x,(pn==PLAYER_1) and SCREEN_LEFT+105 or SCREEN_RIGHT-81;
				settext,"");
			SetCommand=cmd(settext,"");
			ReadScoreCommand=cmd(settext,_JudgementLabel("JudgmentLine_W4"));
		};
		LoadFont("Common Normal")..{
			InitCommand=cmd(diffuse,BoostColor(GameColor.Judgment["JudgmentLine_W4"],1.5);
				strokecolor,Color("Outline");maxwidth,60;
				horizalign,left;vertalign,top;
				zoom,0.6;y,58;
				x,(pn==PLAYER_1) and SCREEN_LEFT+120 or SCREEN_RIGHT-66;
				settext,"");
			SetCommand=cmd(settext,"");
			ReadScoreCommand=cmd(settextf,"%04d",jd["W4"]);
		};
		Def.Quad{
			InitCommand=cmd(zoomto,6,1;
				horizalign,(pn==PLAYER_1) and left or right;vertalign,top;
				diffuse,Color("Black");
				x,(pn==PLAYER_1) and SCREEN_LEFT+5 or SCREEN_RIGHT-5);
			SetCommand=cmd(zoom,0;);
			ReadScoreCommand=cmd(zoomto,6,jdp["W4"];
				horizalign,(pn==PLAYER_1) and left or right;vertalign,top;
				diffuse,BoostColor(GameColor.Judgment["JudgmentLine_W4"],1.5);
				y,10+draw_h-jdp["Miss"]-jdp["W5"]-jdp["W4"]);
		};
		
		-- W5
		LoadFont("Common Normal")..{
			InitCommand=cmd(diffuse,BoostColor(GameColor.Judgment["JudgmentLine_W5"],1.5);
				strokecolor,Color("Outline");maxwidth,100;
				horizalign,right;vertalign,top;
				zoom,0.75;y,70;
				x,(pn==PLAYER_1) and SCREEN_LEFT+105 or SCREEN_RIGHT-81;
				settext,"");
			SetCommand=cmd(settext,"");
			ReadScoreCommand=cmd(settext,_JudgementLabel("JudgmentLine_W5"));
		};
		LoadFont("Common Normal")..{
			InitCommand=cmd(diffuse,BoostColor(GameColor.Judgment["JudgmentLine_W5"],1.5);
				strokecolor,Color("Outline");maxwidth,60;
				horizalign,left;vertalign,top;
				zoom,0.6;y,73;
				x,(pn==PLAYER_1) and SCREEN_LEFT+120 or SCREEN_RIGHT-66;
				settext,"");
			SetCommand=cmd(settext,"");
			ReadScoreCommand=cmd(settextf,"%04d",jd["W5"]);
		};
		Def.Quad{
			InitCommand=cmd(zoomto,6,1;
				horizalign,(pn==PLAYER_1) and left or right;vertalign,top;
				diffuse,Color("Black");
				x,(pn==PLAYER_1) and SCREEN_LEFT+5 or SCREEN_RIGHT-5);
			SetCommand=cmd(zoom,0;);
			ReadScoreCommand=cmd(zoomto,6,jdp["W5"];
				horizalign,(pn==PLAYER_1) and left or right;vertalign,top;
				diffuse,BoostColor(GameColor.Judgment["JudgmentLine_W5"],1.5);
				y,10+draw_h-jdp["Miss"]-jdp["W5"]);
		};
		
		-- MISS
		LoadFont("Common Normal")..{
			InitCommand=cmd(diffuse,BoostColor(GameColor.Judgment["JudgmentLine_Miss"],1.5);
				strokecolor,Color("Outline");maxwidth,100;
				horizalign,right;vertalign,top;
				zoom,0.75;y,85;
				x,(pn==PLAYER_1) and SCREEN_LEFT+105 or SCREEN_RIGHT-81;
				settext,"");
			SetCommand=cmd(settext,"");
			ReadScoreCommand=cmd(settext,_JudgementLabel("JudgmentLine_Miss"));
		};
		LoadFont("Common Normal")..{
			InitCommand=cmd(diffuse,BoostColor(GameColor.Judgment["JudgmentLine_Miss"],1.5);
				strokecolor,Color("Outline");maxwidth,60;
				horizalign,left;vertalign,top;
				zoom,0.6;y,88;
				x,(pn==PLAYER_1) and SCREEN_LEFT+120 or SCREEN_RIGHT-66;
				settext,"");
			SetCommand=cmd(settext,"");
			ReadScoreCommand=cmd(settextf,"%04d",jd["Miss"]);
		};
		Def.Quad{
			InitCommand=cmd(zoomto,6,1;
				horizalign,(pn==PLAYER_1) and left or right;vertalign,top;
				diffuse,Color("Black");
				x,(pn==PLAYER_1) and SCREEN_LEFT+5 or SCREEN_RIGHT-5);
			SetCommand=cmd(zoom,0;);
			ReadScoreCommand=cmd(zoomto,6,jdp["Miss"];
				horizalign,(pn==PLAYER_1) and left or right;vertalign,top;
				diffuse,BoostColor(GameColor.Judgment["JudgmentLine_Miss"],1.5);
				y,10+draw_h-jdp["Miss"]);
		};
		
		-- HELD
		LoadFont("Common Normal")..{
			InitCommand=cmd(diffuse,BoostColor(GameColor.Judgment["JudgmentLine_Held"],1.5);
				strokecolor,Color("Outline");maxwidth,100;
				horizalign,right;vertalign,top;
				zoom,0.75;y,100;
				x,(pn==PLAYER_1) and SCREEN_LEFT+105 or SCREEN_RIGHT-81;
				settext,"");
			SetCommand=cmd(settext,"");
			ReadScoreCommand=cmd(settext,_JudgementLabel("JudgmentLine_Held"));
		};
		LoadFont("Common Normal")..{
			InitCommand=cmd(diffuse,BoostColor(GameColor.Judgment["JudgmentLine_Held"],1.5);
				strokecolor,Color("Outline");maxwidth,60;
				horizalign,left;vertalign,top;
				zoom,0.6;y,103;
				x,(pn==PLAYER_1) and SCREEN_LEFT+120 or SCREEN_RIGHT-66;
				settext,"");
			SetCommand=cmd(settext,"");
			ReadScoreCommand=cmd(settextf,"%04d",jd["Held"]);
		};
		Def.Quad{
			InitCommand=cmd(zoomto,6,1;
				horizalign,(pn==PLAYER_1) and left or right;vertalign,top;
				diffuse,Color("Black");
				x,(pn==PLAYER_1) and SCREEN_LEFT+15 or SCREEN_RIGHT-15);
			SetCommand=cmd(zoom,0;);
			ReadScoreCommand=cmd(zoomto,6,jdp["Held"];
				horizalign,(pn==PLAYER_1) and left or right;vertalign,top;
				diffuse,Color("White");
				y,10+draw_h-jdp["NG"]-jdp["Held"]);
		};
		Def.Quad{
			InitCommand=cmd(zoomto,6,1;
				horizalign,(pn==PLAYER_1) and left or right;vertalign,top;
				diffuse,Color("Black");
				x,(pn==PLAYER_1) and SCREEN_LEFT+15 or SCREEN_RIGHT-15);
			SetCommand=cmd(zoom,0;);
			ReadScoreCommand=cmd(zoomto,6,jdp["NG"];
				horizalign,(pn==PLAYER_1) and left or right;vertalign,top;
				diffuse,Color("Orange");
				y,10+draw_h-jdp["NG"]);
		};
		
		-- COMBO
		LoadFont("Common Normal")..{
			InitCommand=cmd(diffuse,BoostColor(GameColor.Judgment["JudgmentLine_MaxCombo"],1.5);
				strokecolor,Color("Outline");maxwidth,100;
				horizalign,right;vertalign,top;
				zoom,0.75;y,115;
				x,(pn==PLAYER_1) and SCREEN_LEFT+105 or SCREEN_RIGHT-81;
				settext,"");
			SetCommand=cmd(settext,"");
			ReadScoreCommand=cmd(settext,_JudgementLabel("JudgmentLine_MaxCombo"));
		};
		LoadFont("Common Normal")..{
			InitCommand=cmd(diffuse,BoostColor(GameColor.Judgment["JudgmentLine_MaxCombo"],1.5);
				strokecolor,Color("Outline");maxwidth,60;
				horizalign,left;vertalign,top;
				zoom,0.6;y,118;
				x,(pn==PLAYER_1) and SCREEN_LEFT+120 or SCREEN_RIGHT-66;
				settext,"");
			SetCommand=cmd(settext,"");
			ReadScoreCommand=cmd(settextf,"%04d",jd["MaxCombo"]);
		};
		
	};
end;

return t;