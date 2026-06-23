-- ============================================================
-- containers
-- ============================================================
for _, container in pairs(data.raw.container) do
  container.damaged_trigger_effect = nil
  container.dying_explosion = nil
end

-- ============================================================
-- walls
-- ============================================================
for _, wall in pairs(data.raw.wall) do
  wall.damaged_trigger_effect = nil
  wall.dying_explosion = nil
end

-- ============================================================
-- turrets
-- ============================================================
data.raw["ammo-turret"]["railgun-turret"].attack_parameters.shell_particle = nil
data.raw["ammo-turret"]["gun-turret"].attack_parameters.shell_particle = nil

-- ============================================================
-- units (biters / spitters)
-- ============================================================
for _, unit in pairs(data.raw.unit) do
  if unit.name:find("biter") or unit.name:find("spitter") then
    unit.damaged_trigger_effect = nil
    unit.dying_explosion = nil
  end
end

-- ============================================================
-- explosions
-- ============================================================

-- strip specific create-particle effects from explosion chains
local target_particles = {
  ["cable-and-electronics-particle-small-medium"] = true,
  ["car-metal-particle-small"] = true,
  ["car-metal-particle-medium"] = true,
  ["car-metal-particle-big"] = true,
}

local function strip_target_particle_effects(target_effects)
  if type(target_effects) ~= "table" then return end
  for i = #target_effects, 1, -1 do
    local effect = target_effects[i]
    if type(effect) == "table" and effect.type == "create-particle" and target_particles[effect.particle_name] then
      table.remove(target_effects, i)
    end
  end
end

for _, explosion in pairs(data.raw.explosion) do
  -- remove blood explosions entirely
  if explosion.name:find("blood") then
    explosion.created_effect = nil
  end

  -- strip targeted particles from all other explosions
  local ce = explosion.created_effect
  if type(ce) == "table" then
    local actions = ce.type and {ce} or ce
    for _, action in pairs(actions) do
      if type(action.action_delivery) == "table" then
        local deliveries = action.action_delivery.type and {action.action_delivery} or action.action_delivery
        for _, delivery in pairs(deliveries) do
          strip_target_particle_effects(delivery.target_effects)
        end
      end
    end
  end
end
