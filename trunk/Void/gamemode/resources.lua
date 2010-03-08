
-- A simple function to makes sure they got the right extension (so it's not .txt for example)
local function ValidExt(FileName)
    if     -- Materials
        (FileName:find(".vtf$")) or
        (FileName:find(".vmt$")) or
        -- Models
        (FileName:find(".vtx$")) or
        (FileName:find(".mdl$")) or
        (FileName:find(".phy$")) or
		(FileName:find(".lua$")) or
        (FileName:find(".vvd$")) then
        
        return true
    end
    
    return false
end


-- A recursive function to find all the files in models and material folders
local function FindFiles(Dir, Level)
    if (Dir) then
        Files = file.Find("../gamemodes/Void/content/"..Dir.."/*.*")
    else
        Files = file.Find("../gamemodes/Void/content/*.*")
		
		print("-------------------------------------------------")
		print("------- ADDING RESOURCES TO DOWNLOAD LIST -------")
		print("-------------------------------------------------")
    end
    
    Level = Level or 0
    Dir = Dir or ""
    for k,v in pairs(Files) do
        local IsDir = file.IsDir("../gamemodes/Void/content/".. Dir .. "/" .. v)
        if (IsDir) then
           -- print(string.rep("\t", Level) .. Dir .. "/" .. v)
            FindFiles(Dir .. "/" .. v, Level + 1)
        else
           -- print(string.rep("\t", Level) .. Dir .. "/" .. v)
            if (ValidExt(v)) then
                resource.AddFile( Dir .. "/" .. v)
                --print(string.rep("\t", Level) .. "Valid extension - Added file to download.\n")
            --else
				--print(string.rep("\t", Level) .. "Invalid extension - Ignoring file...\n")
            end
        end
    end
end
FindFiles()