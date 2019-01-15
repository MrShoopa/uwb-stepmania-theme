--[ja] SMファイルで指定したパラメータの内容を読み取る  
function GetSMParameter(song,prm)
	local st=song:GetAllSteps();
	if #st<1 then
		return "";
	end;
	local t;
	t=st[1]:GetFilename();
	if not FILEMAN:DoesFileExist(t) then
		return "";
	end;
	--[ja] 形式ではじく 
	local lt=string.lower(t);
	if not string.find(lt,".*%.sm") and not string.find(lt,".*%.ssc") then
		return "";
	end;
	local f=RageFileUtil.CreateRageFile();
	f:Open(t,1);
	-- [ja] 複数行を考慮していったん別変数に代入する 
	local gl="";
	local pl=string.lower(prm);
	local l;
	while true do
		l=f:GetLine();
		local ll=string.lower(l);
		if string.find(ll,"#notes:.*") or f:AtEOF() then
			break;
		-- [ja] BOM考慮して .* を頭につける 
		elseif (string.find(ll,"^.*#"..pl..":.*") and (not string.find(ll,"^%/%/.*"))) or gl~="" then
			gl=gl..""..split("//",l)[1];
			if string.find(ll,".*;") then
				break;
			end;
		end;
	end;
	local tmp={};
	if gl=="" then
		tmp={""};
	else
		tmp=split(":",gl);
		if tmp[2]==";" then
			tmp[1]="";
		else
			if #tmp>2 then
				tmp[1]=tmp[2];
				for i=3,#tmp do
					tmp[1]=tmp[1]..":"..split(";",tmp[i])[1];
				end;
			else
				tmp[1]=split(";",tmp[2])[1];
			end;
		end;
	end;
	f:Close();
	f:destroy();
	return tmp[1];
end;

-- [ja] ファイルを開く
--[[
	file=OpenFile(ファイルパス); 
																				--]]
-- [ja] 注意：fileは、必ずCloseFile等を使って閉じること 
function OpenFile(filePath)
	if not FILEMAN:DoesFileExist(filePath) then
		return nil;
	end;
	local f=RageFileUtil.CreateRageFile();
	f:Open(filePath,1);
	return f;
end;
-- [ja] セーブバージョン 
function SaveFile(filePath)
	local f=RageFileUtil.CreateRageFile();
	f:Open(filePath,2);
	return f;
end;
-- [ja] songからSMファイルを開く
--[[
	file=OpenSMFile(song); 
																				--]]
-- [ja] 注意：fileは、必ずCloseFile等を使って閉じること 
function OpenSMFile(song)
	local st=song:GetAllSteps();
	if #st<1 then
		return nil;
	end;
	local t;
	t=st[1]:GetFilename();
	if not FILEMAN:DoesFileExist(t) then
		return nil;
	end;
	--[ja] 形式ではじく 
	local lt=string.lower(t);
	if not string.find(lt,".*%.sm") and not string.find(lt,".*%.ssc") then
		return nil;
	end;
	return OpenFile(t);
end;
-- [ja] セーブバージョン 
function SaveSMFile(song)
	local st=song:GetAllSteps();
	if #st<1 then
		return nil;
	end;
	local t;
	t=st[1]:GetFilename();
	if not FILEMAN:DoesFileExist(t) then
		return nil;
	end;
	--[ja] 形式ではじく（DWIは・・・ね？） 
	local lt=string.lower(t);
	if not string.find(lt,".*%.sm") and not string.find(lt,".*%.ssc") then
		return nil;
	end;
	return SaveFile(t);
end;
--[ja] SMファイルと同じ書式のファイルで指定したパラメータの内容を読み取る（FILE型を直接指定） 
--[[
	内容=GetFileParameter(file,"パラメータ"); 
	
	#AAA:BBB; の場合、返り値=GetSMParameter_f(file,"AAA"); となり、"BBB"が返る
																				--]]
--[ja] あらかじめ OpenSMFile で開いておく必要があり、最後に f:Close() / f:destroy() をする必要がある 
--[ja] 解放忘れすると怖いんであんまり使わないほうがいい？ 
function GetFileParameter(f,prm)
	return GetSMParameter_f(f,prm);
end;
function GetSMParameter_f(f,prm)
	if not f then
		return "";
	end;
	f:Seek(0);
	local gl="";
	local pl=string.lower(prm);
	local l;
	while true do
		l=f:GetLine();
		local ll=string.lower(l);
		if string.find(ll,"#notes:.*") or f:AtEOF() then
			break;
		elseif (string.find(ll,"^.*#"..pl..":.*") and (not string.find(ll,"^%/%/.*"))) or gl~="" then
			gl=gl..""..split("//",l)[1];
			if string.find(ll,".*;") then
				break;
			end;
		end;
	end;
	local tmp={};
	if gl=="" then
		tmp={""};
	else
		tmp=split(":",gl);
		if tmp[2]==";" then
			tmp[1]="";
		else
			if #tmp>2 then
				tmp[1]=tmp[2];
				for i=3,#tmp do
					tmp[1]=tmp[1]..":"..split(";",tmp[i])[1];
				end;
			else
				tmp[1]=split(";",tmp[2])[1];
			end;
		end;
	end;
	return tmp[1];
end;
-- [ja] 1行読み取り （;を含んでいても読み取り可能） 
function GetSMOneline_f(f,prm)
	if not f then
		return "";
	end;
	f:Seek(0);
	local gl="";
	local pl=string.lower(prm);
	local l;
	while true do
		l=f:GetLine();
		local ll=string.lower(l);
		if string.find(ll,"#notes:.*") or f:AtEOF() then
			break;
		elseif (string.find(ll,"^.*#"..pl..":.*") and (not string.find(ll,"^%/%/.*"))) or gl~="" then
			gl=gl..""..l;
			break
		end;
	end;
	local tmp={};
	if gl=="" then
		tmp={""};
	else
		tmp=split(":",gl);
		if tmp[2]==";" then
			tmp[1]="";
		else
			if #tmp>2 then
				tmp[1]=tmp[2];
				for i=3,#tmp do
					tmp[1]=tmp[1]..":"..tmp[i];
				end;
			else
				tmp[1]=tmp[2];
			end;
		end;
	end;
	return tmp[1];
end;
--[ja] fileを閉じる 
--[[
	CloseFile(file); 
																				--]]
--[ja] OpenFile / OpenSMFile を使用した場合は必ず閉じてください 
function CloseFile(f)
	if f then
		f:Close();
		f:destroy();
		return true;
	else
		return false;
	end;
end;

-- [ja] ファイルの有無を調べる（DoseFileExistと異なり、拡張子の指定不要） 
function FileExist(fsearch)
	local f=split("/",fsearch);
	local dir="";
	local fname=f[#f];
	for i=1,#f-1 do
		dir=dir..f[i].."/";
	end;
	local flist=FILEMAN:GetDirListing(dir,false,false);
	for i=1,#flist do
		if string.find(flist[i],"^"..fname..".*") then
			return true;
		end;
	end;
	return false;
end;

-- [ja] ファイルを返す 
function GetFileExist(fsearch)
	local f=split("/",fsearch);
	local dir="";
	local fname=f[#f];
	for i=1,#f-1 do
		dir=dir..f[i].."/";
	end;
	local flist=FILEMAN:GetDirListing(dir,false,false);
	for i=1,#flist do
		if string.find(flist[i],"^"..fname..".*") then
			return dir..flist[i];
		end;
	end;
	return nil;
end;

-- [ja] ブロックの内容を取得する 
-- [ja] ここでいうブロック＝INIのセクションに相当 
--[=[
	[b_name]
	#XXX1:YYY1; ┐
	#XXX2:YYY2; ├この部分
	#XXX3:YYY3; ┘
	
	[hogehoge]
	XXX1:YYY1;
--]=]
function GetTextBlock(filePath,ub_name)
	if not filePath or not FILEMAN:DoesFileExist(filePath) then
		return "";
	end;
	local b_name=string.lower(ub_name);
	local f=RageFileUtil.CreateRageFile();
	f:Open(filePath,1);

	local ret={};
	local loadblock=false;
	local l;
	local l_cnt=0;
	while true do
		l=f:GetLine();
		local ll=string.lower(l);
		if (loadblock and string.find(ll,".*%[.+%]$"))
			or f:AtEOF() then
			break;
		elseif not loadblock and string.find(ll,".*%["..b_name.."%]$") then
			loadblock=true;
		elseif loadblock and ll~="" and not string.find(ll,"^%s+$")
			and not string.find(ll,"^//.*") then
			--[[
			if ret~="" then
				ret=ret.."\n";
			end;
			--]]
			l=string.gsub(l,"^%s",""); --[ja] 先頭の空白を削除 
			l=string.gsub(l,"%s$",""); --[ja] 終端の空白を削除 
		--	ret=ret..l;
			l_cnt=l_cnt+1;
			ret[l_cnt]=l
		end;
	end;

	f:Close();
	f:destroy();
	return ret;
end;

-- [ja] INI書式のub_name=YYY;の内容を取得する 
function GetBlockPrm(bStr,ub_name)
	if #bStr<1 then
		return "";
	end;
--	_SYS(blockStr)
--	local bStr=split(";",blockStr);
	local b_name=string.lower(ub_name);
	local ret="";
	for i=1,#bStr do
		if string.find(string.lower(bStr[i]),"^"..b_name.."=.*") then
			ret=""..split("=",bStr[i])[2];
			ret=split(";",ret)[1];
			break;
		end;
	end;
	return ret;
end;

-- [ja] CRS書式の#ub_name:YYY;の内容を取得する 
function GetCRSPrm(bStr,ub_name)
	if #bStr<1 then
		return "";
	end;
--	_SYS(blockStr)
--	local bStr=split(";",blockStr);
	local b_name=string.lower(ub_name);
	local ret="";
	for i=1,#bStr do
		if string.find(string.lower(bStr[i]),"^#"..b_name..":.*") then
			local tmp=split(":",bStr[i]);
			ret=""..tmp[2];
			for p=3,#tmp do
				ret=ret..":"..tmp[p];
			end;
			ret=split(";",ret)[1];
			break;
		end;
	end;
	return ret;
end;

-- [ja] CRS書式の#ub_name:YYY;の内容を取得する 
-- [ja] #SONGのように複数定義されているもの専用 
-- [ja] テーブルとして返す 
function GetCRSPrm2(bStr,ub_name)
	if #bStr<1 then
		return "";
	end;
	--[[
	if blockStr=="" then
		return "";
	end;
	local bStr=split(";",blockStr);
	--]]
	local b_name=string.lower(ub_name);
	local ret={};
	local r=0;
	for i=1,#bStr do
		if string.find(string.lower(bStr[i]),"^#"..b_name..":.*") then
			r=r+1;
			local tmp=split(":",bStr[i]);
			ret[r]=tmp[2];
			for p=3,#tmp do
				ret[r]=ret[r]..":"..tmp[p];
			end;
			ret[r]=split(";",ret[r])[1];
		end;
	end;
	return ret;
end;

-- [ja] INI書式のub_name=YYY;ZZZ;AAA;...の内容を取得する 
function GetBlockPrm_Command(bStr,ub_name)
	if #bStr<1 then
		return "";
	end;
	local b_name=string.lower(ub_name);
	local ret="";
	for i=1,#bStr do
		if string.find(string.lower(bStr[i]),"^"..b_name.."=.*") then
			ret=""..split("=",bStr[i])[2];
			break;
		end;
	end;
	return ret;
end;

-- [ja] 1行追加してINI形式で保存
function SaveINIOneLine(filePath,section,prm,val)
	local txtData='';
	local writePrm=false;
	if FILEMAN:DoesFileExist(filePath) then
		local f=OpenFile(filePath);
		local lsection=string.lower(section);
		local lprm    =string.lower(prm);
		local curSection='';
		while true do
			l=f:GetLine();
			local ll=string.lower(l);
			if f:AtEOF() then
				if curSection==lsection and not writePrm then
					txtData=txtData..prm..'='..val..'\r\n';
					writePrm=true;
				end;
				break;
			elseif string.find(ll,".*%[.*%]$") then
				if curSection==lsection and not writePrm then
					txtData=txtData..prm..'='..val..'\r\n';
					writePrm=true;
				end;
				if curSection~='' then
					txtData=txtData..'\r\n';
				end;
				curSection=ll;
				txtData=txtData..l..'\r\n';
			elseif string.find(ll,".*=.*$") then
				if not writePrm and string.find(ll,".*"..lprm.."=.*$") then
					txtData=txtData..prm..'='..val..'\r\n';
					writePrm=true;
				else
					txtData=txtData..l..'\r\n';
				end;
			end;
		end;
		f:Close();
	end;
	if not writePrm then
		txtData='['..section..']\r\n';
		txtData=txtData..prm..'='..val..'\r\n';
	end;
	local f=SaveFile(filePath);
	f:Write(txtData);
	f:Close();
end;

-- [ja] 1行追加してCRS形式で保存
function SaveCRSOneLine(filePath,section,prm,val)
	local txtData='';
	local writePrm=false;
	if FILEMAN:DoesFileExist(filePath) then
		local f=OpenFile(filePath);
		local lsection=string.lower(section);
		local lprm    =string.lower(prm);
		local curSection='';
		while true do
			l=f:GetLine();
			local ll=string.lower(l);
			if f:AtEOF() then
				if curSection==lsection and not writePrm then
					txtData=txtData..'#'..prm..':'..val..';\r\n';
					writePrm=true;
				end;
				break;
			elseif string.find(ll,".*%[.*%]$") then
				if curSection==lsection and not writePrm then
					txtData=txtData..'#'..prm..':'..val..';\r\n';
					writePrm=true;
				end;
				if curSection~='' then
					txtData=txtData..'\r\n';
				end;
				curSection=ll;
				txtData=txtData..l..'\r\n';
			elseif string.find(ll,".*#.*:.*$") then
				if not writePrm and string.find(ll,".*#"..lprm..":.*$") then
					txtData=txtData..'#'..prm..':'..val..';\r\n';
					writePrm=true;
				else
					txtData=txtData..l..'\r\n';
				end;
			end;
		end;
		f:Close();
	end;
	if not writePrm then
		if section~='' then
			txtData='['..section..']\r\n';
		end;
		txtData=txtData..'#'..prm..':'..val..';\r\n';
	end;
	local f=SaveFile(filePath);
	f:Write(txtData);
	f:Close();
end;

-- [ja] ファイルパスからファイル名と拡張子を取得する
function GetFileNameFormPath(path)
	local ret={'',''};
	if path then
		local sp_path=split('%.',path);
		ret[2]=sp_path[#sp_path];
		if #sp_path>=2 then
			local sp_path_dir=split('/',sp_path[#sp_path-1]);
			ret[1]=sp_path_dir[#sp_path_dir];
		end;
	end;
	return ret;
end;