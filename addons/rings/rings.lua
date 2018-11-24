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

res = require 'resources'

function match_item(target_item,m)
    return type(m) == 'table' and m.id and res.items[m.id] and (res.items[m.id].en:lower() == target_item:lower() or res.items[m.id].enl:lower() == target_item:lower())
end

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
    windower.add_to_chat(208, whitespace)

    --windower.add_to_chat(208, obj)
    if (type(obj) == "table") then
        for k, v in pairs(obj) do
            windower.add_to_chat(208, whitespace .. "-")
            if (type(v) == "table") then
                print_obj(v, hierarchy_level + 1)
            else
                windower.add_to_chat(208, k .. ":" .. v)
            end
        end
    else
        --windower.add_to_chat(208, obj)
    end
end

function ring_lookup(ring)
    wardrobe = windower.ffxi.get_items(8)
    for slot, item in pairs(wardrobe) do
        windower.add_to_chat(208, slot..':'..item)
    end
    print_obj(wardrobe)
end

function main(ring, ...)
    the_ring = ring_lookup(ring)
    if the_ring == nil then
        windower.add_to_chat(208, ring .. " not found")
        return
    end
    windower.add_to_chat(208, ring .. ":" .. rings[ring])
    equip = windower.ffxi.get_items().equipment
    windower.add_to_chat(208, tostring(equip.right_ring))

    --windower.add_to_chat(208, print_obj(equip))
end

windower.register_event("addon command", main)
