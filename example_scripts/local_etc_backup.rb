#!/usr/bin/env ruby

# A script to back up etc, locally, in /root/etc_backup

require "dated_backup"

DatedBackup.new(
  :source => "/etc",
  :destination => "/root/etc_backup"
).run