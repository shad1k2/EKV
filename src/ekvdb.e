class
    EKVDB 
create
    make
feature {NONE} --Initialization
    make
        local
            store: EKV_STORE
            wal: EKV_WAL
            val: detachable STRING
            cmd, k, v: STRING
            is_running: BOOLEAN
        do
            print("--- EKV CLI ver 0.9 ---%N")
            print ("Commands: set <key> <val> | del <key> | get <key> | exit%N%N")

            create store.make
            create wal.make("ekv.log")
            wal.replay (store)
            is_running := True

            from
            until
                not is_running
            loop
                print ("ekv> ")
                io.read_line
                cmd := io.last_string.twin  

                if cmd.is_equal ("exit") then
                    is_running := False
                    print ("Bye!%N")
                elseif cmd.starts_with ("set ") then
                    parse_and_put (store, wal, cmd)
                elseif cmd.starts_with ("del ") then
                    k := cmd.substring (5, cmd.count)
                    k.trim 
                    if not k.is_empty then
                        if store.has(k) then
                            store.del (k)
                            wal.append_del (k)
                            print ("OK%N")
                        else
                            print ("Error: Key not found%N")
                        end
                    else 
                        print ("Usage: del <key>%N")
                    end
                elseif cmd.starts_with ("get ") then
                    k := cmd.substring (5, cmd.count)
                    k.trim
                    if not k.is_empty then
                        val := store.get (k)
                        if attached val as res then
                            print ("=> " + res + "%N")
                        else
                            print ("(nil)%N")
                        end
                    end
                else
                    if not cmd.is_empty then
                        print ("Unknown command. Try 'set <key> <val>', 'del <key>' or 'get <key>'%N")
                    end
                end
            end
        end
feature {NONE} --Helpers
    parse_and_put (a_store: EKV_STORE; a_wal:EKV_WAL; a_cmd: STRING)
        local
            parts: LIST [STRING]
            k,v: STRING
        do
            parts := a_cmd.split (' ')
            if parts.count >= 3 then
                k := parts.i_th (2)
                v := parts.i_th (3)

                k.trim
                v.trim

                if not k.is_empty and not v.is_empty then
                    a_store.put (k, v)
                    a_wal.append_set (k, v)
                    print ("OK%N")
                else
                    print ("Error: Key and Value cannot be empty!%N")
                end
            else
                print ("Usage: set <key> <value>%N")
            end
        end
end