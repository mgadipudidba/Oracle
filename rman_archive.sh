export ORACLE_HOME=/opt/app/oracle/product/19.0.0/db_1
export ORACLE_SID=MIBS
export PATH=/opt/app/oracle/product/19.0.0/db_1/bin:/opt/app/oracle/product/19.0.0/db_1/OPatch:/usr/sbin:/usr/local/bin:/home/oracle/.local/bin:/home/oracle/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

rman target sys/oracle123@MIBS log=/DumpExport/RMAN_BACKUPS/Archive_Backups/$(date '+%y%m%d-%H%M%S').log << EOF

run
{
 allocate channel d1 type disk;
 backup as compressed backupset archivelog all FORMAT '/DumpExport/RMAN_BACKUPS/Archive_Backups/%d_AR_%T_%u_s%s_p%p.rman';
 release channel d1;
 }

exit

EOF
