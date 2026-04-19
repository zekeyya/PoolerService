# PoolerService

**PoolerService** is a Roblox module for pooling instances to help avoid constant instance Destroy() and Clone() usage which hurts performance in large scale systems.

Key features:

- Get pool, add pool, delete pool
- Pool modification - delete/take/add/get objects in pool

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
```