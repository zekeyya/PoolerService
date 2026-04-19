--!strict

local PoolerService = {}

--=========================
-- // IMPORTS
--=========================

-- // MODULES
local Constants = require("@self/Constants")
local Types = require("@self/Types")

-- // POOLING FOLDER
local PoolFolder = Constants.POOLS_FOLDER
PoolFolder.Name = Constants.POOLS_FOLDER_NAME
PoolFolder.Parent = Constants.POOLS_FOLDER_PARENT

--=========================
-- // STATE
--=========================

PoolerService.Pools = {} :: { Types.pool }

--=========================
-- // PRIVATE API
--=========================

-- FindPoolByName(): Finds a pool by name
-- @param name: The name of the pool to find
-- @returnType: The type of return, instance (true) or index of instance (false)
-- @return: The pool table/index or nil if not found
local function FindPoolByName(name: string, returnType: Types.findPoolReturnType): any
	for index = 1, #PoolerService.Pools do
		local pool = PoolerService.Pools[index]

		if pool and pool.Folder and pool.Folder.Name == name then
			if returnType == "Table" then
				return pool
			else
				return index
			end
		end
	end

	return nil
end

-- FindPool(): Finds a pool by table
-- @param pool: The pool table to find
-- @return: The pool table or nil if not found
local function FindPool(pool: Types.pool): number?
	for index = 1, #PoolerService.Pools do
		if PoolerService.Pools[index] == pool then
			return index
		end
	end

	return nil
end

--=========================
-- // PUBLIC API
--=========================

-- CreatePool(): Creates a new pool
-- @param name: The name of the pool
-- @return: The new pool
function PoolerService.CreatePool(name: string): Types.pool?
	if FindPoolByName(name, "Table") then
		warn("PoolerService.CreatePool(): Pool '" .. name .. "' already exists.")
		return nil
	end
	
	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = PoolFolder
	
	local newPool = {}
	newPool.Folder = folder
	newPool.Objects = {} :: { [string]: { Instance } }

	table.insert(PoolerService.Pools, newPool)

	return newPool
end

-- GetPool(): Returns a pool by name
-- @param name: The name of the pool to retrieve
-- @return: The pool table or nil if not found
function PoolerService.GetPool(name: string): Types.pool?
	local pool = FindPoolByName(name, "Table")
	
	if not pool then 
		warn("PoolerService.GetPool(): Pool '" .. name .. "' does not exist.") 
		return nil
	end
	
	return pool
end

-- DeletePool(): Deletes a pool by name
-- @param name: The name of the pool to delete
function PoolerService.DeletePool(pool: Types.pool): ()
	local poolIndex = FindPool(pool)
	
	if not poolIndex then 
		warn("PoolerService.DeletePool(): Pool does not exist.")
		return
	end
	
	pool.Folder:Destroy()
	pool.Objects = {}
	table.remove(PoolerService.Pools, poolIndex)
end

-- AddObject(): Adds an object to a pool
-- @param pool: The pool to add the object to
-- @param object: The object to add to the pool
function PoolerService.AddObject(pool: Types.pool, object: Instance): ()	
	object.Parent = pool.Folder
	
	pool.Objects[object.Name] = pool.Objects[object.Name] or {}
	table.insert(pool.Objects[object.Name], object)
end

-- GetObject(): Gets the first object from a pool with the specified name
-- @param pool: The pool to get the object from
-- @param name: The name of the object to get
-- @return: The object or nil if not found
function PoolerService.GetObject(pool: Types.pool, name: string): Instance?
	local list = pool.Objects[name]

	for i = 1, #list do
		local object = list[i]

		if object and object.Parent == pool.Folder then
			return object
		end
	end

	warn("GetObject(): No valid instances found for '" .. name .. "'.")
	return nil
end

-- TakeObject(): Removes an object from a pool and changes the parent
-- @param pool: The pool to take the object from
-- @param object: The object to remove from the pool
-- @param parent: The new parent for the object
-- @return: True if successfully taken, false otherwise
function PoolerService.TakeObject(pool: Types.pool, object: Instance, parent: any): boolean
	if not object or object.Parent ~= pool.Folder then
		warn("PoolerService.TakeObject(): Object does not exist in the pool '" .. pool.Folder.Name .. "'.")
		return false
	end

	local list = pool.Objects[object.Name]

	if list then
		for index = 1, #list do
			if list[index] == object then
				table.remove(list, index)
				break
			end
		end
	end

	object.Parent = parent

	return true
end

-- DestroyObject(): Destroys an object from a pool
-- @param pool: The pool to destroy the object from
-- @param object: The object to destroy from the pool
-- @return: True if the object was destroyed, false otherwise
function PoolerService.DestroyObject(pool: Types.pool, object: Instance): boolean
	if not object or object.Parent ~= pool.Folder then
		warn("PoolerService.DestroyObject(): Object does not exist in the pool '" .. pool.Folder.Name .. "'.")
		return false
	end
	
	local list = pool.Objects[object.Name]

	if list then
		for index = 1, #list do
			if list[index] == object then
				table.remove(list, index)
				break
			end
		end
	end

	object:Destroy()
	return true
end

-- ClearPool(): Clears all objects from a pool
-- @param pool: The pool to clear
-- @return: True if the pool was cleared, false otherwise
function PoolerService.ClearPool(pool: Types.pool): ()
	local children = pool.Folder:GetChildren()
	
	for i = 1, #children do
		children[i]:Destroy()
	end

	pool.Objects = {}

	return
end

return PoolerService

