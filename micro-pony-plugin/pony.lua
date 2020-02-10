VERSION = "0.4.0"

local micro = import("micro")
local util = import("micro/util")

local indent = {
    "actor", 
    "be", 
    "class",
    "do",
    "else",
    "elseif",
    "for",
    "fun",
    "if",
    "in",
    "interface",
    "new",
    "object",
    "primitive",
    "recover",
    "ref",
    "repeat",
    "struct",
    "tag",
    "then",
    "trait",
    "try",
    "type",
    "until",
    "while",
    "with",
    "=>"
}

function preInsertNewline(bp)
    if not (bp.Buf:FileType() == "pony") then
        return
    end

    local line = bp.Buf:Line(bp.Cursor.Y)
    local ws = util.GetLeadingWhitespace(line)
    local x = bp.Cursor.X

    if
        (string.sub(line, x+1, x+1) == "}") and 
        (string.find(string.sub(line, x+1), "{") == nil) 
        then
            bp:InsertNewline()
            bp:CursorUp()
            bp:EndOfLine()
            bp:InsertNewline()
            bp:InsertTab()
            return false
        end

        for _, key in pairs(indent) do
            for word in string.gmatch(string.sub(line, 1, x), "%S+") do
                if word == key then
                    bp:InsertNewline()
                    if string.find(string.sub(line, 1, x+1), "end") == nil then   
                    bp:InsertTab()
                end
                return false
            end
        end
    end
end
