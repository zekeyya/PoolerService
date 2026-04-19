--!strict

local Types = {}

--=========================
-- // TYPES
--=========================

export type pool = {
	Folder: Folder,
	Objects: { [string]: {Instance} }
}

export type findPoolReturnType = "Table" | "Index"

return Types