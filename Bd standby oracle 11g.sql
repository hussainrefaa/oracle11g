-- Author: 	Hussain refaa
-- creation Date: 	2016
-- Last Updated: 	0000-00-00
-- Control Number:	xxxx-xxxx-xxxx-xxxx
-- Version: 	0.0
-- Phone : +4915775148443
-- Email: refaa.hussain@gmail.com

Problem :
I have a primary database Oracle 11g and a standby database,
 a dissaster occurs and the standby becomes the primary for two days, 
 then the problem on the primary server is solved, there is a way to turn on the 
 old primary and apply the changes made on the new primary to make the old primary the primary,
 I think this is no possible and that after the standby becomes primary there is no switch back to turn the old primary the primary, 
 
 Assuming the last 2 steps performed after failover (at the standby site) was - 
SQL> ALTER DATABASE ACTIVATE PHYSICAL STANDBY DATABASE; (some data loss)
SQL> ALTER DATABASE OPEN;

Assuming you have FLASHBACK database feature enabled on both databases. 
Assuming the old primary database content is available to the extent, when it became unavailable. 
Perform the following steps in order - 
At new primary - 
SQL> SELECT TO_CHAR(STANDBY_BECAME_PRIMARY_SCN) FROM V$DATABASE; (Say XYZ)
At old primary - 
SQL> STARTUP MOUNT;
SQL> FLASHBACK DATABASE TO SCN XYZ;
SQL> ALTER DATABASE CONVERT TO PHYSICAL STANDBY;
SQL> SHUTDOWN IMMEDIATE;
SQL> STARTUP MOUNT;
At new primary - 
SQL> ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_n=ENABLE;
SQL> ALTER SYSTEM SWITCH LOGFILE;
At old primary - 
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT;
The old primary is a physical standby of the new primary. You are now ready for switchover. 
