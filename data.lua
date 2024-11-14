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

local only_pipes = settings.startup["lafh_only_pipes"].value

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
        local recipe = data.raw.recipe[variant .. tier_data.suffix .. "-pipe"]
        if recipe then
            local swivels = 0
            local pipes = 0
            local couplers = 0

            for _, ingredient in ipairs(recipe.ingredients) do
                if ingredient.name == tier_data.pipe then
                    pipes = pipes + ingredient.amount
                elseif ingredient.name == tier_data.segment then
                    pipes = pipes + (ingredient.amount * tier_data.multiplier)
                elseif ingredient.name == tier_data.coupler then
                    couplers = ingredient.amount
                elseif ingredient.name == "swivel-joint" then
                    swivels = swivels + ingredient.amount
                end
            end

            local ingredients = {}
            if only_pipes then
                if pipes    > 0 then table.insert(ingredients, {type="item", name=tier_data.pipe,        amount=pipes + swivels * 2 + couplers }) end
            else
                if swivels  > 0 then table.insert(ingredients, {type="item", name="swivel-joint",        amount=swivels  }) end
                if couplers > 0 then table.insert(ingredients, {type="item", name=tier_data.coupler_new, amount=couplers }) end
                if pipes    > 0 then table.insert(ingredients, {type="item", name=tier_data.pipe,        amount=pipes    }) end
            end

            recipe.ingredients = ingredients
        end
    end
end

local function replace_ingredients(recipe_name, ingredients, ingredients2)
    local recipe = data.raw.recipe[recipe_name]
    if not recipe then return end

    recipe.ingredients = ingredients
    if not only_pipes and ingredients2 then
        for _, ingredient in pairs(ingredients2) do
            table.insert(recipe.ingredients, ingredient)
        end
    end
end

if mods["aai-industry"] then
    replace_ingredients("underground-mini-pump", {
        {type="item", name="electric-motor",     amount= 2},
        {type="item", name="steel-plate",        amount= 1},
        {type="item", name="pipe",               amount=12},
    }, {
        {type="item", name="small-pipe-coupler", amount= 2},
    })
else
    replace_ingredients("underground-mini-pump", {
        {type="item", name="engine-unit",        amount= 1},
        {type="item", name="steel-plate",        amount= 1},
        {type="item", name="pipe",               amount=12},
    }, {
        {type="item", name="small-pipe-coupler", amount= 2},
    })
end

replace_ingredients("4-to-4-pipe", {
    {type="item", name="pipe",               amount=25},
}, {
    {type="item", name="small-pipe-coupler", amount= 4},
})

replace_ingredients("underground-space-pump", {
    {type="item", name="electric-motor",     amount= 2},
    {type="item", name="se-space-pipe",      amount=12},
}, {
    {type="item", name="se-heavy-girder",    amount= 1},
    {type="item", name="space-pipe-coupler", amount= 2},
})

local function hide_recipes(recipe_names)
    for _, name in pairs(recipe_names) do
        recipe = data.raw.recipe[name]
        if recipe then
            recipe.hidden = true
        end
    end
end

hide_recipes({
    "medium-pipe-coupler",
    "large-pipe-coupler",
    "underground-pipe-segment-t1",
    "underground-pipe-segment-t2",
    "underground-pipe-segment-t3",
    "underground-pipe-segment-space",
})

if only_pipes then
    hide_recipes({
        "swivel-joint",
        "small-pipe-coupler",
        "space-pipe-coupler",
    })
end
