--[ja] SM5本体のバージョンを以下のグループで分ける
--[[
	previewX		0
	A1,A1a		1
	A2			2
	A3			3
	B1,B1a		10
	B2,B2a		20
	B3			30
	B4,B4a		40
	B5～5.0.7rc	50
	5.0.7～5.0.9	70
	5.0.1x～		80
	5.1.x			90
--]] 
local f_ver=50;
local __SMV__=false;
local function SetSMVersion()
	local v=string.lower(ProductVersion())
	local d=string.lower(VersionDate())
	-- [ja] 最新バージョンを上に書くことでできるだけ処理に負荷をかけないようにする 
	-- 　　旧バージョン？知らない子ですね 
	if string.find(v,"5.1",0,true) then
		__SMV__= 90;
	elseif string.find(v,"5.0.1",0,true) then	-- 5.0.1x
		__SMV__= 80;
	elseif string.find(v,"5.0.7rc",0,true) or string.find(v,"5.0.6",0,true) or string.find(v,"5.0.5",0,true) then
		__SMV__= 50;
	elseif string.find(v,"5.0.",0,true) then
		__SMV__= 70;
	elseif string.find(v,"v5.0 beta 4",0,true) then
		__SMV__= 40;
	elseif string.find(v,"v5.0 beta 3",0,true) then
		__SMV__= 30;
	elseif string.find(v,"v5.0 beta 2",0,true) then
		__SMV__= 20;
	elseif string.find(v,"v5.0 beta 1",0,true) then
		__SMV__= 10;
	elseif string.find(v,"v5.0 beta",0,true) then
		__SMV__= 50;
	elseif string.find(v,"v5.0 alpha 1",0,true) then
		__SMV__= 1;
	elseif string.find(v,"v5.0 alpha 2",0,true) then
		__SMV__= 2;
	elseif string.find(v,"v5.0 alpha 3",0,true) then
		__SMV__= 3;
	elseif string.find(v,"v5.0 preview",0,true) then
		__SMV__= 0;
	else
		__SMV__= f_ver;
	end;
	return __SMV__;
end;

function GetSMVersion()
	return __SMV__ or SetSMVersion();
end;

