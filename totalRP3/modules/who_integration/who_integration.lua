----------------------------------------------------------------------------------
-- Total RP 3
-- WHO Frame integration
--	---------------------------------------------------------------------------

TRP3_API.who = TRP3_API.who or {};
local token = "VIEW_TRP_PROFILE"

local function onInit()

    UnitPopupButtons[token] =
    {
        text = "|cff00ff00View TRP Profile|r",
        dist = 0,
    }

    table.insert(UnitPopupMenus["PLAYER"], #UnitPopupMenus["PLAYER"], token)
    table.insert(UnitPopupMenus["TARGET"], #UnitPopupMenus["TARGET"], token)
    table.insert(UnitPopupMenus["FRIEND"], #UnitPopupMenus["FRIEND"], token)
end

local function onStart()
    hooksecurefunc("UnitPopup_OnClick", function(self)
        local dropdownMenu = _G["UIDROPDOWNMENU_INIT_MENU"]
        local unit = dropdownMenu.unit or "target"
        local name, _ = UnitName(unit)
        local playerName, _ = UnitName("player")

        if self.value == token then
            local name = dropdownMenu.name

            if name == playerName then
                local profile = TRP3_API.profile.getPlayerCurrentProfile()

                TRP3_API.navigation.page.setPage("player_main", {
                    profile = profile,
                    isPlayer = true
                })

                TRP3_API.register.openPageByUnitID(TRP3_API.globals.player_id)
                TRP3_API.navigation.openMainFrame()
                return
            end

            TRP3_API.r.sendQuery(name);

            C_Timer.After(1, function()
                local profile = TRP3_API.register.getCharacterList()[name]

                if TRP3_API.navigation.page and
                   TRP3_API.navigation.page.setPage and
                   profile then
                    TRP3_API.navigation.page.setPage("player_main", {
                        profileID = profile.profileID,
                        profile = TRP3_API.register.getProfile(profile.profileID),
                        isEditMode = false,
                        isPlayer = false
                    })
                    
                    TRP3_API.navigation.openMainFrame()
                end
            end)
        end
    end)
end


local MODULE_STRUCTURE = {
	["name"] = "Who Context Menu",
	["description"] = "Adds the ability to see people's profiles in the who menu.",
	["version"] = 1.000,
	["id"] = "trp3_who_integration",
    ["onInit"] = onInit,
    ["onStart"] = onStart,
	["minVersion"] = 1,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);