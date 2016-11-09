@IBSArch.par
set serveroutput on;
set verify off;

spool IBSVPD.log

prompt
prompt Attempting to create the VPD profiles
@@scripts/createvpdprofiles

