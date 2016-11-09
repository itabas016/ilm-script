@IBSArch.par
set serveroutput on;
set verify off;

spool IBSArchive.log

prompt
prompt Attempting to create the user used for archived data ....
@@scripts/createarchuser

prompt
prompt Create objects in BD schema
@@scripts/createBDobjects

prompt
prompt Attempting to create private synonyms for BD database objects in the arch schema
@@scripts/createsynonyms

prompt
prompt Attempting to add new DSN for archived data
--create new DSN for archived data
@@scripts/createDSN

prompt
prompt Attempting to create a scheduler job to run the partitioning of Businessdata
--create new DSN for archived data
@@scripts/createPartitionJob

spool off;
exit;