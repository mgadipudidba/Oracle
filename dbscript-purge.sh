#Oracle database connection details
DB_USER="oracle"
DB_PASSWORD="oracle123"
DB_SID="FOS"

#Output directory
OUTPUT_DIR="/export"

export TIMESTAMP=`date +%d%b%Y`
echo $TIMESTAMP
echo ========================
echo Export command
echo ========================
echo $ORACLE_HOME

#Take Backup for Table TRACELOG  and TRACE_LOG_INTEGRATION
#echo "Take Backup for Table TRACELOG "

$ORACLE_HOME/bin/expdp \'/ as sysdba\' tables=FINFE.TRACELOG directory=DUMPDIR dumpfile=EXPDP_B4PURGE_TRACELOG_${TIMESTAMP}.dmp logfile=EXPDP_B4PURGE_TRACELOG_${TIMESTAMP}.log COMPRESSION=ALL

#echo "Take Backup for Table TRACE_LOG_INTEGRATION"

$ORACLE_HOME/bin/expdp \'/ as sysdba\' tables=FINBE.TRACE_LOG_INTEGRATION directory=DUMPDIR dumpfile=EXPDP_B4PURGE_TRACE_LOG_INTEGRATION_${TIMESTAMP}.dmp logfile=EXPDP_B4PURGE_TRACE_LOG_INTEGRATION_${TIMESTAMP}.log COMPRESSION=ALL

ls -lha /export/EXPDP_B4PURGE_TRACELOG${TIMESTAMP}.dmp
ls -lha /export/EXPDP_B4PURGE_TRACE_LOG_INTEGRATION_${TIMESTAMP}.dmp

echo "Backup has been successfully completed"


echo "------------------------------------------"

#Start purge data for EJF
echo "Start Data Purging and Table optimize for TRACELOG"
# SQL commands

SQL_COMMANDS=(
'DELETE FROM FINFE.TRACELOG WHERE CREATEDATE < SYSTIMESTAMP - 14;'
'ALTER TABLE FINFE.TRACELOG ENABLE ROW MOVEMENT;'
'ALTER TABLE FINFE.TRACELOG SHRINK SPACE CASCADE;'
'ALTER TABLE FINFE.TRACELOG MODIFY LOB(DETAILS) (SHRINK SPACE CASCADE);'
'ALTER TABLE FINFE.TRACELOG MODIFY LOB(USERCONTEXT) (SHRINK SPACE CASCADE);'
'ALTER TABLE FINFE.TRACELOG DISABLE ROW MOVEMENT;'
)

# Loop through each SQL command and execute it, saving output to a file
for ((i=0; i<${#SQL_COMMANDS[@]}; i++))
do
  SQL_COMMAND="${SQL_COMMANDS[$i]}"
  OUTPUT_FILE="$OUTPUT_DIR/output_$i.txt"
  echo "Executing: $SQL_COMMAND"
  echo "Output will be saved to: $OUTPUT_FILE"

  # Execute SQL command and save output to file
  sqlplus $DB_USER/$DB_PASSWORD@$DB_SID <<EOF > "$OUTPUT_FILE"
  $SQL_COMMAND
  exit;

EOF

done

echo "Data Purging and Table optimize for tracelog have been completed"
echo "------------------------------------------"

#Start purge data for TRACE_LOG_INTEGRATION

echo "Start Data Purging and Table optimize for TRACE_LOG_INTEGRATION"

# SQL commands

SQL_COMMANDS=(
'DELETE FROM FINBE.TRACE_LOG_INTEGRATION WHERE START_TIME < SYSTIMESTAMP - 180;'
'ALTER TABLE FINBE.TRACE_LOG_INTEGRATION ENABLE ROW MOVEMENT;'
'ALTER TABLE FINBE.TRACE_LOG_INTEGRATION SHRINK SPACE CASCADE;'
'ALTER TABLE FINBE.TRACE_LOG_INTEGRATION MODIFY LOB(RESPONSE) (SHRINK SPACE CASCADE);'
'ALTER TABLE FINBE.TRACE_LOG_INTEGRATION MODIFY LOB(REQUEST) (SHRINK SPACE CASCADE);'
'ALTER TABLE FINBE.TRACE_LOG_INTEGRATION DISABLE ROW MOVEMENT;'
)

# Loop through each SQL command and execute it, saving output to a file
for ((i=0; i<${#SQL_COMMANDS[@]}; i++))
do
  SQL_COMMAND="${SQL_COMMANDS[$i]}"
  OUTPUT_FILE="$OUTPUT_DIR/output_$i.txt"
  echo "Executing: $SQL_COMMAND"
  echo "Output will be saved to: $OUTPUT_FILE"

  # Execute SQL command and save output to file
  sqlplus -S $DB_USER/$DB_PASSWORD@$DB_SID <<EOF > "$OUTPUT_FILE"
  $SQL_COMMAND
  exit;

EOF
done

echo "Data Purging and Table optimize for UserActivity have been completed"
echo "------------------------------------------"
echo "=============================================================================="
echo "=============================================================================="

