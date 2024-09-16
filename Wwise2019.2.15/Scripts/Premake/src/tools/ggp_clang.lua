--
-- clang.lua
-- Clang toolset adapter for Premake
-- Copyright (c) 2013 Jason Perkins and the Premake project
--

local p = premake
p.tools.ggp_clang = {}
local ggp_clang = p.tools.ggp_clang
local gcc = p.tools.gcc
local config = p.config



--
-- Build a list of flags for the C preprocessor corresponding to the
-- settings in a particular project configuration.
--
-- @param cfg
--    The project configuration.
-- @return
--    An array of C preprocessor flags.
--

function ggp_clang.getcppflags(cfg)

    -- Just pass through to GCC for now
    local flags = gcc.getcppflags(cfg)
    return flags

end


--
-- Build a list of C compiler flags corresponding to the settings in
-- a particular project configuration. These flags are exclusive
-- of the C++ compiler flags, there is no overlap.
--
-- @param cfg
--    The project configuration.
-- @return
--    An array of C compiler flags.
--

ggp_clang.shared = {
    architecture = gcc.shared.architecture,
    flags = gcc.shared.flags,
    floatingpoint = {
        Fast = "-ffast-math",
    },
    strictaliasing = gcc.shared.strictaliasing,
    optimize = {
        Off = "-O0",
        On = "-O2",
        Debug = "-O0",
        Full = "-O3",
        Size = "-Os",
        Speed = "-O3",
    },
    pic = gcc.shared.pic,
    vectorextensions = gcc.shared.vectorextensions,
    isaextensions = gcc.shared.isaextensions,
    warnings = gcc.shared.warnings,
    symbols = gcc.shared.symbols,
    unsignedchar = gcc.shared.unsignedchar,
    omitframepointer = gcc.shared.omitframepointer
}

ggp_clang.cflags = table.merge(gcc.cflags, {
})

function ggp_clang.getcflags(cfg)
    local shared = config.mapFlags(cfg, ggp_clang.shared)
    local cflags = config.mapFlags(cfg, ggp_clang.cflags)

    local flags = table.join(shared, cflags)
    flags = table.join(flags, ggp_clang.getwarnings(cfg))

    return flags
end

function ggp_clang.getwarnings(cfg)
    return gcc.getwarnings(cfg)
end


--
-- Build a list of C++ compiler flags corresponding to the settings
-- in a particular project configuration. These flags are exclusive
-- of the C compiler flags, there is no overlap.
--
-- @param cfg
--    The project configuration.
-- @return
--    An array of C++ compiler flags.
--

ggp_clang.cxxflags = table.merge(gcc.cxxflags, {
})

function ggp_clang.getcxxflags(cfg)
    local shared = config.mapFlags(cfg, ggp_clang.shared)
    local cxxflags = config.mapFlags(cfg, ggp_clang.cxxflags)
    local flags = table.join(shared, cxxflags)
    flags = table.join(flags, ggp_clang.getwarnings(cfg))
    return flags
end


--
-- Returns a list of defined preprocessor symbols, decorated for
-- the compiler command line.
--
-- @param defines
--    An array of preprocessor symbols to define; as an array of
--    string values.
-- @return
--    An array of symbols with the appropriate flag decorations.
--

function ggp_clang.getdefines(defines)

    -- Just pass through to GCC for now
    local flags = gcc.getdefines(defines)
    return flags

end

function ggp_clang.getundefines(undefines)

    -- Just pass through to GCC for now
    local flags = gcc.getundefines(undefines)
    return flags

end



--
-- Returns a list of forced include files, decorated for the compiler
-- command line.
--
-- @param cfg
--    The project configuration.
-- @return
--    An array of force include files with the appropriate flags.
--

function ggp_clang.getforceincludes(cfg)

    -- Just pass through to GCC for now
    local flags = gcc.getforceincludes(cfg)
    return flags

end


--
-- Returns a list of include file search directories, decorated for
-- the compiler command line.
--
-- @param cfg
--    The project configuration.
-- @param dirs
--    An array of include file search directories; as an array of
--    string values.
-- @return
--    An array of symbols with the appropriate flag decorations.
--

function ggp_clang.getincludedirs(cfg, dirs, sysdirs)

    -- Just pass through to GCC for now
    local flags = gcc.getincludedirs(cfg, dirs, sysdirs)
    return flags

end

ggp_clang.getrunpathdirs = gcc.getrunpathdirs

--
-- get the right output flag.
--
function ggp_clang.getsharedlibarg(cfg)
    return gcc.getsharedlibarg(cfg)
end

--
-- Build a list of linker flags corresponding to the settings in
-- a particular project configuration.
--
-- @param cfg
--    The project configuration.
-- @return
--    An array of linker flags.
--

ggp_clang.ldflags = {
    architecture = {
        x86 = "-m32",
        x86_64 = "-m64",
    },
    flags = {
        LinkTimeOptimization = "-flto",
    },
    kind = {
        SharedLib = function(cfg)
            local r = { ggp_clang.getsharedlibarg(cfg) }
            if cfg.system == "windows" and not cfg.flags.NoImportLib then
                table.insert(r, '-Wl,--out-implib="' .. cfg.linktarget.relpath .. '"')
            elseif cfg.system == p.LINUX then
                table.insert(r, '-Wl,-soname=' .. p.quoted(cfg.linktarget.name))
            elseif table.contains(os.getSystemTags(cfg.system), "darwin") then
                table.insert(r, '-Wl,-install_name,' .. p.quoted('@rpath/' .. cfg.linktarget.name))
            end
            return r
        end,
        WindowedApp = function(cfg)
            if cfg.system == p.WINDOWS then return "-mwindows" end
        end,
    },
    system = {
        wii = "$(MACHDEP)",
    }
}

function ggp_clang.getldflags(cfg)
    local flags = config.mapFlags(cfg, ggp_clang.ldflags)
    return flags
end



--
-- Build a list of additional library directories for a particular
-- project configuration, decorated for the tool command line.
--
-- @param cfg
--    The project configuration.
-- @return
--    An array of decorated additional library directories.
--

function ggp_clang.getLibraryDirectories(cfg)

    -- Just pass through to GCC for now
    local flags = gcc.getLibraryDirectories(cfg)
    return flags

end


--
-- Build a list of libraries to be linked for a particular project
-- configuration, decorated for the linker command line.
--
-- @param cfg
--    The project configuration.
-- @param systemOnly
--    Boolean flag indicating whether to link only system libraries,
--    or system libraries and sibling projects as well.
-- @return
--    A list of libraries to link, decorated for the linker.
--

function ggp_clang.getlinks(cfg, systemonly, nogroups)
    local result = {}

    if not systemonly then
        if cfg.flags.RelativeLinks then
            local libFiles = config.getlinks(cfg, "siblings", "name")
            for _, link in ipairs(libFiles) do
                if string.startswith(link, "lib") then
                    link = link:sub(4)
                end
                table.insert(result, "-l" .. link)
            end
        else
            -- Don't use the -l form for sibling libraries, since they may have
            -- custom prefixes or extensions that will confuse the linker. Instead
            -- just list out the full relative path to the library.
            result = config.getlinks(cfg, "siblings", "name")
        end
    end

    -- The "-l" flag is fine for system libraries
    local links = config.getlinks(cfg, "system", "name")
    local static_syslibs = {}
    local shared_syslibs = {}

    for _, link in ipairs(links) do
        if path.isframework(link) then
            table.insert(result, "-framework")
            table.insert(result, path.getbasename(link))
        elseif path.isobjectfile(link) then
            table.insert(result, link)
        else
            local endswith = function(s, ptrn)
                return ptrn == string.sub(s, -string.len(ptrn))
            end
            local name = path.getname(link)
            -- Check whether link mode decorator is present
            if endswith(name, ":static") then
                name = string.sub(name, 0, -8)
                table.insert(static_syslibs, name)
            elseif endswith(name, ":shared") then
                name = string.sub(name, 0, -8)
                table.insert(shared_syslibs, name)
            -- AUDIOKINETIC
            elseif endswith(name, ".a") then
                table.insert(static_syslibs, name)
            -- AUDIOKINETIC end
            elseif endswith(name, ".so") then
                table.insert(shared_syslibs, name)
            -- AUDIOKINETIC end
            else
                name = "lib" .. name .. ".a"
                table.insert(static_syslibs, name)
            end
        end
    end

    local move = function(a1, a2)
        local t = #a2
        for i = 1, #a1 do a2[t + i] = a1[i] end
    end

    move(static_syslibs, result)
    move(shared_syslibs, result)

    return result
end


--
-- Return a list of makefile-specific configuration rules. This will
-- be going away when I get a chance to overhaul these adapters.
--
-- @param cfg
--    The project configuration.
-- @return
--    A list of additional makefile rules.
--

function ggp_clang.getmakesettings(cfg)

    -- Just pass through to GCC for now
    local flags = gcc.getmakesettings(cfg)
    return flags

end


--
-- Retrieves the executable command name for a tool, based on the
-- provided configuration and the operating environment. I will
-- be moving these into global configuration blocks when I get
-- the chance.
--
-- @param cfg
--    The configuration to query.
-- @param tool
--    The tool to fetch, one of "cc" for the C compiler, "cxx" for
--    the C++ compiler, or "ar" for the static linker.
-- @return
--    The executable command name for a tool, or nil if the system's
--    default value should be used.
--

ggp_clang.tools = {
    cc = "clang",
    cxx = "clang++",
    ar = "ar"
}

function ggp_clang.gettoolname(cfg, tool)
    return ggp_clang.tools[tool]
end


-- AUDIOKINETIC copied from msc, with ggp_clang values
-- Return a list of valid library extensions
--
function ggp_clang.getLibraryExtensions()
    return {
        ["a"] = true,
        ["so"] = true,
    }
end

