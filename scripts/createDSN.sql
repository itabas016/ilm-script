  
  alter session set current_schema=&DR_user;
  
INSERT INTO CONNECTIONSTRING ( CONNECTION_ID, CONNECTION_STRING, DATA_ACCESS_TYPE, APPLICATION_MODULE, KEY_ID, VERSION, is_archive_user) 
  select substr(CONNECTION_ID, 1, 35) || '_ARCH', 'user id=' || '&BD_archive_user' || '; password=' || '&BD_archive_pass' || '; data source=' || '&TNAME' ,
          DATA_ACCESS_TYPE, APPLICATION_MODULE, KEY_ID, VERSION, 1
  from CONNECTIONSTRING t
  where (upper(APPLICATION_MODULE) in ('BACKGROUND', 'DEFAULT')) and (INSTR(CONNECTION_ID, 'ARCH')) = 0
      and instr(upper(connection_string), upper( '&BD_owner_user'))> 0 and
  not exists (select 1 from connectionstring where substr(t.CONNECTION_ID, 1, 35) || '_ARCH' = connection_id); 


commit;        