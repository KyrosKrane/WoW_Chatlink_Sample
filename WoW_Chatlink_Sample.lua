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
-- To avoid a conflict with the the ID of actual garrison missions, it should not be just an integer value.
-- You could also have multiple types, and handle each type with a different response function in your addon.
local MY_ADDON_LINK_TYPE = "dslocation"


-- This function demonstrates how to make a chat link.
local function MakeChatLink(linktype, displaytext)
	return "|H" .. BLIZZ_LINK_TYPE .. ":" .. linktype .. "|h" .. displaytext .. "|h"
	-- Note that you can have additional data sections after the linktype and before the |h, separate by colons (:) to pass different chunks of data.
	-- Then, when handling the click, you could split on the colons and parse the values to figure out what the user clicked on and how to handle it.
	-- The data values must all be strings composed of printable characters.
	-- If you do this, you have to update the "if linktype ~= ExpectedLinkType" check below to account for the extra values.
end


-- When the user clicks a link in chat, the secure function SetItemRef() is invoked.
-- For "garrmission" links with an invalid ID (which our link type is), it exits silently and without error.
-- So, we can hook it to process our chatlink clicks.
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

	-- For actual processing, you could do something like:
	-- 		DoStuffWithClick(DisplayText)
	-- or
	-- 		DoStuffWithClick(linktype)

end)


-- Handle the slash command we create below.
-- This demonstrates how we insert a chat link into a string.
local function PutLinkInChat(msg, editbox)
	local link = MakeChatLink(MY_ADDON_LINK_TYPE, "12.34 56.78")
	print("This is a test hyperlink [" .. link .. "] with some text after the link.")
end

-- Create a sample slash command to test the addon.
SLASH_TTT1 = "/ttt"
SlashCmdList.TTT = function (...) PutLinkInChat(...) end
