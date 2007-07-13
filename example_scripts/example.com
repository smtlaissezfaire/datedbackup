
sources       = /etc, /home
destination   = /var/backups/network/backups/example.com

# the last value must be quoted, since it has an equal sign
rsync_options = --verbose,                          
                -e 'ssh -i /root/.ssh/rsync-key',   
                '--rsync-path = sudo rsync'
                
                
                
user_domain   = nbackup@example.com

# special chars:
# equal sign, comma, single quote, double quote
# the file is read, and then "" escaped
# everything inside single quotes will not be parsed
# so use them to quote a one of the special chars
# How to escape a single quote:
# use \"'\"
# Right now, this will not work