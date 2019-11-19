
--Simple Example
print("Starting Lua for Memory Game")
require "CommonLibs/vec3"
math.randomseed(os.time())

splashMessage = [[Welcome to Memory Tiles!
Behind each of the tiles are
8 pairs of items, randomly
scrambled and waiting for
you to find!]]

endMessage = [[**Great job! You won!**
Right click anywhere to play the next level.
Otherwise, exit by pressing ESC.]]

CameraPosX = -6.0
CameraPosY = 1.0
CameraPosZ = 0.0

CameraDirX = 1.0
CameraDirY = -0.0
CameraDirZ = -0.0

CameraUpX = 0.0
CameraUpY = 1.0
CameraUpZ = 0.0

CameraPos = vec3(CameraPosX, CameraPosY, CameraPosZ)
CameraDir = vec3(CameraDirX, CameraDirY, CameraDirZ)
CameraUp = vec3(CameraUpX, CameraUpY, CameraUpZ)

-- Game state variables
boardSize = 4
flipVelocity = 4.0
maxFlipTime = 1.5
flippedUpTime = 0.0
firstFlipped = nil
secondFlipped = nil
match = false
finished = false
numMatches = 0

-- Board state variables
spacingY = 1.1 --Give a small space between grid cells to create boundries
startingY = -.6
startingZ = -1.8
spacingZ = 1.2

-- Arrays containing world objects
tiles = {}        -- array mapping index --> modelID
tileItems = {}    -- array mapping index --> item string
items = {"Tower", "Crystal", "Pug", "Sheep", "Ship", "Poplar", "Bottle", "Carrot"}
modelIndices = {} -- array mapping modelID --> index

-- Array containing amount each tile has rotated in radians
flipped = {}

--Tile variables
gridLayer = 0
curPos = {}
curScale = {}
colliders = {}


function frameUpdate(dt)

end


function keyHandler(keys)
  -- if keys.up then
  --   deleteBoard()
  --   initializeBoard()
  -- end
end

-- Mouse handler
function mouseHandler(mouse)
  if (mouse.left and not haveClicked) then
    -- TODO: next level with left click...
    
    -- See which grid item we clicked on
    hitID, dist = getMouseClickWithLayer(gridLayer)
    print("What is hitID"..hitID)
    print("What is tileItems[modelIndices[idx]]"..tileItems[modelIndices[hitID]])
    local xVal = curPos[hitID].x - 1
    placeModel(hitID, xVal, curPos[hitID].y, curPos[hitID].z)
    curPos[hitID].x = xVal
    --readShaderSource is another option
    --initFinalCompositeShader()
    --buffer = readShaderSource("quad-frag.glsl")
    haveClicked = true
  end

  if (not mouse.left) then
    haveClicked = false
  end
end


function initializeBoard()
  -- make sure everything is empty
  tiles = {}
  modelIndices = {}
  curPos = {}
  curScale = {}
  colliders = {}
  animatedModels = {}

  idx = 1
  for i = 1, boardSize*boardSize do
    flipped[idx] = 0
  end


  -- randomize order of tileItems
  shuffle(tileItems)

  -- Create a 4x4 grid of tiles
  -- fill tiles according to tileItems
  local idx = 1
  for i = 0,3 do
    for j = 0,3 do
      pos = vec3(0, startingY + spacingY*i, startingZ + spacingZ*j)

      -- find prefab that matches the item
      tiles[idx] = addModel(tileItems[idx].."Card", pos.x, pos.y, pos.z)
      modelIndices[tiles[idx]] = idx

      --Grid cell needs a collider for click interaction
      colliders[tiles[idx]] = addCollider(tiles[idx], gridLayer, 0.6, 0, 0, 0)
      curScale[tiles[idx]] = 1
      curPos[tiles[idx]] = vec3(pos.x,pos.y,pos.z)
      idx = idx + 1
    end
  end
end

-- shuffle copied from: https://gist.github.com/Uradamus/10323382
function shuffle(tbl)
  for i = #tbl, 2, -1 do
    -- swap item at the end with another before it
    local j = math.random(i)
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end



-- fill tileItems, 2 at a time
idx = 1
for i = 1, boardSize*boardSize, 2 do
  tileItems[i] = items[idx]
  -- flipped[i] = 0

  tileItems[i+1] = items[idx]
  -- flipped[i+1] = 0
  idx = idx + 1
end

initializeBoard()