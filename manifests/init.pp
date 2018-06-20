# === Class tc ===
# Simplest attempt to automate traffic shaping with tc in Linux
# Creates and runs the script which also can be added to /etc/rc.local
#
# Use defined types tc::<discipline> (currently only tc::htb is implemented)
# to fill the script with commands.
#
# === Parameters ===
# [*script*]
#   Full path to the script with tc commands.
#   Default: /root/tc.sh
#
# [*autostart*]
#   Flag to indicate where the script must be run on system startup.
#   Default: true
#
class tc (
  Stdlib::Unixpath $script    = '/root/tc.sh',
  Boolean          $autostart = true,
) {

  concat { $script:
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    notify => Exec['apply-tc-script'],
  }

  concat::fragment { 'tc-script-header':
    target  => $script,
    content => "#!/bin/bash\n\n",
    order   => '01',
  }

  exec { 'apply-tc-script':
    command     => $script,
    refreshonly => true,
  }
    

  if $autostart {
    file_line { 'run tc script on startup':
      path => '/etc/rc.local',
      line => $script
    }
  }
}
