--
-- _preload.lua
-- Define the makefile action(s).
-- Copyright (c) 2002-2015 Jason Perkins and the Premake project
--

	local p = premake
	local project = p.project

---
-- The GNU make action, with support for the new platforms API
---

	newaction {
		trigger         = "gmake",
		shortname       = "GNU Make",
		description     = "Generate GNU makefiles for POSIX, MinGW, and Cygwin",
		toolset         = "gcc",

		valid_kinds     = { "ConsoleApp", "WindowedApp", "StaticLib", "SharedLib", "Utility", "Makefile", "None" },
		valid_languages = { "C", "C++", "C#" },
		valid_tools     = {
			cc     = { "clang", "gcc" },
			dotnet = { "mono", "msnet", "pnet" }
		},

		onWorkspace = function(wks)
			p.escaper(p.make.esc)
			wks.projects = table.filter(wks.projects, function(prj) return p.action.supports(prj.kind) and prj.kind ~= p.NONE end)
			-- AUDIOKINETIC: Add subsolutions and force-obey filename if set
			local mainWorkspaceName = ""
			if wks.filename then
				mainWorkspaceName = wks.filename .. ".make"
			else
				mainWorkspaceName = p.make.getmakefilename(wks, false)
			end

			p.generate(wks, mainWorkspaceName, p.make.generate_workspace)
			if wks.subsolutions ~= nil then
				for _,subsolution in ipairs(wks.subsolutions) do
					wks.cursubsolution = subsolution
					local wksname = wks.filename or wks.name
					p.generate(wks, wksname .. "_" .. subsolution .. ".make", p.make.generate_workspace)
				end
			end
			-- AUDIOKINETIC end
		end,

		onProject = function(prj)
			if p.global.isprojectimported(prj) then
				return
			end
			p.escaper(p.make.esc)
			local makefile = p.make.getmakefilename(prj, true)

			if not p.action.supports(prj.kind) or prj.kind == p.NONE then
				return
			elseif prj.kind == p.UTILITY then
				p.generate(prj, makefile, p.make.utility.generate)
			elseif prj.kind == p.MAKEFILE then
				p.generate(prj, makefile, p.make.makefile.generate)
			else
				if project.isdotnet(prj) then
					p.generate(prj, makefile, p.make.cs.generate)
				elseif project.isc(prj) or project.iscpp(prj) then
					p.generate(prj, makefile, p.make.cpp.generate)
				end
			end
		end,

		onCleanWorkspace = function(wks)
			p.clean.file(wks, p.make.getmakefilename(wks, false))
		end,

		onCleanProject = function(prj)
			p.clean.file(prj, p.make.getmakefilename(prj, true))
		end
	}


--
-- Decide when the full module should be loaded.
--

	return function(cfg)
		return (_ACTION == "gmake")
	end
