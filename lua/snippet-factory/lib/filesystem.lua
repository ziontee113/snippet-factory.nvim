local M = {}

local uv = vim.loop

M.readFileSync = function(path)
	local fd = assert(uv.fs_open(path, "r", 438))

	local stat = assert(uv.fs_fstat(fd))
	local data = assert(uv.fs_read(fd, stat.size, 0))
	assert(uv.fs_close(fd))

	return data
end

M.writeFileSync = function(path, flag, lines)
	local fd = assert(uv.fs_open(path, flag, 438))

	for _, line in ipairs(lines) do
		uv.fs_write(fd, line, -1)
	end

	uv.fs_close(fd)
end

return M
