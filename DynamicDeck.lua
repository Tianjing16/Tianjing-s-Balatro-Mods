--- STEAMODDED HEADER
--- MOD_NAME: Dynamic Deck
--- MOD_ID: DynamicDeck
--- MOD_AUTHOR: [Tianjing]
--- MOD_DESCRIPTION: Increase rank of discarded cards!

----------------------------------------------
------------MOD CODE -------------------------
local Backapply_to_runRef = Back.apply_to_run

function Back.apply_to_run(arg_56_0)
	Backapply_to_runRef(arg_56_0)

	if arg_56_0.effect.config.Tj_dynamic then
		G.GAME.starting_params.Tj_dynamic = arg_56_0.effect.config.Tj_dynamic
	end
end

local draw_card_Ref = draw_card

function draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
    if G.GAME.starting_params.Tj_dynamic and card and from == G.hand and to == G.discard then
        G.E_MANAGER:add_event(Event({trigger = 'immediate',delay = 0.1,func = function()
                local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
                local rank_suffix = card.base.id == 14 and 2 or math.min(card.base.id+1, 14)
                if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
                elseif rank_suffix == 10 then rank_suffix = 'T'
                elseif rank_suffix == 11 then rank_suffix = 'J'
                elseif rank_suffix == 12 then rank_suffix = 'Q'
                elseif rank_suffix == 13 then rank_suffix = 'K'
                elseif rank_suffix == 14 then rank_suffix = 'A'
                end
                card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
            return true
        end }))
    end

    draw_card_Ref(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
end

local loc_en = {
	["name"]="Dynamic deck",
	["text"]={
		[1]="Increase rank of",
		[2]="discarded cards by {C:attention}1{}",
	},
}

local loc_cn = {
	["name"]="动态牌组",
	["text"]={
		[1]="被丢弃的手牌",
		[2]="点数提高{C:attention}1{}",
	},
}

local loc_txt = loc_en
if G.SETTINGS.language == "zh_CN" or G.SETTINGS.language == "zh_TW" then
	loc_txt = loc_cn
end

local ddyn = SMODS.Deck:new("Dynamic deck", "b_dynamic", {Tj_dynamic = true}, {x = 1, y = 4}, loc_txt)
ddyn:register()

----------------------------------------------
------------MOD CODE END----------------------
