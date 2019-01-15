-- theme identification:
themeInfo = {
	ProductCode = "waiei-2000",
	Name = "waiei",
	Version = 2.000,
	Date = "20151220",
	Revision = 2000,
	Dev = "b",
}

function GetThemeVersionInformation(prm)
	return themeInfo[prm];
end;

function waieiDir()
	return "";
end;