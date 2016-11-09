
 alter session set current_schema=&BD_archive_user;
  
 --first drop any synonyms for BD objects
 set serveroutput on size 1000000
 declare
   sqlStmt varchar(2000);
   cursor syns_cur is
     select synonym_name
     from dba_synonyms
     where owner = upper('&BD_archive_user');
 begin
   for syn in syns_cur loop
      sqlStmt := 'drop synonym ' || syn.synonym_name;
      begin
        execute immediate (sqlStmt);
        dbms_output.put_line(sqlStmt);
        exception
         when others then  
              dbms_output.put_line(SQLERRM );
      end;
   end loop;
 end;
 /

declare
  sqlStmt varchar(2000);
  cursor object_cur is
    select object_name
    from all_objects
    where owner = upper('&BD_owner_user')
    and object_name <> 'INVOICING_NUMBER_SQ'
    and   object_type in ('FUNCTION', 'PACKAGE', 'PROCEDURE', 'SEQUENCE', 
                          'TABLE', 'VIEW','TYPE');
begin
  for bd_object in object_cur loop
       sqlStmt := 'CREATE OR REPLACE SYNONYM ' || bd_object.object_name ||
                  ' FOR &BD_owner_user' || '.' || bd_object.object_name;
      begin                  
       execute immediate (sqlStmt);
       dbms_output.put_line(sqlStmt);
       exception
        when others then  
             dbms_output.put_line(SQLERRM );
      end;
  end loop;
end;
/

