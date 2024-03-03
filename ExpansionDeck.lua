--- STEAMODDED HEADER
--- MOD_NAME: Expansion Deck
--- MOD_ID: ExpansionDeck
--- MOD_AUTHOR: [Tianjing]
--- MOD_DESCRIPTION: Grab more cards than you can hold!

----------------------------------------------
------------MOD CODE -------------------------
local Backapply_to_runRef = Back.apply_to_run

function Back.apply_to_run(arg_56_0)
	Backapply_to_runRef(arg_56_0)

	if arg_56_0.effect.config.Tj_expansion then
		G.GAME.starting_params.Tj_expansion = arg_56_0.effect.config.Tj_expansion
	end
end

local Game_draw_from_deck_to_hand = G.FUNCS.draw_from_deck_to_hand

G.FUNCS.draw_from_deck_to_hand = function(e)
    if G.GAME.starting_params.Tj_expansion and 
        not (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and
        (G.GAME.current_round.hands_played > 0 or G.GAME.current_round.discards_used > 0) then
        e = math.min(#G.deck.cards, G.GAME.starting_params.Tj_expansion)
    end

    Game_draw_from_deck_to_hand(e)
end

local loc_en = {
	["name"]="Expansion deck",
	["text"]={
		[1]="After Play or Discard,",
        [2]="always draw {C:attention}4{} cards"
	},
}

local loc_cn = {
	["name"]="扩容牌组",
	["text"]={
		[1]="出牌或弃牌后",
        [2]="总是抽{C:attention}4{}张牌"
	},
}

local loc_txt = loc_en
if G.SETTINGS.language == "zh_CN" or G.SETTINGS.language == "zh_TW" then
	loc_txt = loc_cn
end

local dexp = SMODS.Deck:new("Expansion deck", "b_expansion", {Tj_expansion = 4}, {x = 1, y = 4}, loc_txt)
dexp:register()

----------------------------------------------
------------MOD CODE END----------------------
