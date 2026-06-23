-- remove all damage effects from containers (steel-chest, iron-chest, etc.)
for _, container in pairs(data.raw.container) do
  container.damaged_trigger_effect = nil
  container.dying_explosion = nil
end

-- remove all damage effects from walls (steel-chest, iron-chest, etc.)
for _, wall in pairs(data.raw.wall) do
  wall.damaged_trigger_effect = nil
  wall.dying_explosion = nil
end

-- remove railgun turret shell particle
data.raw["ammo-turret"]["railgun-turret"].attack_parameters.shell_particle = nil
-- remove ammot turret shell particle
data.raw["ammo-turret"]["gun-turret"].attack_parameters.shell_particle = nil

-- remove animation of big biter death
data.raw["unit"]["big-biter"].dying_explosion = nil