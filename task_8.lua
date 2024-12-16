function lines_from(file)
  local lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

local lines = lines_from('input/8.txt')

local h = #lines
local w = #lines[1]

-- print('Number of rows: ' .. h)
-- print('Number of cols: ' .. w)

local tower_collections = {}
local is_antinode = {}
local is_antinode_ext = {}

for i = 1, h do
  is_antinode[i] = {}
  is_antinode_ext[i] = {}
  
  for j = 1, w do
    is_antinode[i][j] = false
    is_antinode_ext[i][j] = false

    local character = lines[i]:sub(j, j)
    -- io.write('' .. lines[i]:sub(j, j))
    if character ~= "." then
      -- print('Found '..character..' at i='..i..' j='..j)
      if tower_collections[character] == nil then
        tower_collections[character] = {}
      end
      table.insert(tower_collections[character], {i, j})
    end
  end
  -- print()
end

for c, coll in pairs(tower_collections) do
  for k1, v in pairs(coll) do
    local i1 = v[1]
    local j1 = v[2]

    for k2, v in pairs(coll) do
      local i2 = v[1]
      local j2 = v[2]
      
      if k2 > k1 then
        local di = i1 - i2
        local dj = j1 - j2
        
        for d = -100, 100 do
          if i1 + di*d > 0 and i1 + di*d <= h and j1 + dj*d > 0 and j1 + dj*d <= w then
            if d == 1 or d == -2 then
              is_antinode[i1 + di*d][j1 + dj*d] = true
            end
            is_antinode_ext[i1 + di*d][j1 + dj*d] = true
          end
        end
      end

    end
  end
end

local count1 = 0
local count2 = 0

for i = 1, h do
  for j = 1, w do
    if is_antinode[i][j] then
      count1 = count1 + 1
    end
    if is_antinode_ext[i][j] then
      count2 = count2 + 1
    end
  end
end

print("Task 1: "..count1)
print("Task 2: "..count2)