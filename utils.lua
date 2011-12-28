-- Remove objects from a lua table, defragmenting the table in the process.
function remove_if(t, cull)
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