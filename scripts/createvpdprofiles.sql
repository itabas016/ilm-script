conn &BD_owner_user/&BD_owner_pass@&tname

begin
   dbms_output.put_line('CREATE or replace CONTEXT ' || substr(user, 1, 26) || '_CTX USING pkg_ARCH_predicates');
   execute immediate 'CREATE or replace CONTEXT ' || substr(user, 1, 26) || '_CTX USING pkg_ARCH_predicates';
end;
/ 


begin
        dbms_rls.drop_policy('&BD_owner_user','SUHISTOR','ARCHIVE_SEL_RESTRICT');
	dbms_output.put_line('Dropped VPD policy ARCHIVE_SEL_RESTRICT (SUHISTOR)');
	exception
	   when others then
		 if sqlcode <> -28102 then
			raise;
		 end if;
end;
/

begin
        dbms_rls.drop_policy('&BD_owner_user','CONTACT','ARCHIVE_SEL_RESTRICT');
	dbms_output.put_line('Dropped VPD policy ARCHIVE_SEL_RESTRICT (CONTACT)');
	exception
	   when others then
		 if sqlcode <> -28102 then
			raise;
		 end if;
end;
/

begin
        dbms_rls.drop_policy('&BD_owner_user','FT_DISPUTE','ARCHIVE_SEL_RESTRICT');
	dbms_output.put_line('Dropped VPD policy ARCHIVE_SEL_RESTRICT (FT_DISPUTE)');
	exception
	   when others then
		 if sqlcode <> -28102 then
			raise;
		 end if;
end;
/

begin
        dbms_rls.drop_policy('&BD_owner_user','INVOICE','ARCHIVE_SEL_RESTRICT');
	dbms_output.put_line('Dropped VPD policy ARCHIVE_SEL_RESTRICT (INVOICE)');
	exception
	   when others then
		 if sqlcode <> -28102 then
			raise;
		 end if;
end;
/

begin
        dbms_rls.drop_policy('&BD_owner_user','FINANCIAL_TRANSACTION','ARCHIVE_SEL_RESTRICT');
	dbms_output.put_line('Dropped VPD policy ARCHIVE_SEL_RESTRICT (FINANCIAL_TRANSACTION)');
	exception
	   when others then
		 if sqlcode <> -28102 then
			raise;
		 end if;
end;
/

begin
        dbms_rls.drop_policy('&BD_owner_user','SETTLEMENT','ARCHIVE_SEL_RESTRICT');
	dbms_output.put_line('Dropped VPD policy ARCHIVE_SEL_RESTRICT (SETTLEMENT)');
	exception
	   when others then
		 if sqlcode <> -28102 then
			raise;
		 end if;
end;
/

begin
        dbms_rls.drop_policy('&BD_owner_user','CALL_DETAIL_RECORD','ARCHIVE_SEL_RESTRICT');
	dbms_output.put_line('Dropped VPD policy ARCHIVE_SEL_RESTRICT (CALL_DETAIL_RECORD)');
	exception
	   when others then
		 if sqlcode <> -28102 then
			raise;
		 end if;
end;
/

begin
        dbms_rls.drop_policy('&BD_owner_user','FT_APPROVAL_REQUEST','ARCHIVE_SEL_RESTRICT');
	dbms_output.put_line('Dropped VPD policy ARCHIVE_SEL_RESTRICT (FT_APPROVAL_REQUEST)');
	exception
	   when others then
		 if sqlcode <> -28102 then
			raise;
		 end if;
end;
/


    begin
     dbms_rls.add_policy (
       object_name   => 'SUHISTOR',
       policy_name   => 'ARCHIVE_SEL_RESTRICT',
       policy_function =>'pkg_ARCH_predicates.SUHISTOR_select_restrict',
--       policy_type => 'STATIC',
       statement_types => 'SELECT');
       dbms_output.put_line('Created VPD policy ARCHIVE_SEL_RESTRICT (SUHISTOR)');
    end;     
/


    begin
     dbms_rls.add_policy (
       object_name   => 'CONTACT',
       policy_name   => 'ARCHIVE_SEL_RESTRICT',
       policy_function =>'pkg_ARCH_predicates.CONTACT_select_restrict',
--       policy_type => 'STATIC',
       statement_types => 'SELECT');
       dbms_output.put_line('Created VPD policy ARCHIVE_SEL_RESTRICT (CONTACT)');
    end;     
/

    begin
     dbms_rls.add_policy (
       object_name   => 'FT_DISPUTE',
       policy_name   => 'ARCHIVE_SEL_RESTRICT',
       policy_function =>'pkg_ARCH_predicates.FT_DISPUTE_select_restrict',
--       policy_type => 'STATIC',
       statement_types => 'SELECT');
       dbms_output.put_line('Created VPD policy ARCHIVE_SEL_RESTRICT (FT_DISPUTE)');
    end;     
/

    begin
     dbms_rls.add_policy (
       object_name   => 'INVOICE',
       policy_name   => 'ARCHIVE_SEL_RESTRICT',
       policy_function =>'pkg_ARCH_predicates.INVOICE_select_restrict',
--       policy_type => 'STATIC',
       statement_types => 'SELECT');
       dbms_output.put_line('Created VPD policy ARCHIVE_SEL_RESTRICT (INVOICE)');
    end;     
/

    begin
     dbms_rls.add_policy (
       object_name   => 'FINANCIAL_TRANSACTION',
       policy_name   => 'ARCHIVE_SEL_RESTRICT',
       policy_function =>'pkg_ARCH_predicates.FT_select_restrict',
--       policy_type => 'STATIC',
       statement_types => 'SELECT');
       dbms_output.put_line('Created VPD policy ARCHIVE_SEL_RESTRICT (FINANCIAL_TRANSACTION)');
    end;     
/

    begin
     dbms_rls.add_policy (
       object_name   => 'SETTLEMENT',
       policy_name   => 'ARCHIVE_SEL_RESTRICT',
       policy_function =>'pkg_ARCH_predicates.SETTLEMENT_select_restrict',
--       policy_type => 'STATIC',
       statement_types => 'SELECT');
       dbms_output.put_line('Created VPD policy ARCHIVE_SEL_RESTRICT (SETTLEMENT)');
    end;     
/

    begin
     dbms_rls.add_policy (
       object_name   => 'CALL_DETAIL_RECORD',
       policy_name   => 'ARCHIVE_SEL_RESTRICT',
       policy_function =>'pkg_ARCH_predicates.CDR_select_restrict',
--       policy_type => 'STATIC',
       statement_types => 'SELECT');
       dbms_output.put_line('Created VPD policy ARCHIVE_SEL_RESTRICT (CALL_DETAIL_RECORD)');
    end;     
/

    begin
     dbms_rls.add_policy (
       object_name   => 'FT_APPROVAL_REQUEST',
       policy_name   => 'ARCHIVE_SEL_RESTRICT',
       policy_function =>'pkg_ARCH_predicates.FT_APPR_REQ_select_restrict',
--       policy_type => 'STATIC',
       statement_types => 'SELECT');
       dbms_output.put_line('Created VPD policy ARCHIVE_SEL_RESTRICT (FT_APPROVAL_REQUEST)');
    end;     
/

--Use TIME_STAMP column instead of psuedo column ORA_ROWSCN
--for tables that have VPD policies defined on them

--Now change the view definitions on base tables that have VPD policies and ORA_ROWSCN is used.
set serveroutput on size unlimited

create table tab_user_views (VIEW_NAME  VARCHAR2(30),
                             VIEW_TEXT CLOB,
                             TABLE_NAME VARCHAR2(30));

INSERT INTO tab_user_views
   (SELECT VIEW_NAME, TO_LOB(TEXT), NULL
    FROM user_views v);
                 
commit;
                    
declare
  cursor c is
    SELECT VIEW_NAME, VIEW_TEXT
    FROM tab_user_views
    where view_name like 'V_VF_%'
    and View_Name != 'V_VF_AGREEMENT_DET_HISTORY'
    and View_Name != 'V_VF_OI_ACTIVITY_DETAIL'
    order by view_name;
   tableName    varchar2(30);
   
   createScript clob;
   hashValue    varchar2(100);
   pos pls_integer := 0;
   TYPE charArrayType IS TABLE OF VARCHAR(30);
   ilmTables charArrayType := new charArrayType(); 
   firstLoop boolean;

begin
  select object_name bulk 
  collect into ilmTables
  from user_policies
  where POLICY_NAME like 'ARCHIVE%';
  
  if ilmTables.count = 0 then
     return;
  end if;
  for r in c loop
    begin
      firstLoop := true;
      createScript := r.view_text;
      dbms_output.put_line('starting view ' || r.VIEW_NAME);
      for i in ilmTables.first..ilmTables.last loop
        loop
          dbms_output.put_line('                 trying with ' || ilmTables(i));
          select REGEXP_INSTR(upper(createScript), '(,?\s+,?|,)(\w+)\.ORA_ROWSCN,?\s+[^~]*,?\s+,?' || ilmTables(i) || '\s+\2')
          into pos from dual;
          
          if pos > 0 then 
            dbms_output.put_line('uses ' ||ilmTables(i) );
            if firstLoop = true then
                pkg_ddl.GetObjectDDL(r.VIEW_NAME, 'VIEW', tableName, hashValue, createScript);
                createScript := replace(createScript, ';', null); 
                firstLoop :=false;
            end if;   
            createScript := regexp_replace(createScript, '(,?\s+,?|,)(\w+)(\.ORA_ROWSCN)(,?\s+[^~]*,?\s+,?' || ilmTables(i) || '\s+\2)', '\1\2.TIME_STAMP\4', 1, 0, 'i');
          else
            exit;  
          end if;
        end loop;
        if firstLoop = false then
            execute immediate (dbms_lob.substr(createScript, 30000, 1));
            dbms_output.put_line('recreated view ' || r.view_name );
            update tab_user_views set table_name = ilmTables(i) where view_name = r.view_name;
        end if;                        
      end loop;
      exception
        when others then
           dbms_output.put_line(sqlerrm);
      end;   
      dbms_output.put_line('end view ' || r.VIEW_NAME);
  end loop;  
end;
/ 

drop table tab_user_views;
