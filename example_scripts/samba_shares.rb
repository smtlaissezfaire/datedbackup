#!/usr/bin/env ruby

# A general purpose script to copy some WinXP/2000 shares
# on a local network.  The shares are the 'C' drives
# of the various nodes on the network.  They are mounted
# under /mnt/share/node_name.  Dated, incrememntal 
# backups will be run with this script (put it in cron)
# for however often your sysadmin heart desires.
#
# Note that the shares had to be remounted before doing this,
# as we are still using smbfs mount driver, and not the newer
# cifs (todo).  As a security procedure, we are unmounting them
# afterwords, even though they are in the fstab (as read-only)
#
# Although this script is designed for WinXP specifically,
# there is no reason that it couldn't also be used for mounted
# NFS drives, or even for a rudimentary Version Control
# for any set of files (locally, or remotely)
 
require "dated_backup"

puts "* mounting the samba clients"
%x(mount //teresa2/c)
%x(mount //jay/c)
%x(mount //claudio/c)

DatedBackup.new(
  :source => "/mnt/shares",
  :destination => "/var/backups/network/backups/shares",
  :options => "-v" 
).run

# umount the clients
puts "* umounting samba clients"
%x(umount //teresa2/c)
%x(umount //jay/c)
%x(umount //claudio/c)

