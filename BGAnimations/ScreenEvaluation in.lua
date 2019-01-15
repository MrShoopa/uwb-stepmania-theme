-- [ja] 一時保存したSMEXPと現在のステップファイルを比較、変更点があれば書き換える 
-- ややこしいんでSMEXPは先頭行ではなく、1行で書かれていることを前提にする 
--[[
local song=_SONG();
if song then
	if GetSMParameter(song,"Offset")~=Getwaiei("Offset") then
		local newssc="";
		local m=GetSMEXPList(0);
		local smexpf={};
		for i=1,m do 
			smexpf[i]=false;
		end;
		local f=OpenSMFile(song);
		if f then
			f:Seek(0);
			local brk=false;
			while true do
				l=f:GetLine();
				local ll=string.lower(l);
				for i=1,m do
				local lp=string.lower(GetSMEXPList(i));
					if string.find(ll,"#notes:.*") or string.find(ll,"#notedata:.*") or f:AtEOF() then
						brk=true;
						break;
					elseif (string.find(ll,"^.*#"..lp..":.*") and (not string.find(ll,"^%/%/.*"))) then
						-- [ja] 書き換え 
						newssc=newssc.."#"..GetSMEXPList(i)..":"..Getwaiei(GetSMEXPList(i))..";\r\n";
						break;
					elseif i==m then
						-- [ja] そのまま 
						newssc=newssc..l.."\r\n";
						break;
					end;
				end;
				if brk then
					break;
				end;
			end;
			-- [ja] 全パラメーターを記載していない（消失してしまった）場合はここで書く 
			for i=1,m do
				if not smexpf[i] and Getwaiei(GetSMEXPList(i))~="" then
					newssc=newssc.."#"..GetSMEXPList(i)..":"..Getwaiei(GetSMEXPList(i))..";\r\n";
				end;
			end;
			-- [ja] 行末まで読み取り  
			while true do
				l=f:GetLine();
				newssc=newssc..l.."\r\n";
				if f:AtEOF() then
					break;
				end;
			end;
			CloseFile(f);
			local f=SaveSMFile(song);
			--f:Write(newssc);
			_SYS("OK")
			CloseFile(f);
		end;
	end;
end;
--]]

return DrillEvaluation_in();