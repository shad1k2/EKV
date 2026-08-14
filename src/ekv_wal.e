class
    EKV_WAL
create
    make
feature {NONE}
    make (a_filename: STRING)
        require 
            filename_not_empty: not a_filename.is_empty
        do
            filename := a_filename
        ensure
            filename_set: filename.same_string (a_filename)
    end
feature --Operations
    append_set (a_key, a_value: STRING)
        require
            key_valid: not a_key.is_empty
            value_valid: not a_value.is_empty
        local
            file: PLAIN_TEXT_FILE
        do
            create file.make_open_append (filename)
            file.put_string (a_key + " " + a_value)
            file.put_new_line
            file.close
        end

    append_del (a_key: STRING)
        require
            key_valid: not a_key.is_empty
        local
            file: PLAIN_TEXT_FILE
        do
            create file.make_open_append (filename)
            file.put_string ("DEL " + a_key)
            file.put_new_line
            file.close
        end

    replay (a_store: EKV_STORE)
        local
            file: PLAIN_TEXT_FILE
            line, k, v: STRING
            parts: LIST [STRING]
        do
            create file.make_with_name (filename)
            if file.exists then
                file.open_read
                from
                until
                    file.exhausted
                loop
                    file.read_line
                    line := file.last_string.twin
                    line.trim
                    if not line.is_empty then
                        parts := line.split (' ')
                        if parts.i_th (1).is_equal ("DEL") and parts.count >= 2 then
                            k := parts.i_th (2)
                            if a_store.has (k) then
                                a_store.del (k)
                            end
                        elseif parts.count >= 2 then
                            k := parts.i_th (1)
                            v := parts.i_th (2)
                            a_store.put (k, v)
                        end
                    end
                end
                file.close
            end
        end

feature {NONE} -- Implementation
    filename: STRING
end