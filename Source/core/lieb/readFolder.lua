--[[
readFolder() execute a function on all files in a folder filtered by extension

function receive the following arguments: fn( filepath, folder, filename)
	filepath (e.g. "folder/file.txt")
	folder (e.g. "folder/")
	filename (e.g. "file.txt")
]]--


function readFolder( folder, fn, extension, recursive )
	if type(fn)~="function" then
		error( "readFolder() needs a valid function", 2)
		return
	end

	extension = extension or ""

	folder = folder or "/"
	if string.byte("/", 1)~=string.byte(folder, -1) then
		folder = folder.."/"
	end

	local files = playdate.file.listFiles( folder )
	if not files then
		return
	end

	local extensionlength = #extension
	local extensionBytes = { string.byte( extension, 1, -1) }

	for indexFile, filename in ipairs( files ) do
		local fullpath = folder..filename
		if playdate.file.isdir(fullpath) then
			if recursive then
				readFolder( fullpath, recursive )
			end
			goto nextFile
		end

		-- check file extension
		local fileExtBytes = { string.byte( filename, -extensionlength, -1) }
		for i = 1, extensionlength do
			if fileExtBytes[i]~=extensionBytes[i] then
				goto nextFile
			end
		end

		-- call function on file
		fn( fullpath, folder, filename )

		::nextFile::
	end
end