-- theme identification:
themeInfo = {
	ProductCode = "waiei-2000",
	Name = "waiei",
	Version = 2.000,
	Date = "20171010",
	Revision = 2000,
	Dev = "",
}

function GetThemeVersionInformation(prm)
	return themeInfo[prm];
end;

function waieiDir()
	return "";
end;