#!/bin/bash
#       This program is free software; you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation; either version 2 of the License, or
#       (at your option) any later version.
#       
#       This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#       GNU General Public License for more details.
#       
#       You should have received a copy of the GNU General Public License
#       along with this program; if not, write to the Free Software
#       Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#       MA 02110-1301, USA.


#--------AUTEUR-------------------------------------------------
#
# Script realised par Ben00it
# date : 21/04/2010

# ------DESCRIPTION---------------------------------------------
#
# This sript can perform backups using rsync, and send an report email to his 
# System administrator to check your proper functioning, or not.
# This script is easy, it check mountpoint and resended a error code >2 
# Otherwise it's done :)

# ------PREREQUISITE---------------------------------------------
#
# Need RSYNC :
#       $ aptitude install rsync
# We assume that your favorite mailer is configured

# ------HOW IT WORKS---------------------------
#
# This sript is in four steps :
#
# - 1: Check mounpoint / Send email
# - 2: Launching the rsync copy
# - 3: Check state copy
# - 4: Send e-mail report
# - For information, the fields "+" are editing
# ----------------------------------------------------------------


#-------Define variables------
# -> Variable Mount
POINTDEMONTAGE="/your/mount/to/copy"              # Editing : This mount pont is needed for the check and copy +
MOUNTOK="The mount is OK "
MOUNTNOK="/!\_ The mount NAS $POINTDEMONTAGE isn't monted_/!\ "
CHECK_FSTAB=`cat /etc/fstab | grep $POINTDEMONTAGE` # Just for precise mount line in email
MSG_CHECK="You can check the mount fstab : $CHECK_FSTAB and connectivity with the NAS"
DEBUGINFO="For information (NAS : ping 192.168.X.X)"

# -> Variables RSYNC
SRC="/data/"       # Indicate the source of backup  +

# -> Variable mail
RECEIVER="support@admin-system.com" # Address  destination Administor +
SUBJECT_NOK="/!\Backup_NOK"
SUBJECT_OK="Backup_OK"

# -> Variable RSYNC send mail
ALL_IS_OK="The backup was successful, and thats all! "
ALL_ISNT_OK="The backup did not go well, see the attached file"

# --- Define fonctions :

function F_OK {
echo -e "$MOUNTOK" \n "$ALL_IS_OK" | mail -s $SUBJECT_OK $RECEIVER
}

function F_NOTOK {
echo  "$ALL_ISNT_OK" | mail -s $SUBJECT_NOK $RECEIVER <$ERROR_FILE
}

function F_RSYNC {
rsync -rauv -c $SRC $POINTDEMONTAGE 2>/tmp/error_rsync_$$
}

function F_CHECK_ERRORS {
ERROR_FILE="/tmp/error_rsync_$$"
export ERROR_FILE
if [ -s $ERROR_FILE ]
 then F_NOTOK
else
F_OK
fi
}

# --- Beginning of the script : --- #
# ->  Check mount point :

mountpoint $POINTDEMONTAGE

if [ $? -eq 0 ] ; then

# -> If mount OK, go script
        F_RSYNC
        F_CHECK_ERRORS
else

# -> If mount NOK, send email

        # echo -e $MOUNTNOK
        echo -e "$MOUNTNOK  \n\n\n $MSG_CHECK \n $DEBUGINFO" | mail -s $SUBJECT_NOK $RECEIVER
        exit 0
fi

exit 0
