local variants = {
    "one-to-one-forward",
    "one-to-two-perpendicular",
    "one-to-three-forward",
    "one-to-four",
    "underground-i",
    "underground-L",
    "underground-t",
    "underground-cross",
}

local tiers = {
    {
        coupler = "small-pipe-coupler",
        coupler_new = "small-pipe-coupler",
        segment = "underground-pipe-segment-t1",
        suffix = "",
        multiplier = 1,
        pipe = "pipe",
    },
    {
        coupler = "medium-pipe-coupler",
        coupler_new = "small-pipe-coupler",
        segment = "underground-pipe-segment-t2",
        suffix = "-t2",
        multiplier = 2,
        pipe = "pipe",
    },
    {
        coupler = "large-pipe-coupler",
        coupler_new = "small-pipe-coupler",
        segment = "underground-pipe-segment-t3",
        suffix = "-t3",
        multiplier = 3,
        pipe = "pipe",
    },
    {
        coupler = "space-pipe-coupler",
        coupler_new = "space-pipe-coupler",
        segment = "underground-pipe-segment-space",
        suffix = "-space",
        multiplier = 1,
        pipe = "se-space-pipe",
    }
}

for _, tier_data in pairs(tiers) do
    for _, variant in pairs(variants) do
        local recipe = data.raw.recipe[variant .. tier_data.suffix .. "-pipe" ]
        if recipe then
            local swivels = 0
            local pipes = 0
            local couplers = 0

            for _, ingredient in ipairs(recipe.ingredients) do
                if ingredient[1] == tier_data.pipe then
                    pipes = pipes + ingredient[2]
                elseif ingredient[1] == tier_data.segment then
                    pipes = pipes + (ingredient[2] * tier_data.multiplier)
                elseif ingredient[1] == tier_data.coupler then
                    couplers = ingredient[2]
                elseif ingredient[1] == "swivel-joint" then
                    swivels = swivels + ingredient[2]
                end
            end

            local ingredients = {}
            if swivels  > 0 then table.insert(ingredients, { "swivel-joint",        swivels  }) end
            if couplers > 0 then table.insert(ingredients, { tier_data.coupler_new, couplers }) end
            if pipes    > 0 then table.insert(ingredients, { tier_data.pipe,        pipes    }) end

            recipe.ingredients = ingredients
        end
    end
end

local function replace_ingredients(recipe_name, ingredients)
    local recipe = data.raw.recipe[recipe_name]
    if recipe then
        recipe.ingredients = ingredients
    end
end

replace_ingredients("underground-mini-pump", {
    {"engine-unit", 1},
    {"steel-plate", 1},
    {"small-pipe-coupler", 2},
    {"pipe", 10},
})

replace_ingredients("4-to-4-pipe", {
    {"small-pipe-coupler", 4},
    {"pipe", 21},
})

replace_ingredients("underground-space-pump", {
    {"engine-unit", 1},
    {"se-heavy-girder", 1},
    {"space-pipe-coupler", 2},
    {"se-space-pipe", 10},
})

local hide = {
    "medium-pipe-coupler",
    "large-pipe-coupler",
    "underground-pipe-segment-t1",
    "underground-pipe-segment-t2",
    "underground-pipe-segment-t3",
    "underground-pipe-segment-space",
}

for _, name in pairs(hide) do
    recipe = data.raw.recipe[name]
    if recipe then
        recipe.hidden = true
    end
end