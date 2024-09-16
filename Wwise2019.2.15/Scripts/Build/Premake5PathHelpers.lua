--[[----------------------------------------------------------------------------
The content of this file includes portions of the AUDIOKINETIC Wwise Technology
released in source code form as part of the SDK installer package.

Commercial License Usage

Licensees holding valid commercial licenses to the AUDIOKINETIC Wwise Technology
may use this file in accordance with the end user license agreement provided
with the software or, alternatively, in accordance with the terms contained in a
written agreement between you and Audiokinetic Inc.

  Version: <VERSION>  Build: <BUILDNUMBER>
  Copyright (c) <COPYRIGHTYEAR> Audiokinetic Inc.
------------------------------------------------------------------------------]]

_WWISE_ROOT_DIR = '../../'
_AK_ROOT_DIR = '../../SDK/source/Build/'
_WA_ROOT_DIR = '../../Authoring/source/Build/'

function AkRelativeToCwd(in_path)
	if in_path == nil then
		print("AkRealtiveToCwd called with nil")
		os.exit(1)
	end
	if in_path == "" then
		print("AkRealtiveToCwd called with empty")
		os.exit(1)
	end

	local abs = in_path
	if path.isabsolute(abs) == false then
		abs = path.join(_AK_TOP_CWD,abs)
	end
	abs = path.normalize(abs)
	local rel = path.getrelative(os.getcwd(),abs)
	rel = path.normalize(rel)

	if string.sub(in_path, -1) == "/" then
		rel = rel .. "/"
	end
	
	-- We never have paths going back to the root of the drive. Convert any /something to ./something
	if string.sub(rel, 1) == "/" then
		rel = "." .. rel
	end

	return rel
end

function AkMakeAbsolute(in_path)
	if in_path == nil then
		print("AkMakeAbsolute called with nil")
		os.exit(1)
	end
	if in_path == "" then
		print("AkMakeAbsolute called with empty")
		os.exit(1)
	end
	local result = path.normalize(path.join(_AK_TOP_CWD,in_path))
	local ext = path.getextension(result)
	if not ext or ext == "" or ext == "." then
		result = result .. "/"
	end
	return result
end
