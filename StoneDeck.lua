--- STEAMODDED HEADER
--- MOD_NAME: Deck of stones
--- MOD_ID: StoneDeck
--- MOD_AUTHOR: [Tianjing]
--- MOD_DESCRIPTION: Lots of stone cards!

----------------------------------------------
------------MOD CODE -------------------------

local Backapply_to_runRef = Back.apply_to_run

function Back.apply_to_run(arg_56_0)
	Backapply_to_runRef(arg_56_0)

	if arg_56_0.effect.config.add_stone then
		G.E_MANAGER:add_event(Event({
			func = function()
				for iter_57_0 = #G.playing_cards, 1, -1 do
					sendDebugMessage(G.playing_cards[iter_57_0].base.id)
					if G.playing_cards[iter_57_0].base.suit == 'Clubs' or G.playing_cards[iter_57_0].base.suit == 'Diamonds' then
						G.playing_cards[iter_57_0]:set_ability(G.P_CENTERS.m_stone)
					end
				end

				return true
			end
		}))
	end
end

local loc_en = {
	["name"]="Deck of stones",
	["text"]={
		[1]="Start with a Deck",
		[2]="with lots of",
		[3]="{C:attention}Stone{} cards"
	},
}

local loc_cn = {
	["name"]="石化牌组",
	["text"]={
		[1]="开局时，",
		[2]="牌组中的{C:clubs}梅花{}和{C:diamonds}方片{}",
		[3]="变为{C:attention}石头牌{}"
	},
}

local loc_txt = loc_en
if G.SETTINGS.language == "zh_CN" or G.SETTINGS.language == "zh_TW" then
	loc_txt = loc_cn
end

local dstones = SMODS.Deck:new("Deck of stones", "b_stones", {add_stone = true}, {x = 1, y = 4}, loc_txt)
dstones:register()

----------------------------------------------
------------MOD CODE END----------------------
