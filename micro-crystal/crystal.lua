VERSION = "1.1.0"

local micro = import("micro")
local config = import("micro/config")
local shell = import("micro/shell")

function init()
    config.RegisterCommonOption("crystal", "fmt", true)
    config.MakeCommand("crystal", crystal, config.NoComplete)
    config.AddRuntimeFile("crystal", config.RTHelp, "help/crystal-plugin.md")
end

function onBufferOpen(b)
    -- Set tabsize by default for crystal files to 2
    if b:FileType() == "crystal" then
        b:SetOption("tabsize", "2")
    end
end

function onSave(bp)
    if bp.Buf:FileType() == "crystal" then
        if bp.Buf.Settings["crystal.fmt"] then
            format()
        end
    end
end

function crystal(bp, args)
    if #args < 1 then
        return
    end
    local a = args[1]
    local ft = bp.Buf:FileType()
    local file = bp.Buf.Path
    if a == "version" or a == "--version" or a == "-v" then
        version(a)
    elseif a == "format" then
        format(bp)
    elseif a == "run" then
        run(bp)
    elseif a == "build" then
        build(bp)
    elseif a == "eval" then
        eval(bp)
    end
end

function version(v)
    shell.JobSpawn("crystal", {v}, nil, nil, function(output)
        micro.InfoBar():Message(output)
    end)
end

function format(bp)
    local ft = bp.Buf:FileType()
    local file = bp.Buf.Path
    bp:Save()
    shell.JobSpawn("crystal", {"tool", "format", file}, nil, nil, function(output)
        bp.Buf:ReOpen()
    end)
end

function run(bp)
    local file = bp.Buf.Path
    shell.JobSpawn("crystal", {"run", file}, nil, nil, function(output)
        micro.InfoBar():Message(output)
    end)
end

function build(bp)
    local file = bp.Buf.Path
    shell.JobSpawn("crystal", {"build", file}, nil, nil, function(output)
        micro.InfoBar():Message(output)
    end)
end

function eval(bp)
    local ft = bp.Buf:FileType()
    local file = bp.Buf.Path
    local line = bp.Buf:Line(bp.Cursor.Y)
    shell.JobSpawn("crystal", {"eval", line}, nil, nil, function(output)
        micro.InfoBar():Message(output)
    end)
end

function string.contains(str, word)
    return string.match(' '..str..' ', '%A'..word..'%A') ~= nil
end

function string.starts(str,start)
    return string.sub(str, 1, string.len(start)) == start
end
