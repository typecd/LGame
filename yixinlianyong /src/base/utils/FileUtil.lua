local FileUtil = {}
function FileUtil.readFile(path)
    local file = io.open(path, "rb")
    if file then
        local content = file:read("*all")
        io.close(file)
        return content
    end
    return nil
end

function FileUtil.removeFile(path)
    io.writefile(path, "")
    if device.platform == "windows" then
        --os.execute("del " .. string.gsub(path, '/', '\\'))
    else
        os.execute("rm " .. path)
    end
end

function FileUtil.delAllFilesInDirectory(path)
    logBugly("delAllFilesInDirectory " .. path)
    if string.ends(path, "/") then
        path = string.sub(path, 1, string.len(path) - 1);
    end
    require('lfs');
    if io.exists(path) then
        for file in lfs.dir(path) do
          if file ~= "." and file ~= ".." then
              local f = path..'/'..file;
              local attr = lfs.attributes(f);
              assert (type(attr) == "table");
              if attr.mode == "directory" then
                  FileUtil.delAllFilesInDirectory(f);
              else
                  os.remove(f);
              end
          end
        end

    end
end


-- remove zip in dir or zip file
function FileUtil.rmZip(path) 
    logBugly("rmZip " .. path)
    require('lfs');
    if string.ends(path, "/") then
        path = string.sub(path, 1, string.len(path) - 1);
    end
    
    if io.exists(path) then
        local mode = lfs.attributes(path, 'mode')
        if mode == "directory" then
            for name in lfs.dir(path) do
                local innerPath = path .. '/' .. name;
                local innerMode = lfs.attributes(innerPath, 'mode');
                if innerMode == "file" and string.ends(innerPath, ".zip") then
                    os.remove(innerPath);
                end
            end
        elseif mode == "file" then
            if string.ends(path, ".zip") then
                os.remove(path);
            end
        end
    end
end

-- remove path or file
function FileUtil.rmTree(path) 
    logBugly("rmTree " .. path)
    require('lfs');
    if string.ends(path, "/") then
        path = string.sub(path, 1, string.len(path) - 1);
    end
    if io.exists(path) then
        local mode = lfs.attributes(path, 'mode')
        if mode == "directory" then
            for name in lfs.dir(path) do
                if name ~= "." and name ~= ".." then
                    FileUtil.rmTree(path .. '/' .. name)
                end
            end
            lfs.rmdir(path)
        elseif mode == "file" then
            os.remove(path)
        end
    end
end


function FileUtil.delAllZipInDirectory(path)
    logBugly("delAllZipInDirectory " .. path)
    if string.ends(path, "/") then
        path = string.sub(path, 1, string.len(path) - 1);
    end
    require('lfs');
    if io.exists(path) then
        for file in lfs.dir(path) do
          if file ~= "." and file ~= ".." then
            local f = path..'/'..file;
            local attr = lfs.attributes(f);
            assert (type(attr) == "table");
            if attr.mode == "directory" then
                FileUtil.delAllZipInDirectory(f);
              else
                if string.ends(f, ".zip") then
                    os.remove(f);
                end
              end
          end
        end
    end
end

function FileUtil.checkFile(fileName, cryptoCode)
    -- bba.log("checkFile: %s", fileName);
    -- bba.log("cryptoCode: %s", cryptoCode);

    if not io.exists(fileName) then
        return false;
    end

    if not cryptoCode then
        return true;
    end

    local ms = crypto.md5file(fileName)
    -- bba.log("file cryptoCode: %s", ms)
    if ms == cryptoCode then
        return true;
    end
    return false;
end


function FileUtil.mkdir(path)
    require('lfs');
    local oldpath = lfs.currentdir();

    local dirs = string.split(path, '/');
    local p = '';
    for i, n in pairs(dirs) do
        p = p .. n .. '/';
        if not lfs.chdir(p) then
            if not lfs.mkdir(p) then
                return false
            end
        end
    end

    lfs.chdir(oldpath);
    return true;
end






return FileUtil;