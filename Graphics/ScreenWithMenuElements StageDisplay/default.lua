
local stages = Def.ActorFrame {
	BeginCommand=cmd(playcommand,"Set";);
	CurrentSongChangedMessageCommand=cmd(finishtweening;playcommand,"Set";);
};

local ScreenName = Var "LoadingScreen";

function MakeBitmapTest()
	return LoadFont(ScreenName,"StageDisplay") .. {

	};
end

local Offset;
stages[#stages+1] = MakeBitmapTest() .. {
	SetCommand=function(self)
		if Var "LoadingScreen" then
			Offset = THEME:GetMetric(Var "LoadingScreen","StageDisplayNumberOffset");
		end;
		(cmd(sleep,0.1;queuecommand,"Set2"))(self);
	end;	
	Set2Command=function(self, params)
		if IsEXFolder() then
			local stage=GetEXFStage();
			if not stage or stage=="0" then
				stage=""..GetEXFolderStage();
			end;
			self:settext( "EXFolder "..stage );
			self:diffuse( StageToColor('Stage_Extra'..stage) );
			self:diffusebottomedge( ColorMidTone(StageToColor('Stage_Extra'..stage)) );
			--self:strokecolor( ColorDarkTone(StageToColor('Stage_Extra'..stage)) );
			self:shadowlength(1);
		elseif not PREFSMAN:GetPreference("EventMode") then
			local tRemap = {
				Stage_1st		= 1,
				Stage_2nd		= 2,
				Stage_3rd		= 3,
				Stage_4th		= 4,
				Stage_5th		= 5,
				Stage_6th		= 6,
--[[ 					'Stage_Next'	= 6,
				'Stage_Final'	= 7,
				'Stage_Extra1'	= 8,
				'Stage_Extra2'	= 9,
				'Stage_Nonstop'	= 10,
				'Stage_Oni'		= 11,
				'Stage_Endless'	= 12,
				'Stage_Event'	= 13,
				'Stage_Demo'	= 14, --]]
			}
			local Stage = GAMESTATE:GetCurrentStage();
			local StageIndex = GAMESTATE:GetCurrentStageIndex();
			local screen = SCREENMAN:GetTopScreen();
-- 				local cStageOutlineColor = ColorDarkTone( StageToStrokeColor(s) );
-- 				cStageOutlineColor[4] = 0.75;
			if screen and screen.GetStageStats then
				local ss = screen:GetStageStats();
				Stage = ss:GetStage();
				StageIndex = ss:GetStageIndex();
			end
			--self:visible( Stage == s );
			if tRemap[Stage] == PREFSMAN:GetPreference("SongsPerPlay") then
				Stage = 'Stage_Final';
			--else
			--	Stage = Stage;
			--	s = s;
			end;
			self:settext( string.format( THEME:GetString("ScreenWithMenuElements","StageCounter"), StageToLocalizedString(Stage) ) );
			self:diffuse( (Stage == 'Stage_Final') and StageToColor('Stage_Final') or StageToColor(Stage) );
			self:diffusebottomedge( (Stage == 'Stage_Final') and ColorMidTone(StageToColor('Stage_Final')) or ColorMidTone(StageToColor(Stage)) );
			--self:strokecolor( (Stage == 'Stage_Final') and ColorDarkTone(StageToColor('Stage_Final')) or ColorDarkTone(StageToColor(s)) );
			self:shadowlength(1);
		else
			local Stage = GAMESTATE:GetCurrentStageIndex();
			local RealStage = Stage + Offset;
			self:settextf( THEME:GetString("ScreenWithMenuElements","EventStageCounter"), RealStage );
			self:diffuse( StageToColor('Stage_1st') );
			self:diffusebottomedge( ColorMidTone(StageToColor('Stage_1st')) );
			--self:strokecolor( Color.Alpha( ColorDarkTone(StageToColor('Stage_1st')), 0.75) );
			self:shadowlength(1);
		end;
	end;
};

return stages;
