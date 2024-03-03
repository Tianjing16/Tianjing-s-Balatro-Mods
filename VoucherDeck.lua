--- STEAMODDED HEADER
--- MOD_NAME: Voucher Deck
--- MOD_ID: VoucherDeck
--- MOD_AUTHOR: [Tianjing]
--- MOD_DESCRIPTION: Increase rank of discarded cards!

----------------------------------------------
------------MOD CODE -------------------------
local Backapply_to_runRef = Back.apply_to_run

function Back.apply_to_run(arg_56_0)
	Backapply_to_runRef(arg_56_0)

	if arg_56_0.effect.config.Tj_extra_voucher then
		G.GAME.starting_params.Tj_extra_voucher = arg_56_0.effect.config.Tj_extra_voucher
        G.GAME.starting_params.Tj_voucher_discount = arg_56_0.effect.config.Tj_voucher_discount
	end
end

local Game_enter_shop = G.FUNCS.cash_out

function G.FUNCS.cash_out(e)
    Game_enter_shop(e)

    G.extra_voucher = true
end

local Game_update_shop = G.update_shop

function G.update_shop(dt)
    Game_update_shop(dt)

    if G.extra_voucher and not G.load_shop_vouchers and G.GAME.starting_params.Tj_extra_voucher then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                if not G.extra_voucher then
                    return true
                end
                G.extra_voucher = false
                local extra_voucher_key = get_next_voucher_key(true)
                G.shop_vouchers.config.card_limit = G.shop_vouchers.config.card_limit + 1
                local extra_card = Card(G.shop_vouchers.T.x + G.shop_vouchers.T.w/2,
                G.shop_vouchers.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[extra_voucher_key],{bypass_discovery_center = true, bypass_discovery_ui = true})
                create_shop_card_ui(extra_card, 'Voucher', G.shop_vouchers)
                extra_card:start_materialize()
                G.shop_vouchers:emplace(extra_card)
                return true
            end    
        }))
    end
end

local Card_set_cost = Card.set_cost

function Card.set_cost(self,arg_57_0)
    Card_set_cost(self,arg_57_0)

    if G.GAME.starting_params.Tj_voucher_discount and self.ability.set == 'Voucher' then
        local total_discount = math.min(100, G.GAME.discount_percent+G.GAME.starting_params.Tj_voucher_discount)
        self.cost = math.max(1, math.floor((self.base_cost + self.extra_cost + 0.5)*(100-total_discount)/100))
        self.sell_cost = math.max(1, math.floor(self.cost/2)) + (self.ability.extra_value or 0)
        self.sell_cost_label = self.facing == 'back' and '?' or self.sell_cost
    end
end

local loc_en = {
	["name"]="Voucher deck",
	["text"]={
		[1]="Add one {C:voucher}Voucher{}",
		[2]="to the shop when extering",
        [3]="Vouchers in shop",
        [4]="are are {C:attention}20%{} off",
	},
}

local loc_cn = {
	["name"]="优惠券牌组",
	["text"]={
		[1]="进入商店时",
		[2]="额外添加一张{C:voucher}优惠券{}",
        [3]="商店内所有{C:voucher}优惠券{}",
        [4]="售价降低{C:attention}20%{}",
	},
}

local loc_txt = loc_en
if G.SETTINGS.language == "zh_CN" or G.SETTINGS.language == "zh_TW" then
	loc_txt = loc_cn
end

local dvou = SMODS.Deck:new("Voucher deck", "b_voucher", {Tj_extra_voucher = true, Tj_voucher_discount = 20}, {x = 1, y = 4}, loc_txt)
dvou:register()

----------------------------------------------
------------MOD CODE END----------------------
