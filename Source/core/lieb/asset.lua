--[[
	Load assets in a single array

	asset("name_of_asset") to access the loaded asset

	TODO
	load sfx
	lazy loading https://devforum.play.date/t/best-practices-for-managing-lots-of-assets/395
	asset hot reloading
]] --

local gfx <const> = playdate.graphics

import 'core/lieb/readFolder'

local _assetList = {}

asset = setmetatable({}, {
	__call = function(self, assetName) return _assetList[assetName] end
})

function asset.loadImage(imagePath, assetName)
	assetName = assetName or imagePath

	_assetList[assetName] = gfx.image.new(imagePath)
end

function asset.loadImageFolder(folderPath)
	readFolder(folderPath, function(filepath, folder, filename)
		asset.loadImage(filepath, filename:sub(1, -5))
	end, ".pdi")
end

function asset.set(assetName, asset)
	_assetList[assetName] = asset
end

function asset.free(assetName)
	_assetList[assetName] = nil
end

function asset.freeAll()
	_assetList = {}
end

function asset.printList()
	print("Asset List")
	printT(_assetList)
end
