-- WoW_Chatlink_Sample.lua
-- Written by KyrosKrane Sylvanblade (kyros@kyros.info)
-- This file is in the public domain, or, where not permitted, licensed under The Unlicense.
-- To the extent possible under law, KyrosKrane Sylvanblade has waived all copyright and related or neighboring rights to WoW_Chatlink_Sample.lua.

-- This sample addon demonstrates how to create and use addon-created links in WoW.
-- It is current as of patch 8.2.5.



-- This is the Blizzard link type. It can only be one of a set number of values, documented here:
-- https://wow.gamepedia.com/UI_escape_sequences
-- And of those, only a very few can be overloaded for our purposes. The "garrmission" type is safest to use.
local BLIZZ_LINK_TYPE = "garrmission"


-- This is an identifier that tells us whether this chat link is from our addon or not. It could simply be the name of your addon.
-- You could also have multiple types, and handle each type with a different response function in your addon.
local MY_ADDON_LINK_TYPE = "dslocation"


-- This function demonstrates how to make a chat link.
function MakeChatLink(linktype, displaytext)
	return "|H" .. BLIZZ_LINK_TYPE .. ":" .. linktype .. "|h" .. displaytext .. "|h"
end


-- When the user clicks a link in chat, the secure function SetItemRef() is invoked.
-- For "garrmission" links with an invalid ID (which our link type is), it exits silently and without error.
-- So, we can hook it and to handle processing our linked clicks.
hooksecurefunc("SetItemRef", function(linktype, fulllink)
	-- for debugging
	-- print("linktype is " .. linktype .. ", fulllink is " .. fulllink:gsub("|", "||"))

	-- for actual use
	-- Make sure the link type that was clicked is one created by our addon.
	local ExpectedLinkType = BLIZZ_LINK_TYPE .. ":" .. MY_ADDON_LINK_TYPE
	if linktype ~= ExpectedLinkType then
		-- not our chat link, ignore
		return
	end

	-- Extract the text the user clicked.
	local DisplayText = string.match(fulllink, "^%|H" .. ExpectedLinkType .. "%|h([^%|]+)%|h$")
	-- for debugging
	print("DisplayText is " .. DisplayText)

    -- For actual processing, do something like
	-- DoStuffWithClick(DisplayText)
	-- or
	-- DoStuffWithClick(linktype)

end)


-- Handle the slash command we create below.
-- This demonstrates how we insert a chat link into a string.
function TTT(msg, editbox)
	local link = MakeChatLink(MY_ADDON_LINK_TYPE, "12.34 56.78")
	print("This is a test hyperlink [" .. link .. "] with some text after the link.")
end

-- Create a sample slash command to test the addon.
SLASH_TTT1 = "/ttt"
SlashCmdList.TTT = function (...) TTT(...) end

