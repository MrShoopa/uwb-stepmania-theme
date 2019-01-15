local c;
local cf;
local haishin=GetUserPref_Theme("UserHaishin");
local hold_ng=THEME:GetMetric("Player", "ComboBreakOnImmediateHoldLetGo") or false;
local canAnimate = false;
local player = Var "Player";
local lsatWorstJudge={0,0};
local ShowComboAt = THEME:GetMetric("Combo", "ShowComboAt");
local MinCombo_=GetUserPref_Theme("UserMinCombo");
local MinCombo=(MinCombo_=='TapNoteScore_W3') and 3 or ((MinCombo_=='TapNoteScore_W1') and 1 or ((MinCombo_=='TapNoteScore_W2') and 2 or 4));
local Pulse = ((haishin=="Off") and THEME:GetMetric("Combo", "PulseCommand") or THEME:GetMetric("HaishinCombo", "PulseCommand"));
local PulseLabel = ((haishin=="Off") and THEME:GetMetric("Combo", "PulseLabelCommand") or THEME:GetMetric("HaishinCombo", "PulseLabelCommand"));

local NumberMinZoom = THEME:GetMetric("Combo", "NumberMinZoom");
local NumberMaxZoom = THEME:GetMetric("Combo", "NumberMaxZoom");
local NumberMaxZoomAt = THEME:GetMetric("Combo", "NumberMaxZoomAt");

local LabelMinZoom = THEME:GetMetric("Combo", "LabelMinZoom");
local LabelMaxZoom = THEME:GetMetric("Combo", "LabelMaxZoom");

local ShowFlashyCombo;

if GetUserPref_Theme("DF_FlashyCombos")
 and GetUserPref_Theme("DF_FlashyCombos")=='On' then
	ShowFlashyCombo=true;
else
	ShowFlashyCombo=false;
end;

local p=((player=='PlayerNumber_P1') and 1 or 2);

local t = Def.ActorFrame{};

t[#t+1]=Def.ActorFrame {
	Def.Quad{
		InitCommand=function(self)
			self:visible(false);
		end;
		JudgmentMessageCommand = function(self, param)
			if (param.Player==PLAYER_1 and p==1) or (param.Player==PLAYER_2 and p==2) then
				self:finishtweening();
				if param.TapNoteScore=='TapNoteScore_CheckpointMiss' 
					or (param.TapNoteScore=='TapNoteScore_W2' and MinCombo<2) 
					or (param.TapNoteScore=='TapNoteScore_W3' and MinCombo<3) 
					or (param.TapNoteScore=='TapNoteScore_W4' and MinCombo<4) 
					or param.TapNoteScore=='TapNoteScore_W5' 
					or param.TapNoteScore=='TapNoteScore_Miss' then
				end;
			end;
		end;
	};
};
t[#t+1]=Def.ActorFrame {
	InitCommand=cmd(vertalign,bottom;);
	-- flashy combo elements:
 	LoadActor(THEME:GetPathG("Combo","100Milestone")) .. {
		Name="OneHundredMilestone";
		InitCommand=cmd(visible,ShowFlashyCombo);
		FiftyMilestoneCommand=cmd(playcommand,"Milestone");
	};
	LoadActor(THEME:GetPathG("Combo","1000Milestone")) .. {
		Name="OneThousandMilestone";
		InitCommand=cmd(visible,ShowFlashyCombo);
		ToastyAchievedMessageCommand=cmd(playcommand,"Milestone");
	};
	-- normal combo elements:
	Def.ActorFrame {
		Name="ComboFrame";
		LoadFont( "Combo", "numbers" ) .. {
			Name="Number";
			OnCommand = THEME:GetMetric("Combo", "NumberOnCommand");
		};
		LoadFont("Common Normal") .. {
			Name="Label";
			OnCommand = THEME:GetMetric("Combo", "LabelOnCommand");
		};
	};
	InitCommand = function(self)
		c = self:GetChildren();
		cf = c.ComboFrame:GetChildren();
		cf.Number:visible(false);
		lsatWorstJudge[1]=0;
		lsatWorstJudge[2]=0;
	end;
	JudgmentMessageCommand = function(self, params)
		if (params.Player==PLAYER_1 and p==1) or (params.Player==PLAYER_2 and p==2) then
			self:finishtweening();
			if not params.HoldNoteScore then
				if params.FullComboW1 or (params.TapNoteScore=='TapNoteScore_W1' and lsatWorstJudge[p]<1) then
					lsatWorstJudge[p]=1;
				elseif (params.FullComboW2 or (params.TapNoteScore=='TapNoteScore_W2' and lsatWorstJudge[p]<2)) and MinCombo>=2 then
					lsatWorstJudge[p]=2;
				elseif (params.FullComboW3 or (params.TapNoteScore=='TapNoteScore_W3' and lsatWorstJudge[p]<3)) and MinCombo>=3 then
					lsatWorstJudge[p]=3;
				elseif (params.FullComboW4 or (params.TapNoteScore=='TapNoteScore_W4' and lsatWorstJudge[p]<4)) and MinCombo>=4 then
					lsatWorstJudge[p]=4;
				elseif params.TapNoteScore=='TapNoteScore_CheckpointMiss' 
					or (params.TapNoteScore=='TapNoteScore_W2' and MinCombo<2) 
					or (params.TapNoteScore=='TapNoteScore_W3' and MinCombo<3) 
					or (params.TapNoteScore=='TapNoteScore_W4' and MinCombo<4) 
					or params.TapNoteScore=='TapNoteScore_W5' 
					or params.TapNoteScore=='TapNoteScore_Miss' then
					lsatWorstJudge[p]=1;
				end;
			elseif hold_ng then
				--[ja] NG時コンボカット有効の時にカラーを初期化 
				if params.HoldNoteScore=='HoldNoteScore_LetGo' then
					lsatWorstJudge[p]=1;
				end;
			end;
		end;
	end;
	ComboCommand=function(self, param)
		self:finishtweening();
		local iCombo = param.Combo;
		if not iCombo or iCombo < ShowComboAt then
			cf.Number:visible(false);
			cf.Label:visible(false)
			return;
		end

		local labeltext = "";
		if param.Combo then
			labeltext = "COMBO";
			if param.FullComboW1 then
				cf.Label:diffuse( GameColor.Judgment["JudgmentLine_W1"]);
			elseif param.FullComboW2 and MinCombo>=2 then
				cf.Label:diffuse( GameColor.Judgment["JudgmentLine_W2"]);
			elseif param.FullComboW3 and MinCombo>=3 then
				cf.Label:diffuse( GameColor.Judgment["JudgmentLine_W3"]);
			elseif param.FullComboW4 and MinCombo>=4 then
				cf.Label:diffuse( BoostColor(GameColor.Judgment["JudgmentLine_W4"],1.25));
			elseif param.Combo then
				cf.Label:diffuse(Color("White"));
			else
				cf.Label:diffuse(color("#ff0000"));
			end
			cf.Label:strokecolor(Color("Outline"));
			cf.Label:settext( labeltext );
			
			local DrawMaxZoom=((param.Combo<1000) and NumberMaxZoom or NumberMaxZoom*0.8);

			param.Zoom = scale( iCombo, 0, NumberMaxZoomAt, NumberMinZoom, DrawMaxZoom );
			param.Zoom = clamp( param.Zoom, NumberMinZoom, DrawMaxZoom );

			param.LabelZoom = scale( iCombo, 0, NumberMaxZoomAt, LabelMinZoom, LabelMaxZoom );
			param.LabelZoom = clamp( param.LabelZoom, LabelMinZoom, LabelMaxZoom );

			cf.Label:finishtweening();
			cf.Label:visible(true);

			cf.Number:finishtweening();
			cf.Number:visible(true);
			cf.Number:settext( string.format("%i", iCombo) );
			if param.Combo and lsatWorstJudge[p]==1 then
				cf.Number:diffuse( GameColor.Judgment["JudgmentLine_W1"] );
				cf.Number:strokecolor(GameColor.Judgment["JudgmentLine_W1"]);
			elseif param.Combo and lsatWorstJudge[p]==2 then
				cf.Number:diffuse( GameColor.Judgment["JudgmentLine_W2"] );
				cf.Number:strokecolor(1.0,1.0,1.0,0.0);
			elseif param.Combo and lsatWorstJudge[p]==3 then
				cf.Number:diffuse( GameColor.Judgment["JudgmentLine_W3"] );
				cf.Number:strokecolor(1.0,1.0,1.0,0.0);
			elseif param.Combo and lsatWorstJudge[p]==4 then
				cf.Number:diffuse( BoostColor(GameColor.Judgment["JudgmentLine_W4"],1.25));
				cf.Number:strokecolor(1.0,1.0,1.0,0.0);
			elseif param.Combo then
				cf.Number:diffuse(Color("White"));
				cf.Number:strokecolor(1.0,1.0,1.0,0.0);
			else
				cf.Number:diffuse(color("#ff0000"));
				cf.Number:strokecolor(1.0,1.0,1.0,0.0);
			end

			cf.Label:x(TC_GetMetric("ComboLabel","PosX"));
			cf.Label:y(TC_GetMetric("ComboLabel","PosY"));
			cf.Number:x(TC_GetMetric("ComboNumber","PosX"));
			cf.Number:y(TC_GetMetric("ComboNumber","PosY"));
			-- Pulse
			Pulse( cf.Number, param );
			PulseLabel( cf.Label, param );
			-- Milestone Logic
		else
			cf.Label:finishtweening();
			cf.Label:visible(false);

			cf.Number:finishtweening();
			cf.Number:visible(false);
		end
	end;
};

return t;
