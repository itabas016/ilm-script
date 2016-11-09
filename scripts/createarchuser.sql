--@@..\IBSArchiving.par

 --create the role to contain all the object priveleges
declare 
  roleName varchar2(30) := substr('&BD_owner_user', 1, 25) || '_ROLE';
begin
  begin
    execute immediate ('drop role ' || roleName);
    dbms_output.put_line('dropped role ' || roleName);
    exception
       when others then
          if sqlcode = -1919 then
             dbms_output.put_line('Role ' || roleName || ' does not exist. Skip dropping...');
          else
             raise;
          end if;
    end;      
    execute immediate ('create role ' || roleName);
    dbms_output.put_line('created role ' || roleName);
end;
/

prompt grant create any index to &BD_owner_user;
grant create any index to &BD_owner_user;
prompt grant create any trigger to &BD_owner_user;
grant create any trigger to &BD_owner_user;
prompt grant create job to &BD_owner_user;
grant create job to &BD_owner_user;
prompt grant ALTER ANY TABLE to &BD_owner_user;
grant ALTER ANY TABLE to &BD_owner_user;
prompt grant CREATE ANY TABLE to &BD_owner_user;
grant CREATE ANY TABLE to &BD_owner_user;
prompt grant DROP ANY TABLE to &BD_owner_user;
grant DROP ANY TABLE to &BD_owner_user;
prompt grant LOCK ANY TABLE to &BD_owner_user;
grant LOCK ANY TABLE to &BD_owner_user;
prompt grant SELECT ANY TABLE to &BD_owner_user;
grant SELECT ANY TABLE to &BD_owner_user;
prompt select on dba_role_privs to &BD_owner_user;
grant select on dba_role_privs to &BD_owner_user;
prompt grant any context to &BD_owner_user;
grant create any context to &BD_owner_user;
prompt grant EXECUTE ANY TYPE to &BD_owner_user;
grant EXECUTE ANY TYPE to &BD_owner_user;

prompt grant execute on dbms_redefinition to &BD_owner_user;
grant execute on dbms_redefinition to &BD_owner_user;
prompt grant execute on dbms_crypto to &BD_owner_user;
grant execute on dbms_crypto to &BD_owner_user;
prompt grant execute on dbms_rls to &BD_owner_user;
grant execute on dbms_rls to &BD_owner_user;

 --grant permissions on ILM Assistant tables in order to check the current period boundaries

begin
    dbms_output.put_line('grant select on ILM_TOOLKIT.ILM$_RULES to &BD_owner_user;');
    execute immediate 'grant select on ILM_TOOLKIT.ILM$_RULES to &BD_owner_user';
    exception
       when others then
	  if sqlcode = -942 then
	     dbms_output.put_line('Table ILM_TOOLKIT.ILM$_RULES does not exist. Skipping.');
	  else
	     raise;
	  end if;
end;
/


begin
    dbms_output.put_line('grant select on ILM_TOOLKIT.ILM$_RULES_APPLIED to &BD_owner_user;');
    execute immediate 'grant select on ILM_TOOLKIT.ILM$_RULES_APPLIED to &BD_owner_user';
    exception
       when others then
	  if sqlcode = -942 then
	     dbms_output.put_line('Table ILM_TOOLKIT.ILM$_RULES_APPLIED does not exist. Skipping.');
	  else
	     raise;
	  end if;
end;
/
 
begin
    dbms_output.put_line('grant select on ILM_TOOLKIT.ILM$_RULE_STAGES to &BD_owner_user;');
    execute immediate 'grant select on ILM_TOOLKIT.ILM$_RULE_STAGES to &BD_owner_user';
    exception
       when others then
	  if sqlcode = -942 then
	     dbms_output.put_line('Table ILM_TOOLKIT.ILM$_RULE_STAGES does not exist. Skipping.');
	  else
	     raise;
	  end if;
end;
/
 
 
prompt Creating Businessdata user ...

begin
    dbms_output.put_line('create user &BD_archive_user default tablespace DATAUSR temporary tablespace temp identified by *******;');
    execute immediate 'create user &BD_archive_user default tablespace DATAUSR temporary tablespace temp identified by &BD_archive_pass';
    exception
       when others then
	  if sqlcode = -1920 then
	     dbms_output.put_line('User &BD_archive_user already exists. Skipping.');
	  else
	     raise;
	  end if;
end;
/

declare
  roleName varchar2(30) := substr('&BD_owner_user', 1, 25) || '_ROLE';
begin
    dbms_output.put_line('grant unlimited tablespace to &BD_archive_user;');
    execute immediate 'grant unlimited tablespace to &BD_archive_user';
	dbms_output.put_line('grant connect,resource,' || roleName || ' to &BD_archive_user');
	execute immediate ('grant connect,resource,' || roleName || ' to &BD_archive_user');
	dbms_output.put_line('grant create synonym ' || ' to &BD_archive_user');
	execute immediate ('grant create synonym ' || ' to &BD_archive_user');
	dbms_output.put_line('grant EXECUTE ANY TYPE ' || ' to &BD_archive_user');
	execute immediate ('grant EXECUTE ANY TYPE ' || ' to &BD_archive_user');
end;
/

