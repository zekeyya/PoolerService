**PoolerService** is a Roblox module for pooling instances to help avoid constant instance Destroy() and Clone() usage which hurts performance in large scale systems.

Key features:

- Get pool, add pool, delete pool
- Pool modification - delete/take/add/get objects in pool

## Performance Test

Quick memory test - Creating 10,000 parts and then destroying all after 3 seconds every 8 seconds vs using PoolerService module:

Before:
<img width="765" height="27" alt="image" src="https://github.com/user-attachments/assets/01b81110-8f5c-4039-a90e-c365d7d49903" />

After:
<img width="771" height="25" alt="image" src="https://github.com/user-attachments/assets/9b731cb9-a5b7-43d5-b5e9-837e170d7883" />

## How to Use

### Pool Management

```lua
local PoolerService = require(Path.to.PoolerService)

-- // Create your pool:
local MyPool = PoolerService.CreatePool("MyPoolName")

-- // Getting an already existing pool:
local MyPool = PoolerService.GetPool("MyPoolName")

-- // Delete your pool:
PoolerService.DeletePool(MyPool)

-- // Clear all objects from your pool:
PoolerService.ClearPool(MyPool)
```

### Object Management

```lua
local PoolerService = require(Path.to.PoolerService)

-- // Create your pool and instance(s)
local MyPool = PoolerService.CreatePool("MyPoolName")
local Part = Instance.new("Part")
Part.Name = "MyPart"

-- // Add an object to the pool:
PoolerService.AddObject(MyPool, Part)

-- // Get an object from a pool:
local Object = PoolerService.GetObject(MyPool, "MyPart")

-- // Take an object from the pool (removes from pool and re-parents it):
PoolerService.TakeObject(MyPool, Object, game.Workspace)

-- // Destroy an object completely (removes from pool and destroys it):
PoolerService.DestroyObject(MyPool, Object)
```
