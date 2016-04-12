# check-rsync-email-report
This sript in bash cans perform backups using rsync, and send an email report to his System administrator to check your proper cron, or not.

This script is easy, it checks mountpointing and make a diff/inc backup. 
It send an error code ">2", Otherwise it's done :)

This sript is in four steps :

    - 1: Check mounpoint / Send email 
    - 2: Launching the rsync copy (Inc or Diff) 
    - 3: Check the copy state
    - 4: Send e-mail report 
    

