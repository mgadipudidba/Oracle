# $Header: rman_full.sh
# *====================================================================================+
# |  Author - Anand & Madhu
# |                                                       |
# +====================================================================================+
# |
# | FILENAME
# |     rman_arch_del.sh
# |
# | DESCRIPTION
# |     Delete the archive log older then 7 days
# | PLATFORM
# |     Linux/Solaris
# +===========================================================================+
#!/bin/bash
#export ORACLE_HOME=/opt/app/oracle/product/19.0.0/db_1
#export ORACLE_SID=MIBS
#export PATH=opt/app/oracle/product/19.0.0/db_1/bin:/opt/app/oracle/product/19.0.0/db_1/OPatch:/usr/sbin:/usr/local/bin:/home/oracle/.local/bin:/home/oracle/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
#$ORACLE_HOME/bin/rman << EOF
rman target sys/oracle123@MIBS log=/DumpExport/RMAN_BACKUPS/Full_Backups/$(date '+%y%m%d-%H%M%S').log << EOF
#rman raget /
run {
allocate channel d1 type disk;
allocate channel d2 type disk;
allocate channel d3 type disk;
allocate channel d4 type disk;
allocate channel d5 type disk;
allocate channel d6 type disk;
allocate channel d7 type disk;
allocate channel d8 type disk;
BACKUP FORMAT '/DumpExport/RMAN_BACKUPS/Full_Backups/%d_DB_%T_%Database_s%s_p%p.rman' AS COMPRESSED BACKUPSET DATABASE
  CURRENT CONTROLFILE FORMAT '/DumpExport/RMAN_BACKUPS/Full_Backups/%d_ControlFile_%T_%u.rman'
  SPFILE FORMAT '/DumpExport/RMAN_BACKUPS/Full_Backups/%d_SPFile_%T_%u.rman'
  PLUS ARCHIVELOG FORMAT '/DumpExport/RMAN_BACKUPS/Full_Backups/%d_AR_%T_%u_s%s_p%p.rman';
delete force noprompt archivelog all completed before 'SYSDATE-7';
release channel d1;
release channel d2;
release channel d3;
release channel d4;
release channel d5;
release channel d6;
release channel d7;
release channel d8;
}

exit

EOF
