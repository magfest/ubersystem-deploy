import 'ssh.pp'

class role_common (
  $timezone,
) {
  include ssh

  include '::ntp'

  class { 'timezone':
    timezone => $timezone,
  }

  # users in this group can sudo
  group { 'admin':
    ensure => present
  }
}

class roles::uber_server () inherits role_common {
  class { 'postgresql::server':
    ip_mask_deny_postgres_user => '0.0.0.0/32',
    ip_mask_allow_all_users    => '0.0.0.0/0',
    listen_addresses           => 'localhost',
    manage_firewall            => true,
  }

  include nginx
  include uber

  include uber::rams_app_stack
}