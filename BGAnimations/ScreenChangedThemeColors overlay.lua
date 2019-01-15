local t = Def.ActorFrame{
	Def.Actor{
		OnCommand=function(self)
			--[[
			local b=1;
			if not getenv("BGMTest") then
				setenv("BGMTest",b);
			else
				b=getenv("BGMTest");
				b=1-b;
				setenv("BGMTest",b);
			end;
			local f=SaveFile(THEME:GetCurrentThemeDirectory().."Sounds/_Music title.redir");
			f:Write("../ThemeColors/"..TC_Default().."/Sounds/_waiei"..(b+1).." Main");
			CloseFile(f);
			--]]
			local tc=TC_GetThemeStats();

			-- [ja] コンボカウント 
			local f=SaveFile(THEME:GetCurrentThemeDirectory().."Fonts/Combo numbers.redir");
			f:Write("waiei"..tc["Mode"].." Combo Numbers");
			CloseFile(f);
			
			-- [ja] スコア 
			local f=SaveFile(THEME:GetCurrentThemeDirectory().."Fonts/ScoreDisplayNormal Text.redir");
			if tc["Mode"]==2 then
				f:Write("../ThemeColors/"..TC_Default().."/Fonts/waiei2 Score Numbers");
			else
				f:Write("waiei1 Score Numbers");
			end;
			CloseFile(f);
			
			-- [ja] 基本フォント 
			local f=SaveFile(THEME:GetCurrentThemeDirectory().."Fonts/Common Normal.redir");
			if tc["Mode"]==2 then
				f:Write("_Montserrat");
			else
				f:Write("_Orbitron");
			end;
			CloseFile(f);

			TC_SetwaieiMode(tc["Mode"]);
			TC_SetPlayerColorMode(tc["PlayerColor"]);
			TC_Init(tc["Name"],tc["SubColor"]);
			
			-- [ja] Holdの判定表記（なぜかLuaで直接指定ができない） 
			local f=SaveFile(THEME:GetCurrentThemeDirectory().."Graphics/HoldJudgment label 1x2.redir");
			f:Write("../ThemeColors/"..split('ThemeColors/',TC_GetPath("Judgment","Hold"))[2].." 1x2");
			CloseFile(f);

			self:sleep(1.6);
			self:queuecommand("NextScreen");
		end;
		NextScreenCommand=function(self)
			THEME:ReloadMetrics();
			TC_ReturnScreen();
		end;
	};
};
return t;