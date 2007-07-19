
sources       = /etc, /home
destination   = /var/backups/network/backups/example.com

# the last value must be quoted, since it has an equal sign
rsync_options = --verbose,                          
                %q(-e 'ssh -i /root/.ssh/rsync-key'),   
                %q(--rsync-path = sudo rsync)
                

                
user_domain   = nbackup@example.com
