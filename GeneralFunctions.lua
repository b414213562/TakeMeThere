
function Debug(STRING)

    if STRING == nil or STRING == "" then return end;

    Turbine.Shell.WriteLine("<rgb=#FF5555>" .. STRING .. "</rgb>");

end

--This function returns a deep copy of a given table ---------------
function deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

-- This function merges table two into table one, overwriting any matching entries.
function mergeTables(t1, t2)
    for k, v in pairs(t2) do
        if (type(v) == "table") and (type(t1[k] or false) == "table") then
            mergeTables(t1[k], t2[k])
        else
            t1[tostring(k)] = v
        end
    end
    return t1
end

-- Basic debug function to look at a table:
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function GetString(array, language)
    if (language == nil or 
        language == "") then
        language = LANGUAGE;
    end
    if (array == nil) then
        return "";
    end
    if (language == "ENGLISH") then
        Debug("Changing language from ENGLISH to EN");
        language = "EN";
    end
    if (array[language] ~= nil) then
        return array[language];
    end
    return array["EN"];
end


function Onscreen(control)

  local displayWidth = Turbine.UI.Display.GetWidth();
  local displayHeight = Turbine.UI.Display.GetHeight();

  local width = control:GetWidth();
  local height = control:GetHeight();
  local left = control:GetLeft();
  local top = control:GetTop();
  local right = left + width;
  local bottom = top + height;

  if right > displayWidth then left = displayWidth - width; end;
  if left < 0 then left = 0 end;
  if top < 0 then top = 0 end;
  if bottom > displayHeight then top = displayHeight - height; end;

  control:SetPosition(left,top);

end