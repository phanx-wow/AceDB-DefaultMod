--[[--------------------------------------------------------------------
Causes AceDB-3.0 to default to the account-wide "Default" profile
instead of a character-specific profile for addons which do not specify.
----------------------------------------------------------------------]]

local exceptions = {
	["CliqueDB3"] = true, -- Clique bindings
	["MogItWishlist"] = true, -- MogIt wishlist
}

local patched = {}

local function GetDB(self, svar)
	if type(svar) == "string" then
		svar = _G[svar]
	end
	if type(svar) ~= "table" then
		error("Usage: AceDB:GetDB(svar): 'svar' - string or table expected.", 2)
	end
	for db in pairs(self.db_registry) do
		if db.sv == svar then
			return db
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function()
	if not LibStub then return end
	local AceDB, MINOR = LibStub("AceDB-3.0", true)
	if not MINOR or patched[MINOR] then return end

	local New = AceDB.New
	function AceDB:New(tbl, defaults, defaultProfile)
		if type(defaultProfile) == "nil" and not exceptions[tbl] then
			--print("AceDB", MINOR, "New called with nil defaultProfile for", tostring(tbl))
			defaultProfile = true
		end
		return New(self, tbl, defaults, defaultProfile)
	end

	--AceDB.Get = GetDB

	patched[MINOR] = true
	--print("Patched AceDB", MINOR)
end)