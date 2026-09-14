----------------------------------------------------------------------------------
-- Total RP 3 - Unit Popup Integration Module
-- Copyright 2026 Xal-Zul (www.xal-zul.co.za)
----------------------------------------------------------------------------------
-- This module integrates the profile opening-functionality into the unit frames and the right-click context menus for players,
-- Allowing one to view a profile in the /who player list (and other places), without having to first "meet" the player.

--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
----------------------------------------------------------------------------------

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

        if self.value == token then
            local name = dropdownMenu.name

            TRP3_API.utils.message.displayMessage("|cffffff00Requesting profile. Please wait...|r")

            -- Handle opening the player's own profile.

            if name == TRP3_API.globals.player_id then
                local profile = TRP3_API.profile.getPlayerCurrentProfile()

                TRP3_API.navigation.page.setPage("player_main", {
                    profile = profile,
                    isPlayer = true
                })

                TRP3_API.navigation.openMainFrame()
                TRP3_API.register.openPageByUnitID(TRP3_API.globals.player_id)
                return
            end

            -- Handle opening another player's profile.

            TRP3_API.r.sendQuery(name);

            -- Wait for 1 second to give the profile time to be received, before opening the profile page.
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
	["name"] = "Unit Popup Integration",
	["description"] = "Adds integration with right-click menus on unit frames and player names in chat frames.",
	["version"] = 1.000,
	["id"] = "trp3_unit_popup_integration",
    ["onInit"] = onInit,
    ["onStart"] = onStart,
	["minVersion"] = 1,
}

TRP3_API.module.registerModule(MODULE_STRUCTURE)