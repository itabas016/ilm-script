
 alter session set current_schema=&BD_owner_user;
 
 begin
 	execute immediate 'create or replace view V_ILM_TABLE_STAGE as
 	  select vt.tablename, rs.eval_criteria, rs.unit_count, rs.unit_metric, r.fiscal_month, rs.low_date, rs.high_date
 	    from ILM_TOOLKIT.ILM$_RULES r join ILM_TOOLKIT.ILM$_RULES_APPLIED ra
 	      on r.id = ra.rule_id
 	    join ILM_TOOLKIT.ILM$_VALID_TABLES vt
 	      on  ra.table_id = vt.id
 	    join (select connect_by_isleaf, rule_id, eval_criteria, unit_count, unit_metric, low_date, high_date  
 		  from ILM_TOOLKIT.ILM$_RULE_STAGES 
 		  start with PREV_STAGE_ID is null 
 		  connect by prior id = PREV_STAGE_ID) rs
 	     on rs.rule_id = r.id
 	   where rs.connect_by_isleaf = 1';
 	dbms_output.put_line ('Created view V_ILM_TABLE_STAGE.');
 exception
    when others then
       if sqlcode = -942 then
 	dbms_output.put_line ('ILM_TOOLKIT is not found. View V_ILM_TABLE_STAGE is not created.');
       else
          raise;
       end if;	  
 end;
 /


 --modify tables, to implement custom rowscn

create or replace function fnc_get_timestamp return number
is
  ndate number;
  nsec  number;
  now timestamp := systimestamp;
begin
  ndate := TO_NUMBER(TO_CHAR(now, 'J'));
  nsec := to_number(to_char(now, 'sssss'));
  return (ndate*100000 + nsec);
end;
/


--
create or replace package pkg_ARCH_predicates AUTHID CURRENT_USER as

  function SUHISTOR_select_restrict(owner varchar2, object_name varchar2)
    return varchar2;

  function CONTACT_select_restrict(owner varchar2, object_name varchar2)
    return varchar2;

  function FT_DISPUTE_select_restrict(owner varchar2, object_name varchar2)
    return varchar2;

  function INVOICE_select_restrict(owner varchar2, object_name varchar2)
    return varchar2;

  function CDR_select_restrict(owner varchar2, object_name varchar2)
    return varchar2;

  function FT_select_restrict(owner varchar2, object_name varchar2)
    return varchar2;

  function SETTLEMENT_select_restrict(owner varchar2, object_name varchar2)
    return varchar2;

  function FT_APPR_REQ_select_restrict(owner       varchar2,
                                       object_name varchar2) return varchar2;

  function ILM_ROLE_NAME return varchar2;

  function ILM_CONTEXT_NAME return varchar2;
end;
/

create or replace package body pkg_ARCH_predicates as

  suhistorDate              date;
  contactDate               date;
  ft_disputeDate            date;
  invoiceDate               date;
  settlementDate            date;
  financial_transactionDate date;
  ft_approval_requestDate   date;
  call_detail_recordDate    date;
  isArchiveUser             pls_integer := 0;
  contextName               varchar2(30);
  archiveRole               varchar2(30);
  
  function GetCurrentStageLowDate(tableName             varchar2,
                                  defaultNumberOfMonths pls_integer)
    return date is
    retDate date;
  begin
    select nvl(start_of_current_stage,
               add_months(sysdate, -1 * defaultNumberOfMonths))
      into retDate
      from data_archival_config
     where TABLE_SOURCE_NAME = upper(tableName);
    return retDate;
  exception
    when others then
      retDate := add_months(sysdate, -1 * defaultNumberOfMonths);
      return retDate;
  end;

  procedure InitPackage is
  begin
    contextName               := substr(upper('&BD_owner_user'), 1, 26) || '_CTX';
    archiveRole               := substr(upper('&BD_owner_user'), 1, 25)  || '_ROLE';

    select count(*)
      into isArchiveUser
      from dba_role_privs t
     where t.GRANTED_ROLE = upper(archiveRole)
       and t.GRANTEE = USER;
    suhistorDate              := GetCurrentStageLowDate('SUHISTOR', 12);
    contactDate               := GetCurrentStageLowDate('CONTACT', 12);
    ft_disputeDate            := GetCurrentStageLowDate('ft_dispute', 24);
    invoiceDate               := GetCurrentStageLowDate('invoice', 24);
    financial_transactionDate := GetCurrentStageLowDate('financial_transaction',
                                                        24);
    settlementDate            := GetCurrentStageLowDate('settlement', 24);
    call_detail_recordDate    := GetCurrentStageLowDate('call_detail_record', 24);
    ft_approval_requestDate   := GetCurrentStageLowDate('ft_approval_request',
                                                        24);
  end;

  function SUHISTOR_select_restrict(owner varchar2, object_name varchar2)
    return varchar2 is
    ret_predicate varchar2(1000);
  begin
    if isArchiveUser = 0 then
      ret_predicate := 'SUHISTOR.CREATE_DATETIME >= ''' || suhistorDate || '''';
    end if;
    return ret_predicate;
    --''' || suhistorDate || '''
  end;

  function CONTACT_select_restrict(owner varchar2, object_name varchar2)
    return varchar2 is
    ret_predicate varchar2(1000);
  begin
    if isArchiveUser = 0 then
      ret_predicate := 'CONTACT.CREATED_DATE >= ''' || contactDate || '''';
    end if;
    return ret_predicate;
    --''' || suhistorDate || '''
  end;

  function FT_DISPUTE_select_restrict(owner varchar2, object_name varchar2)
    return varchar2 is
    ret_predicate varchar2(1000);
  begin
    if isArchiveUser = 0 then
      ret_predicate := 'FT_DISPUTE.DISPUTE_DATE >= ''' || ft_disputeDate || '''' ;
    end if;
    return ret_predicate;
    --''' || suhistorDate || '''
  end;

  function INVOICE_select_restrict(owner varchar2, object_name varchar2)
    return varchar2 is
    ret_predicate varchar2(1000);
  begin
    if isArchiveUser = 0 then
      ret_predicate := 'INVOICE.CREATE_DATE >= ''' || invoiceDate || '''';
    end if;
    return ret_predicate;
    --''' || suhistorDate || '''
  end;

  function FT_select_restrict(owner varchar2, object_name varchar2)
    return varchar2 is
    ret_predicate varchar2(1000);
  begin
    if isArchiveUser = 0 then
      ret_predicate := 'FINANCIAL_TRANSACTION.CREATE_DATETIME >= ''' || financial_transactionDate || '''';
    end if;
    return ret_predicate;
    --''' || suhistorDate || '''
  end;

  function SETTLEMENT_select_restrict(owner varchar2, object_name varchar2)
    return varchar2 is
    ret_predicate varchar2(1000);
  begin
    if isArchiveUser = 0 then
      ret_predicate := 'SETTLEMENT.CREATE_DATE >= ''' || settlementDate || '''' ;
    end if;
    return ret_predicate;
    --''' || suhistorDate || '''
  end;

  function CDR_select_restrict(owner varchar2, object_name varchar2)
    return varchar2 is
    ret_predicate varchar2(1000);
  begin
    if isArchiveUser = 0 then
      ret_predicate := 'CALL_DETAIL_RECORD.CREATE_DATE_TIME >= ''' || call_detail_recordDate || '''';
    end if;
    return ret_predicate;
    --''' || suhistorDate || '''
  end;

  function FT_APPR_REQ_select_restrict(owner       varchar2,
                                       object_name varchar2) return varchar2 is
    ret_predicate varchar2(1000);
  begin
    if isArchiveUser = 0 then
      ret_predicate := 'FT_APPROVAL_REQUEST.REQUEST_DATETIME >= ''' ||  ft_approval_requestDate || '''' ;
    end if;
    return ret_predicate;
    --''' || suhistorDate || '''
  end;

  function ILM_ROLE_NAME return varchar2 is
  begin
     return archiveRole;
  end;

  function ILM_CONTEXT_NAME return varchar2 is
  begin
     return contextName;
  end;

begin

  InitPackage;
end pkg_ARCH_predicates;
/

--assign the permissions
  DECLARE
    sqlStmt VARCHAR2(4000);
    usrName VARCHAR(30);
    roleName varchar2(30) := substr('&BD_owner_user', 1, 25) || '_ROLE';
    CURSOR cur IS
         SELECT object_type,
             object_name,
             DECODE(object_type, 'PACKAGE', 1,
                       'FUNCTION',  2, 
                       'PROCEDURE', 3,
                       'VIEW', 4,
                       'SEQUENCE', 5,
                       'MATERIALIZED VIEW', 7,
                      9) AS create_order              
              FROM   all_objects
              WHERE  object_type IN ('VIEW',
                           'PACKAGE',
                           'SEQUENCE',
                           'MATERIALIZED VIEW',
                           'PROCEDURE',
                           'FUNCTION'
                           )
                     and owner = upper('&BD_owner_user') and object_name <> 'INVOICING_NUMBER_SQ'      
         UNION ALL
           SELECT object_type,
               object_name,
               10 AS create_order              
           FROM   ALL_objects
           WHERE  object_type ='TABLE' and
                  object_name not like 'M_VIEW%' and 
                  owner = upper('&BD_owner_user')
         ORDER BY  create_order;
    BEGIN
    usrname := '&BD_owner_user';
    FOR cur_rec IN cur LOOP
    BEGIN
        IF cur_rec.object_type in ('PACKAGE', 'PROCEDURE', 'FUNCTION') THEN
          sqlStmt := 'GRANT EXECUTE ON ' || usrName || '.' || cur_rec.object_name || ' TO ' || roleName;
        ELSIF cur_rec.object_type in ('TABLE', 'VIEW') THEN
             sqlStmt := 'GRANT SELECT, UPDATE, INSERT, DELETE ON ' || usrName || '.' || cur_rec.object_name ||  ' TO ' || roleName;
        ELSIF cur_rec.object_type in ('SEQUENCE', 'MATERIALIZED VIEW') THEN
          sqlStmt := 'GRANT SELECT ON ' || usrName || '.' || cur_rec.object_name ||  ' TO ' || roleName;
        END IF;
        EXECUTE IMMEDIATE (sqlStmt);
        DBMS_OUTPUT.put_line(sqlStmt);
      EXCEPTION
        WHEN OTHERS THEN
         DBMS_OUTPUT.put_line('ERROR: ' || cur_rec.object_type || '::' || cur_rec.object_name);
      END;    
    END LOOP;
  END;    
/

--update the current stage periods
prompt updating the fiscal year start and current stage length and fiscal year month start
update data_archival_config 
  set FISCAL_MONTH = &FISCAL_YEAR_MONTH,
      KEEP_NEWER_THAN = &HISTORY_MONTHS
where TABLE_SOURCE_NAME = 'SUHISTOR';

update data_archival_config 
  set FISCAL_MONTH = &FISCAL_YEAR_MONTH,
      KEEP_NEWER_THAN = &CONTACT_MONTHS
where TABLE_SOURCE_NAME = 'CONTACT';

update data_archival_config 
  set FISCAL_MONTH = &FISCAL_YEAR_MONTH,
      KEEP_NEWER_THAN = &FINANCE_MONTHS
where TABLE_SOURCE_NAME = 'FT_DISPUTE';

update data_archival_config 
  set FISCAL_MONTH = &FISCAL_YEAR_MONTH,
      KEEP_NEWER_THAN = &FINANCE_MONTHS
where TABLE_SOURCE_NAME = 'INVOICE';

update data_archival_config 
  set FISCAL_MONTH = &FISCAL_YEAR_MONTH,
      KEEP_NEWER_THAN = &FINANCE_MONTHS
where TABLE_SOURCE_NAME = 'FINANCIAL_TRANSACTION';

update data_archival_config 
  set FISCAL_MONTH = &FISCAL_YEAR_MONTH,
      KEEP_NEWER_THAN = &FINANCE_MONTHS
where TABLE_SOURCE_NAME = 'SETTLEMENT';

update data_archival_config 
  set FISCAL_MONTH = &FISCAL_YEAR_MONTH,
      KEEP_NEWER_THAN = &FINANCE_MONTHS
where TABLE_SOURCE_NAME = 'FT_APPROVAL_REQUEST';

commit;

exec PKG_ORA_SCHEDULER.ILMTables;