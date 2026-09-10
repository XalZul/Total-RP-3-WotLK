----------------------------------------------------------------------------------
-- Total RP 3
-- WHO Frame integration
--	---------------------------------------------------------------------------

TRP3_API.who = TRP3_API.who or {};
local token = "MY_CUSTOM"

local function onInit()

    UnitPopupButtons[token] =
    {
        text = "|cff00ff00View TRP Profile|r",
        dist = 0,
    }

    table.insert(UnitPopupMenus["PLAYER"], #UnitPopupMenus["TARGET"], token)
    table.insert(UnitPopupMenus["TARGET"], #UnitPopupMenus["TARGET"], token)
    table.insert(UnitPopupMenus["FRIEND"], #UnitPopupMenus["FRIEND"], token)
end

local function onStart()
    hooksecurefunc("UnitPopup_OnClick", function(self)
        local dropdownMenu = _G["UIDROPDOWNMENU_INIT_MENU"]
        local unit = dropdownMenu.unit or "target"
        local name, server = UnitName(unit)

        print(dropdownMenu.name)
        print(name)

        if self.value == token then
            local name = dropdownMenu.name
            -- Request the player's profile
            TRP3_API.r.sendQuery(name);
            -- You may need to add a small delay before opening the profile
            C_Timer.After(0.5, function()
                -- Open the profile display
                -- This would depend on how TRP3 implements profile viewing
                if TRP3_API.navigation.page and TRP3_API.navigation.page.setPage then
                    -- Navigate to the player's profile page
                    TRP3_API.navigation.page.setPage("player_main", {
                        profileID = name,
                        profile = TRP3_API.register.getProfile(name),
                        isEditMode = false,
                        isPlayer = false
                    });
                    -- Show the main TRP3 frame
                    TRP3_MainFrame:Show();
                end
            end);
        end;
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