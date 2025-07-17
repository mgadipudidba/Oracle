rman target sys/oracle123@MIBS log=/DumpExport/RMAN_BACKUPS/Incremental_Backups/$(date '+%y%m%d-%H%M%S').log << EOF

run
{
allocate channel d1 type disk;
allocate channel d2 type disk;
allocate channel d3 type disk;
allocate channel d4 type disk;
allocate channel d5 type disk;
allocate channel d6 type disk;
allocate channel d7 type disk;
allocate channel d8 type disk;
BACKUP FORMAT '/DumpExport/RMAN_BACKUPS/Incremental_Backups/%d_DB_%T_%u_s%s_p%p.rman' tag 'INCR1_DB' INCREMENTAL LEVEL=1 as compressed backupset DATABASE PLUS ARCHIVELOG;
BACKUP CURRENT CONTROLFILE TAG 'INCR1_CTL' FORMAT '/DumpExport/RMAN_BACKUPS/Incremental_Backups/%d_CTL_%T_%u_s%s_p%p.rman';
BACKUP SPFILE TAG 'INCR1_SPFILE' FORMAT '/DumpExport/RMAN_BACKUPS/Incremental_Backups/%d_SPFILE_%T_%u_s%s_p%p.rman';
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
