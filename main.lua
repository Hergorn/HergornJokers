--- STEAMODDED HEADER
--- MOD_NAME: HergornTV Stream
--- MOD_ID: HergornTVStream
--- MOD_AUTHOR: [HergornTV]
--- MOD_DESCRIPTION: Jokers from prominent parts of HergornTV Streams
--- PREFIX: HRGN
----------------------------------------------
------------MOD CODE -------------------------


SMODS.Atlas{
    key = 'Jokers', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}
--TESTER--
SMODS.Joker{
    key = 'TESTER', --joker key
    loc_txt = { -- local text
        name = 'TESTER',
        text = {
            'ITS',
            'OVER',
            '{X:mult,C:white}X#1#{}'
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 4, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 123, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
        extra = {
            Xmult = 9000 --configurable value
        }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = G.P_CENTERS.j_joker --adds "Joker"'s description next to this card's description
        return {vars = {center.ability.extra.Xmult}} --#1# is replaced with card.ability.extra.Xmult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                card = card,
                Xmult_mod = card.ability.extra.Xmult,
                message = 'X' .. card.ability.extra.Xmult,
                colour = G.C.MULT
            }
        end

        if context.setting_blind then
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_joker')
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        end
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
    calc_dollar_bonus = function(self,card)
        return 9000
    end,
}
--OBERON MUST DIE--
SMODS.Joker{
    key = 'OBERON MUST DIE',
    loc_txt = {
        name = 'OBERON MUST DIE',
        text = {
            'Destroys every {C:legendary}Legendary Joker{}',
            'when Blind is selected',
            'add {X:mult,C:white}X19{} after doing so',
            '[Currently {X:mult,C:white}X#2#{}]'
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 3, y = 0},
    config = {extra = {Xmult_add = 19, Xmult = 1}},
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult_add, card.ability.extra.Xmult}}
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            local jokers_to_slice = {}
            for i = 1, #G.jokers.cards do
                local j = G.jokers.cards[i]
                local rarity = j.config.center.rarity
                if j ~= card and rarity == 4 and not j.ability.eternal and not j.getting_sliced then
                    table.insert(jokers_to_slice, j)
                end
            end
            for _, sliced_card in ipairs(jokers_to_slice) do
                sliced_card.getting_sliced = true
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.joker_buffer = 0
                    card.ability.extra.Xmult = tonumber(card.ability.extra.Xmult or 0) + card.ability.extra.Xmult_add
                    card:juice_up(0.8, 0.8)
                    sliced_card:start_dissolve({HEX("00e5ff")}, nil, 1.6)
                    play_sound('slice1', 0.96 + math.random() * 0.08)
                    return true
                end}))
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult_add}},
                    colour = G.C.RED,
                    no_juice = true
                })
            end
        end
        if context.joker_main then
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
                Xmult_mod = card.ability.extra.Xmult
            }
        end
    end,

    pool = function(self, wawa, wawa2)
        return true
    end
}
--PAPAS PLATTE--
SMODS.Joker{
    key = 'PAPAS PLATTE',
    loc_txt = {
        name = 'PAPAS PLATTE',
        text = {
            "Gain {C:red}+1{} Mult when a {C:attention}face card{} is played,",
            "[Currently {C:red}#1#{} Mult]"
        }},
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    atlas = 'Jokers',
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 4, y = 0},
    config = {extra = {Mult = 0}},   
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Mult}}
    end,
    calculate = function(self, card, context)
        -- During hand scoring
        if context.individual and context.cardarea == G.play then
            if context.other_card and context.other_card:is_face() then
                card.ability.extra.Mult = (card.ability.extra.Mult or 0) + 1
                return {
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize{type='variable', key='a_mult', vars={"1"}},
                        colour = G.C.RED,
                    }),
                    card = card
                }
            end
        end
        -- Apply total stored Mult during scoring
        if context.joker_main and (card.ability.extra.Mult or 0) ~= 0 then
            return {
                message = localize{type='variable', key='a_mult', vars={card.ability.extra.Mult}},
                mult_mod = card.ability.extra.Mult
            }            
        end
    end,
    pool = function(self, wawa, wawa2)
        return true
    end
}
--POKEMON BOOSTER--
SMODS.Joker{
    key = 'POKEMON BOOSTER',
    loc_txt = {
        name = 'POKEMON BOOSTER',
        text = {
            "Creates a {C:attention}random Booster Pack Tag{}",
            "after leaving shop"
        }},
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    atlas = 'Jokers',
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 5, y = 0},
    config = {
        extra = {
            candies = 5,
            flavours = {
                [1] = 'tag_buffoon',
                [2] = 'tag_charm',
                [3] = 'tag_meteor',
                [4] = 'tag_standard',
                [5] = 'tag_ethereal'
            }
        }
    },  
    calculate = function(self, card, context)
        if context.ending_shop then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    add_tag(Tag(pseudorandom_element(card.ability.extra.flavours, pseudoseed('pokemon'))))
                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                    return true
                end)
            }))
        end
    end,
    pool = function(self, wawa, wawa2)
        return true
    end
}
--DICE TREASURE--
SMODS.Joker{
    key = 'DISE TREASURE',
    loc_txt = {
        name = 'DICE TREASURE',
        text = {
            "Rolls D&D dice when scoring:",
            "{C:red}1d4 +XMult{}, {C:money}1d6 +Money{},",
            "{C:mult}1d8 +Mult{}, {C:chips}1d10 +Score{},",
            "Roll a {C:attention}NAT 20{} on 1d20 to {C:attention}double all{}"
        }},
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    atlas = 'Jokers',
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 6, y = 0},
    config = {},  
    calculate = function(self, card, context)
        if context.joker_main then
            local xmult = love.math.random(1, 4)
            local coins = love.math.random(1, 6)
            local mult = love.math.random(1, 8)
            local score = love.math.random(1, 10)
            local d20 = love.math.random(1, 20)
            local factor = 1

            if d20 == 20 then
                factor = 2
                card:juice_up(1, 1)
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = 'NAT20! DOUBLE!',
                    color = G.C.MONEY,
                    no_juice = true
                })
            end

            local fxmult = xmult * factor
            local fcoins = coins * factor
            local fmult = mult * factor
            local fscore = score * factor
            --G.GAME.dollars = G.GAME.dollars + fcoins,
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = string.format('Rolled: d4:%d, d6:%d, d8:%d, d10:%d, d20:%d', xmult, coins, mult, score, d20),
                colour = G.C.L_BLUE,
                no_juice = true
            })
            return {
                Xmult_mod = fxmult,
                mult_mod = fmult,
                message = string.format('X%d and +%d', fxmult, fmult),
                chips = fscore,
                dollars = fcoins,
                
            }
        end
    end,
    pool = function(self, wawa, wawa2)
        return true
    end
}
--PUPPY--
SMODS.Joker{
    key = 'PUPPY',
    loc_txt = {
        name = 'PUPPY',
        text = {
            "Adds {C:chips}+ base card value{} worth of {C:chips}Chips{}",
            "for every {C:hearts}Hearts{} card scored",
            "[Currently {C:chips}#1#{}]"
        }},
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    atlas = 'Jokers',
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 6, y = 1},
    config = {
        extra = {
            Chips = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Chips}}
    end,  
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit('Hearts') and not context.blueprint then
                local BonusChips = 0
                if context.other_card and context.other_card:is_face() then
                    BonusChips = 10
                else
                    BonusChips = context.other_card:get_id()
                end
                if BonusChips == 14 then
                    BonusChips = 11
                end
                card.ability.extra.Chips = (card.ability.extra.Chips or 0) + BonusChips
                return {
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize{type='variable', key='a_chips', vars={BonusChips}},
                        colour = G.C.BLUE,
                    }),
                    card = card
                }
            end
        end 
        if context.joker_main and (card.ability.extra.Chips or 0) ~= 0 then
            return {
                chips = card.ability.extra.Chips
            }            
        end
    end,
    pool = function(self, wawa, wawa2)
        return true
    end
}
--JELLOW--
SMODS.Joker{
    key = 'JELLOW',
    loc_txt = {
        name = 'JELLOW',
        text = {
            "Has a {C:attention}50%{} chance to add",
            "{C:mult}+2 Mult{} or {C:money}$4{}",
            "Every {C:attention}4{} rounds, doubles current {C:mult}Mult{} instead",
            "[{C:mult}Double Mult{} in {C:attention}#1#{} rounds]"
        }},
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    atlas = 'Jokers',
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 7, y = 1},
    config = {extra = {Remaining = 4}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Remaining}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.Remaining = card.ability.extra.Remaining - 1
            local chance = love.math.random(1, 2)
            local bonus = love.math.random(1, 2)
            if card.ability.extra.Remaining <= 0 then
                card.ability.extra.Remaining = 4
                return {
                    Xmult_mod = 2,
                    message = string.format('X2')
                }
            elseif chance == 2 then
                if bonus == 1 then
                    return {
                        mult_mod = 2,
                        message = string.format('+2')
                    }
                elseif bonus == 2 then
                    return {
                        dollars = 4
                    }
                end
            end
        end
    end,
    pool = function(self, wawa, wawa2)
        return true
    end
}
--LOOTS--
SMODS.Joker{
    key = 'LOOTS',
    loc_txt = {
        name = 'LOOTS',
        text = {
            "Has a {C:attention}50%{} chance to either grant {C:money}$10{} or steal {C:money}$5{}",
            "after leaving the shop"
        }},
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    atlas = 'Jokers',
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 8, y = 1},
    calculate = function(self, card, context)
        if context.ending_shop then
            local chance = love.math.random(1, 2)
            if chance == 1 then
                return {
                    dollars = -5
                }
            elseif chance == 2 then
                return{
                    dollars = 10
                }
            end
        end
    end,
    pool = function(self, wawa, wawa2)
        return true
    end
}
--MAVLOH--
SMODS.Joker{
    key = 'MAVLOH',
    loc_txt = {
        name = 'MAVLOH',
        text = {
            "Has a {C:attention}33%{} chance to create",
            "a copy of a",
            "used {C:attention}Consumable{} card",
            "does not need space"
        }},
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    atlas = 'Jokers',
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 9, y = 1},
    calculate = function(self, card, context)
        local chance = love.math.random(1, 3)
        if chance == 3 then
            if context.using_consumeable then
                local consumeable_used = context.consumeable
                local key = consumeable_used.config.center.key
                local set = consumeable_used.config.center.set
            
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.5,
                    blockable = false,
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_copied_ex'), colour = G.C.FILTER})
                        local new_consumeable = create_card(set, G.consumeables, nil, nil, nil, nil, key)
                        new_consumeable:add_to_deck()
                        G.consumeables:emplace(new_consumeable)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                    end
                }))
            end
        end
    end,
    pool = function(self, wawa, wawa2)
        return true
    end
}
--VINCE--
SMODS.Joker{
    key = 'VINCE',
    loc_txt = {
        name = 'VINCE',
        text = {
            "Has a {C:attention}50%{} basechance to either",
            "{C:chips}Double{} or {C:chips}Halve{} your {C:chips}Chips{}",
            "The chance to double can be altered by playing specific hands:",
            "{C:green}+6% for every cardsuit if there is more than one{}",
            "{C:green}+6% [<Four of a Kind> / <Two Pair>]{}",
            "{C:green}+12% [<Three of a Kind>]{}",
            "{C:green}+18% [<Pair>]{}",
            "{C:green}+24% [<High Card>]{}"
        }},
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    atlas = 'Jokers',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 7, y = 0},
    config = {
        extra = {
            Chance_Mod = 0,
            Suits = {}
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.Chance_Mod,
                card.ability.extra.Suits
        }}
    end,
    calculate = function(self, card, context)
        local chance_mod = 0
        local suits = {}
        local suits_count = 0
        local basechance = 50
        local chance = love.math.random(1, 100)
        local function contains(list, value)
            for _, v in ipairs(list) do
                if v == value then
                    return true
                end
            end
            return false
        end
        if context.individual and context.other_card then
            --Check Suits--
            if context.other_card:is_suit('Hearts') then
                if not contains(card.ability.extra.Suits, "Hearts") then
                    table.insert(card.ability.extra.Suits, "Hearts")
                end
            elseif context.other_card:is_suit('Spades') then
                if not contains(card.ability.extra.Suits, "Spades") then
                    table.insert(card.ability.extra.Suits, "Spades")
                end
            elseif context.other_card:is_suit('Diamonds') then
                if not contains(card.ability.extra.Suits, "Diamonds") then
                    table.insert(card.ability.extra.Suits, "Diamonds")
                end
            elseif context.other_card:is_suit('Clubs') then
                if not contains(card.ability.extra.Suits, "Clubs") then
                    table.insert(card.ability.extra.Suits, "Clubs")
                end
            end
        end

        if context.joker_main then
            --Check Hand Type--
            if context.scoring_name == "Four of a Kind" or context.scoring_name == "Two Pair" then
                chance_mod = chance_mod + 1
            elseif context.scoring_name == "Three of a Kind" then
                chance_mod = chance_mod + 2
            elseif context.scoring_name == "Pair" then
                chance_mod = chance_mod + 3
            elseif context.scoring_name == "High Card" then
                chance_mod = chance_mod + 4
            end
            --Count Card Suits--
            for _ in pairs(card.ability.extra.Suits) do
                suits_count = suits_count + 1
            end
            if suits_count >= 2 then
                chance_mod = chance_mod + suits_count
            end
            card.ability.extra.Chance_Mod = card.ability.extra.Chance_Mod + chance_mod
            --Modify Chance--
            chance_mod = card.ability.extra.Chance_Mod * 6
            --Reset Variables
            card.ability.extra.Chance_Mod = 0
            card.ability.extra.Suits = {}
            --Count Chance--
            basechance = basechance + chance_mod
            if basechance >= chance then
                return{
                    message = localize{type = 'variable', key = 'a_xmult', vars = {2}},
                    Xmult_mod = 2
                }
            else 
                return{
                    message = "X0.5",
                    Xmult_mod = 0.5
                }
            end
        end
    end,
    pool = function(self, wawa, wawa2)
        return true
    end
}
--HEY SUBSCRIBER?--
SMODS.Joker{
    key = 'HEY SUBSCRIBER?',
    loc_txt = {
        name = 'HEY SUBSCRIBER?',
        text = {
            "After scoring a hand, one of the following",
            "may happen at {C:attention}random{}:",
            "{C:mult}X2 Mult{}, {C:mult}X0 Mult{},",
            "gain {C:money}$25{}, {C:attention}destroy a Joker{},",
            "or nothing at all"
        }},
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    atlas = 'Jokers',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 8, y = 0},
    calculate = function(self, card, context)
        local chance = love.math.random(1, 5)
        if context.joker_main then
            if chance == 1 then
                return{
                    Xmult_mod = 2,
                    message = "X2"
                }
            elseif chance == 2 then
                return{
                    Xmult_mod = 0,
                    message = "X2"
                }
            elseif chance == 3 then
                return{
                    dollars = 25
                }
            elseif chance == 4 then
                local jokers_to_slice = {}
                local jId = 0
                for i = 1, #G.jokers.cards do
                    local j = G.jokers.cards[i]
                    if j ~= card and not j.ability.eternal and not j.getting_sliced then
                        table.insert(jokers_to_slice, i)
                        jId = jId + 1
                    end
                    if jId > 1 then
                        local sliceChance = love.math.random(1, jId)
                        local jokerToSlice = jokers_to_slice[sliceChance]
                        G.jokers.cards[jokerToSlice].getting_sliced = true
                        G.E_MANAGER:add_event(Event({func = function()
                            G.GAME.joker_buffer = 0
                            card:juice_up(0.8, 0.8)
                            G.jokers.cards[jokerToSlice]:start_dissolve({HEX("FE0032")}, nil, 1.6)
                            play_sound('slice1', 0.96 + math.random() * 0.08)
                            return true
                        end}))
                    elseif jId == 1 then
                        local jokerToSlice = jokers_to_slice[1]
                        G.jokers.cards[jokerToSlice].getting_sliced = true
                        G.E_MANAGER:add_event(Event({func = function()
                            G.GAME.joker_buffer = 0
                            card:juice_up(0.8, 0.8)
                            G.jokers.cards[jokerToSlice]:start_dissolve({HEX("FE0032")}, nil, 1.6)
                            play_sound('slice1', 0.96 + math.random() * 0.08)
                            return true
                        end}))
                    end
                end
            end
        end
    end,
    pool = function(self, wawa, wawa2)
        return true
    end
}
--NEO--
SMODS.Joker{
    key = 'NEO ROYAL',
    loc_txt = {
        name = 'NEO ROYAL',
        text = {
            "Every {C:attention}3rd{} played hand grants",
            "{C:money}$15{}",
            "[triggers in {C:attention}#1#{} hands]"
        }},
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    atlas = 'Jokers',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 9, y = 0},
    config = {
        extra = {
            Hand = 3
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.Hand
        }}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.Hand = card.ability.extra.Hand - 1
            if card.ability.extra.Hand == 0 then
                card.ability.extra.Hand = 3
                return{
                    dollars = 15
                }
            end
        end
    end,
    pool = function(self, wawa, wawa2)
        return true
    end
}
--THE INSTITUTION--
SMODS.Joker{
    key = 'THE INSTITUTION',
    loc_txt = {
        name = 'THE INSTITUTION',
        text = {
            "Has a {C:green}20%{} chance to convert a",
            "playeed card into a {C:attention}Wild Card{}",
            "Does not have to score"
        }},
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    atlas = 'Jokers',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 1},
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local thunk = 0
            for k, v in ipairs(context.full_hand) do
                local chance = love.math.random(1, 5)
                if v.config.center.key ~= "m_wild" and chance == 5 then
                    thunk = thunk + 1
                    v:set_ability(G.P_CENTERS.m_wild, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            return true
                        end
                    })) 
                end
            end
            if thunk > 0 then
                return{
                    message = 'whats that?',
                    colour = G.C.PURPLE
                }
            end
        end
    end,
    pool = function(self, wawa, wawa2)
        return true
    end
}
--2BG--
SMODS.Joker{
    key = '2BG',
    loc_txt = {
        name = '2BG',
        text = {
            "If your hand is a {C:attention}High Card{},",
            "gain {C:money}$15{}"
        }},
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    atlas = 'Jokers',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 1},
    calculate = function(self, card, context)
        if context.joker_main then
            --Check Hand Type--
            if context.scoring_name == "High Card" then
                return {
                    dollars = 15
                }
            end 
        end
    end,
    pool = function(self, wawa, wawa2)
        return true
    end
}
--TWITCH--
SMODS.Joker{
    key = 'TWITCH',
    loc_txt = {
        name = 'TWITCH',
        text = {
            "Earn {C:money}$2{} for every owned {C:attention}Joker{}",
            "at the end of a round"
        }},
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    atlas = 'Jokers',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 2, y = 0},
    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers then
            local j = 0
            for i = 1, #G.jokers.cards do
                j = j + 1
            end
            local money = j * 2
            return{
                dollars = money
            }
        end
    end,
    pool = function(self, wawa, wawa2)
        return true
    end
}
--MAXWELL--
SMODS.Joker{
    key = 'MAXWELL',
    loc_txt = {
        name = 'MAXWELL',
        text = {
            "If you play a hand with exactly 1 face card,",
            "gain {C:money}$8{} and {C:chips}+20{} chips"
        }},
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    atlas = 'Jokers',
    rarity = 3,
    cost = 9,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 2, y = 1},
    config = {
        extra = {
            Faces = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.Faces
        }}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card and context.other_card:is_face() then
                card.ability.extra.Faces = card.ability.extra.Faces + 1
            end
        end
        if context.joker_main then
            local checkFaces = card.ability.extra.Faces
            card.ability.extra.Faces = 0 
            if checkFaces == 1 then
                return {
                    chips = 20,
                    dollars = 8
                }
            end
        end
    end,
    pool = function(self, wawa, wawa2)
        return true
    end
}
--THE PAW--
SMODS.Joker{
    key = 'THE PAW',
    loc_txt = {
        name = 'THE PAW',
        text = {
            "The first card played each hand gains",
            "{C:chips}+50 chips{} and {C:mult}+1 Mult{}"
        }},
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    atlas = 'Jokers',
    rarity = 3,
    cost = 9,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 3, y = 1},
    config = {
        extra = {
            Applied = false
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.Applied
        }}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not card.ability.extra.Applied then
            if context.other_card then
                context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) + 50
                context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0) + 1
                card.ability.extra.Applied = true
                return {
                    extra = { message = "+50 Chips +1 Mult" },
                    card = card
                }
            end
        end
        if context.joker_main then
            card.ability.extra.Applied = false
        end
    end,
    pool = function(self, wawa, wawa2)
        return true
    end
}
--AMKIR--
SMODS.Joker{
    key = 'AMKIIR',
    loc_txt = {
        name = 'AMKIIR',
        text = {
            "Every {C:attention}3rd hand{} played",
            "grants a {C:attention}Tarot{} card.",
            "Does not need space",
            "[triggers in {C:attention}#1#{} hands]"
        }},
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    atlas = 'Jokers',
    rarity = 3,
    cost = 9,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 4, y = 1},
    config = {
        extra = {
            Hand = 3
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.Hand
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.Hand = card.ability.extra.Hand - 1
            if card.ability.extra.Hand == 0 then
                card.ability.extra.Hand = 3
                card:juice_up(0.8, 0.8)
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        local _card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'mmx')
                        _card:add_to_deck()
                        G.consumeables:emplace(_card)
                    return true
                    end)
                }))
            end
        end
    end,
    pool = function(self, wawa, wawa2)
        return true
    end
}
--NEDRUNOS--
SMODS.Joker{
    key = 'NEDRUNOS',
    loc_txt = {
        name = 'NEDRUNOS',
        text = {
            "Each scoring card has a {C:green}25%{} chance",
            "to add {C:mult}X2{} to itself",
            "[by default every card is a X1]"
        }},
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    atlas = 'Jokers',
    rarity = 3,
    cost = 9,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 5, y = 1},
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local chance = love.math.random(1, 4)
            if chance == 4 then
                if context.other_card then
                    context.other_card.ability.perma_x_mult = 2
                    return {
                        extra = { message = "BLESSED" },
                        card = card
                    }
                end
            end
        end
    end,
    pool = function(self, wawa, wawa2)
        return true
    end
}
--KORRK--
SMODS.Joker{
    key = 'KORRK',
    loc_txt = {
        name = 'KORRK',
        text = {
            "Each time Cards get discarded",
            "add {C:mult}+1 Mult{} and {C:chips}+20 Chips{}",
            "to this joker",
            "[currently {C:mult}+#2# Mult{} and {C:chips}+#1# Chips{}]"
        }},
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    atlas = 'Jokers',
    rarity = 4,
    cost = 12,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    config = {
        extra = {
            Chips = 0,
            Mult = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.Chips,
                card.ability.extra.Mult
            }
        }
    end,
    calculate = function(self, card, context)
        if context.pre_discard and not context.blueprint then
            card.ability.extra.Chips = card.ability.extra.Chips + 20
            card.ability.extra.Mult = card.ability.extra.Mult + 1
            card:juice_up(0.8, 0.8)
        end
        if context.joker_main then
            if card.ability.extra.Chips > 0 and card.ability.extra.Mult > 0 then
                return
                {
                    chips = card.ability.extra.Chips,
                    mult_mod = card.ability.extra.Mult,
                    message = string.format("+%d", card.ability.extra.Mult)
                }
            end
        end
    end,
    pool = function(self, wawa, wawa2)
        return true
    end
}
--HERGORN--
SMODS.Joker{
    key = 'HERGORN',
    loc_txt = {
        name = 'HERGORN',
        text = {
            "{C:mult}+5 Mult{}, {C:chips}+100 Chips{}, {C:money}+$25{}.",
            "Every {C:attention}4 hands{} this {C:attention}joker{} gets upgraded by",
            "{C:mult}+4 Mult{}  {C:chips}+30 Chips{} and {C:money}+$10{}",
            "[currently {C:mult}+#2# Mult{}, {C:chips}+#1# Chips{} and {C:money}+#3#${}]",
            "[{C:attention}Upgrade{} in {C:attention}#4#{} hands]"
        }},
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    atlas = 'Jokers',
    rarity = 4,
    cost = 12,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 0},
    config = {
        extra = {
            Chips = 100,
            Mult = 5,
            Dollars = 25,
            Hands = 4
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.Chips,
                card.ability.extra.Mult,
                card.ability.extra.Dollars,
                card.ability.extra.Hands
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.Hands = card.ability.extra.Hands - 1
            if card.ability.extra.Hands == 0 then
                card.ability.extra.Chips = card.ability.extra.Chips + 30
                card.ability.extra.Mult = card.ability.extra.Mult + 4
                card.ability.extra.Dollars = card.ability.extra.Dollars + 10
                card.ability.extra.Hands = 4
                message = string.format("UPGRADED")
                card:juice_up(0.8, 0.8)
            end
            return
            {
                chips = card.ability.extra.Chips,
                dollars = card.ability.extra.Dollars,
                mult_mod = card.ability.extra.Mult,
                message = string.format("+%d", card.ability.extra.Mult)
            }
        end
    end,
    pool = function(self, wawa, wawa2)
        return true
    end
}
----------------------------------------------
------------MOD CODE END----------------------