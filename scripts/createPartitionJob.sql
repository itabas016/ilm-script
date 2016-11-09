conn &BD_owner_user/&BD_owner_pass@&tname

declare
   startDate date;
   cnt pls_integer;
   ownerUser varchar2(30) := upper('&BD_owner_user');
   jobName varchar2(60) := ownerUser || '.IBS_ILM_PARTITIONING';
begin
    if upper('&SCHEDULE_PARTITIONING') = 'Y' then
	   --drop the job if it exists
	   select count(*) into cnt
	   from all_scheduler_jobs
	   where job_name = 'IBS_ILM_PARTITIONING'
	   and owner = ownerUser;
	   if cnt > 0 then
	      DBMS_SCHEDULER.DROP_JOB('IBS_ILM_PARTITIONING');
	   end if;
	   --create the job now
	   startDate := to_date('&PARTITION_JOB_START_DATE', '&PARTITION_JOB_START_FORMAT');
		DBMS_SCHEDULER.CREATE_JOB
			(
				JOB_NAME     => jobName,
				JOB_TYPE     => 'STORED_PROCEDURE',
				JOB_ACTION   =>  ownerUser || '.PKG_ORA_SCHEDULER.PARTITIONTABLES',
				START_DATE   => startDate,
				ENABLED   => false,
				auto_drop => true
			);
			dbms_scheduler.set_attribute( name => jobName, attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_FULL);
			dbms_scheduler.enable( jobName );
	end if;
end;
/
