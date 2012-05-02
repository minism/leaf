--[[

#########################################################################
#                                                                       #
# functional.lua                                                        #
#                                                                       #
# Functional programming constructs                                     #
#                                                                       #
# Copyright 2011 Josh Bothun                                            #
# joshbothun@gmail.com                                                  #
# http://minornine.com                                                  #
#                                                                       #
# This program is free software: you can redistribute it and/or modify  #
# it under the terms of the GNU General Public License as published by  #
# the Free Software Foundation, either version 3 of the License, or     #
# (at your option) any later version.                                   #
#                                                                       #
# This program is distributed in the hope that it will be useful,       #
# but WITHOUT ANY WARRANTY; without even the implied warranty of        #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
# GNU General Public License <http://www.gnu.org/licenses/> for         #
# more details.                                                         #
#                                                                       #
#########################################################################

--]]

-- Remove objects from a lua table, defragmenting the table in the process.
function leaf.remove_if(t, cull)
    -- Defrag
    local size = #t
    local free = 1
    for i = 1, #t do
        if not cull(t[i]) then
            t[free] = t[i]
            free = free + 1
        end
    end
    -- Nil remainder
    for i = free, size do
        t[i] = nil
    end
end


-- Update a table with values from another table
function leaf.update_table(t1, t2)
    for k, v in pairs(t2) do
        if v then
            t1[k] = v
        end
    end
    return t1
end


-- Check if an object is an instance of its prototype
function leaf.isinstance(obj, class)
    return getmetatable(obj) == class
end
