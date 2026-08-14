class
    EKV_STORE
create 
    make
feature {NONE}
    make
        do
            create data.make (10)
        end
feature -- Access
    has (a_key: STRING): BOOLEAN
        require
            key_not_empty: not a_key.is_empty
        do
            Result := data.has (a_key)
        end
    get (a_key: STRING): detachable STRING
        require
            key_not_empty: not a_key.is_empty
        do
            if data.has (a_key) then
                Result := data.item (a_key)
            end
        end
feature -- Element change
    put (a_key: STRING; a_value: STRING)
        require
            key_not_empty: not a_key.is_empty
            value_not_empty: not a_value.is_empty
        do
            data.force (a_value, a_key)
        ensure
            key_exists: data.has (a_key)
            value_stored: attached data.item (a_key) as v and then v.same_string (a_value)
        end
feature --Delete pair
    del (a_key: STRING)
        require
            key_exists: has (a_key)
        do
            data.remove (a_key)
        ensure
            key_not_exists: not data.has (a_key)
        end
feature {NONE} -- Implementation
    data: HASH_TABLE [STRING, STRING]
end