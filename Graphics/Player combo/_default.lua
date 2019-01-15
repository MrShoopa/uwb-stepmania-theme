local c;
local cf;
local haishin=GetUserPref_Theme("UserHaishin");
local canAnimate = false;
local player = Var "Player";
local lsatWorstJudge={0,0};
local ShowComboAt = tonumber(THEME:GetMetric("Combo", "ShowComboAt")) or 2;
local MinCombo_=GetUserPref_Theme("UserMinCombo");
local MinCombo=(MinCombo_=='TapNoteScore_W3') and 3 or ((MinCombo_=='TapNoteScore_W1') and 1 or ((MinCombo_=='TapNoteScore_W2') and 2 or 4));
local Pulse = ((haishin=="Off") and THEME:GetMetric("Combo", "PulseCommand") or THEME:GetMetric("HaishinCombo", "PulseCommand"));
local PulseLabel = ((haishin=="Off") and THEME:GetMetric("Combo", "PulseLabelCommand") or THEME:GetMetric("HaishinCombo", "PulseLabelCommand"));

local NumberMinZoom = THEME:GetMetric("Combo", "NumberMinZoom");
local NumberMaxZoom = THEME:GetMetric("Combo", "NumberMaxZoom");
local NumberMaxZoomAt = THEME:GetMetric("Combo", "NumberMaxZoomAt");

local LabelMinZoom = THEME:GetMetric("Combo", "LabelMinZoom");
local LabelMaxZoom = THEME:GetMetric("Combo", "LabelMaxZoom");

local ShowFlashyCombo = GetUserPrefB("UserPrefFlashyCombo")

local p=((player=='PlayerNumber_P1') and 1 or 2);

local t = Def.ActorFrame {};

t[#t+1]=Def.ActorFrame {
	InitCommand=cmd(vertalign,bottom);
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
		cf.Label:visible(false);
		lsatWorstJudge[1]=0;
		lsatWorstJudge[2]=0;
	end;
	OffCommand=function(self)
		c = self:GetChildren();
		cf = c.ComboFrame:GetChildren();
		(cmd(stoptweening;sleep,0.3;linear,0.2;diffusealpha,0;))(cf.Number);
		(cmd(stoptweening;sleep,0.3;linear,0.2;diffusealpha,0;))(cf.Label);
	end;
	JudgmentMessageCommand = function(self, params)
		if not params.HoldNoteScore then
			if (params.Player==PLAYER_1 and p==1) or (params.Player==PLAYER_2 and p==2) then
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
			end;
		end;
	end;
	ComboCommand=function(self, params)
		local iCombo = params.Combo;

		local labeltext = "";
		if iCombo then
			labeltext = "COMBO";
-- 			c.Number:playcommand("Reset");
			if param.FullComboW1 then
				cf.Label:diffuse( GameColor.Judgment["JudgmentLine_W1"]);
			elseif params.FullComboW2 and MinCombo>=2 then
				cf.Label:diffuse( GameColor.Judgment["JudgmentLine_W2"]);
			elseif params.FullComboW3 and MinCombo>=3 then
				cf.Label:diffuse( GameColor.Judgment["JudgmentLine_W3"]);
			elseif params.FullComboW4 and MinCombo>=4 then
				cf.Label:diffuse( BoostColor(GameColor.Judgment["JudgmentLine_W4"],1.25));
			elseif params.Combo then
				cf.Label:diffuse(Color("White"));
			else
				cf.Label:diffuse(color("#ff0000"));
			end
			cf.Label:settext( labeltext );
			
			local DrawMaxZoom=((params.Combo<1000) and NumberMaxZoom or NumberMaxZoom*0.8);

			params.Zoom = scale( iCombo, 0, NumberMaxZoomAt, NumberMinZoom, DrawMaxZoom );
			params.Zoom = clamp( param.Zoom, NumberMinZoom, DrawMaxZoom );

			params.LabelZoom = scale( iCombo, 0, NumberMaxZoomAt, LabelMinZoom, LabelMaxZoom );
			params.LabelZoom = clamp( param.LabelZoom, LabelMinZoom, LabelMaxZoom );

			cf.Label:visible(true);

			cf.Number:finishtweening();
			cf.Number:visible(true);
			cf.Number:settext( string.format("%i", iCombo) );
		else
			cf.Label:visible(false);
			cf.Number:visible(false);
		end
		-- FullCombo Rewards
		--cf.Number:shadowcolor(0.5,1,1,0.3);
		--cf.Number:shadowlength(0);
		if params.Combo and lsatWorstJudge[p]==1 then
			cf.Number:diffuse( GameColor.Judgment["JudgmentLine_W1"] );
			--cf.Number:shadowlengthy(5);
		elseif params.Combo and lsatWorstJudge[p]==2 then
			cf.Number:diffuse( GameColor.Judgment["JudgmentLine_W2"] );
			cf.Number:glowshift();
		elseif params.Combo and lsatWorstJudge[p]==3 then
			cf.Number:diffuse( GameColor.Judgment["JudgmentLine_W3"] );
			cf.Number:glowshift();
		elseif params.Combo and lsatWorstJudge[p]==4 then
			cf.Number:diffuse( BoostColor(GameColor.Judgment["JudgmentLine_W4"],1.25));
			cf.Number:glowshift();
		elseif params.Combo then
			cf.Number:diffuse(Color("White"));
			cf.Number:stopeffect();
		else
			cf.Number:diffuse(color("#ff0000"));
			cf.Number:stopeffect();
		end
		-- Pulse
		Pulse( cf.Number, params );
		PulseLabel( cf.Label, params );
		-- Milestone Logic
	end;
--[[ 	ScoreChangedMessageCommand=function(self,param)
		local iToastyCombo = param.ToastyCombo;
		if iToastyCombo and (iToastyCombo > 0) then
-- 			(cmd(thump;effectmagnitude,1,1.2,1;effectclock,'beat'))(c.Number)
-- 			(cmd(thump;effectmagnitude,1,1.2,1;effectclock,'beat'))(c.Number)
		else
-- 			c.Number:stopeffect();
		end;
	end; --]]
};

return t;
