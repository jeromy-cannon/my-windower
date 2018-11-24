--[[Copyright © 2018, RaYel
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of <addon name> nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Byrth or smd111 BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.]]
_addon.name = "rings"
_addon.author = "RaYel"
_addon.command = "rings"
_addon.commands = {"rings"}
_addon.version = "1.0"

res = require "resources"

function print_obj(obj, hierarchy_level)
    if (hierarchy_level == nil) then
        hierarchy_level = 0
    elseif (hierarchy_level == 4) then
        return 0
    end

    local whitespace = ""
    for i = 0, hierarchy_level, 1 do
        whitespace = whitespace .. "-"
    end
    --my_print(whitespace)

    --my_print(obj)
    if (type(obj) == "table") then
        for k, v in pairs(obj) do
            --my_print(whitespace .. "-")
            if (type(v) == "table") then
                print_obj(v, hierarchy_level + 1)
            else
                my_print(whitespace .. "-" .. tostring(k) .. ":" .. tostring(v))
            end
        end
    else
        --my_print(obj)
    end
end

function my_print(...)
    print_result = ""
    for i, v in ipairs(arg) do
        if v then
            print_result = print_result .. tostring(v) .. ">"
        else
            print_result = print_result .. tostring("nil") .. ">"
        end
    end
    windower.add_to_chat(208, print_result)
end

function my_debug(...)
    local myLoc = debug.getinfo(2, "S")
    local myLoc2 = debug.getinfo(2, "n")
    if not myLoc2.name then
        myLoc2.name = "undefined"
    end
    print_result = ""
    for i, v in ipairs(arg) do
        if v then
            print_result = print_result .. tostring(v) .. ">"
        else
            print_result = print_result .. tostring("nil") .. ">"
        end
    end
    my_print(
        string.format("%.2f:", os.clock()) ..
            myLoc.short_src .. ":" .. myLoc.linedefined .. ":" .. myLoc2.name .. ":" .. print_result
    )
end

function match_item(target_item, m)
    return type(m) == "table" and m.id and res.items[m.id] and
        (res.items[m.id].en:lower() == target_item:lower() or res.items[m.id].enl:lower() == target_item:lower())
end

function ring_lookup(ring)
    wardrobe = windower.ffxi.get_items(8)
    for slot, item in pairs(wardrobe) do
        if item then
            if type(item) == "table" and res.items[item.id] then
                item_desc = res.items[item.id].en:lower()
                --my_print("slot", slot, "item.id", item.id, "name", item_desc)
                if item_desc == ring:lower() then
                    --my_print("found it!!!")
                    ring_location = {
                        bag_loc = slot,
                        id = item.id,
                        description = item_desc,
                        cast_delay = res.items[item.id].cast_delay
                    }
                    return ring_location
                end
            else
                -- my_print("slot", slot, "items...>")
                -- print_obj(items)
            end
        end
    end
    --print_obj(wardrobe)
end

function main(ring, ...)
    the_ring = ring_lookup(ring)
    if the_ring == nil then
        my_print(ring .. " not found")
        return
    end
    my_print(the_ring.bag_loc, the_ring.id, the_ring.description, the_ring.cast_delay)
    windower.ffxi.set_equip(the_ring.bag_loc, 14, 8)
    for i = the_ring.cast_delay + 5, 1, -1 do
        my_print(ring .. " countdown " .. i)
        coroutine.sleep(1)
    end
    windower.send_command('input /item "' .. ring .. '" <me>')
    --equip = windower.ffxi.get_items().equipment
    --my_print(tostring(equip.right_ring))

    --my_print(print_obj(equip))
end

windower.register_event("addon command", main)
