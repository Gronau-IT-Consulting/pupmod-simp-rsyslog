# **NOTE: THIS IS A [PRIVATE](https://github.com/puppetlabs/puppetlabs-stdlib#assert_private) CLASS**
#
# Setup RSyslog configuration. Creates /etc/rsyslog.conf and includes
# all SIMP config subdirectories in /etc/rsyslog.simp.d.
#
# **NOTE** Any undocumented parameters map directly to their counterparts in
# the Rsyslog configuration files.
#
# @param umask
#   The umask that should be applied to the running process
#
# @param localhostname
#   The Hostname that should be used on your syslog messages
#
# @param preserve_fqdn
#   Ensure that the ``fqdn`` of the originating host is preserved in all log
#   messages
#
# @param control_character_escape_prefix
# @param drop_msgs_with_malicious_dns_ptr_records
# @param escape_control_characters_on_receive
#
# @param default_template
#   The default template to use to output to various services
#
#   * The provided template has been designed to work with external parsing
#     tools that require the priority text
#
#   * You can also choose from the following values in order to select from one
#     of the built-in rsyslogd formats.
#
#       * forward     -> RSYSLOG_Forward
#       * original    -> RSYSLOG_FileFormat
#       * traditional -> RSYSLOG_TraditionalFileFormat
#
# @param syssock_ignore_timestamp
# @param syssock_ignore_own_messages
# @param syssock_use
# @param syssock_name
# @param syssock_flow_control
# @param syssock_use_pid_from_system
# @param syssock_rate_limit_interval
# @param syssock_rate_limit_burst
# @param syssock_rate_limit_severity
# @param syssock_use_sys_timestamp
# @param syssock_annotate
# @param syssock_parse_trusted
# @param syssock_unlink
#
# @param main_msg_queue_type
#   The type of queue that will be used
#
#   * It is **highly** recommended that you leave this as ``LinkedList`` unless
#     you really know what you are doing.
#
# @param main_msg_queue_filename
#
# @param main_msg_queue_size
#   The size of the main (global) message queue
#
#   * By default, the minimum of 1% of physical memory or 1G, based on a 512B
#     message size. The maximum number of messages that may be stored in the
#     memory queue.
#
# @param main_msg_queue_high_watermark
#   The point at which the queue will start writing messages to disk as a
#   number of messages
#
#   * By default, 90% of ``$main_msg_queue_size``
#
# @param main_msg_queue_low_watermark
#   The point at which the queue will stop writing messages to disk as a number
#   of messages
#
#   * **NOTE:** This must be **lower** than ``$main_msg_queue_high_watermark``
#   * By default, 70% of ``$main_msg_queue_size``
#
# @param main_msg_queue_discardmark
#   The point at which the queue will discard messages
#
#   * By default, 98% of ``$main_msg_queue_size``
#
# @param main_msg_queue_worker_thread_minimum_messages
#   The minimum number of messages in the queue before a new thread can be
#   spawned
#
#   * If left empty (the default), will calculate the value based on the
#     following formula: ``$main_msg_queue_size/(($processorcount - 1)*4)``
#
# @param main_msg_queue_worker_threads
#   The maximum number of threads to spawn on the system
#
#   * By default, ``$processorcount - 1``
#
# @param main_msg_queue_worker_timeout_thread_shutdown
# @param main_msg_queue_timeout_enqueue
# @param main_msg_queue_dequeue_slowdown
# @param main_msg_queue_save_on_shutdown
#
# @param main_msg_queue_max_disk_space
#   The maximum amount of disk space to use for the disk queue.
#
#   * Specified as a digit followed by a unit specifier. For example:
#
#       * 100   -> 100 Bytes
#       * 100K  -> 100 Kilobytes
#       * 100M  -> 100 Megabytes
#       * 100G  -> 100 Gigabytes
#       * 100T  -> 100 Terabytes
#       * 100P  -> 100 Petabytes
#
#   * If not specified, will default to ``$main_msg_queue_size * 1024``
#
# @param main_msg_queue_max_file_size
#   The maximum file size, in Megabytes, that should be created when buffering
#   to disk.
#
#   * **NOTE:** It is not recommended to make this excessively large
#
# @param repeated_msg_reduction
# @param work_directory
#
# @param interval
#   The ``mark`` interval
#
# @param tls_tcp_max_sessions
#   The maximum number of sessions to support
#
# @param tls_input_tcp_server_stream_driver_permitted_peers
#   A *wildcard-capable* Array of domains that should be allowed to talk to the
#   server over ``TLS``
#
# @param default_net_stream_driver
# @param default_net_stream_driver_ca_file
# @param default_net_stream_driver_cert_file
# @param default_net_stream_driver_key_file
# @param action_send_stream_driver_mode
# @param action_send_stream_driver_auth_mode
# @param action_send_stream_driver_permitted_peers
#
# @param ulimit_max_open_files
#   The maximum open files limit that should be set for the syslog server
#
#   * ``1024`` is fine for most purposes, but a collection server should bump this
#     **way** up.
#
# @param host_list
#   Hosts that should be logged with their simple hostname
#
#   * See the ``-l`` option in ``rsyslogd(8)`` for more information
#
# @param domain_list
#   Array of domains that should be stripped off before logging
#
#   * See the ``-s`` option in ``rsyslogd(8)`` for more information
#
# @param suppress_noauth_warn
#   Suppress warnings due to hosts not in the ACL
#
#   * See the ``-w`` option in ``rsyslogd(8)`` for more information
#
# @param disable_remote_dns
#   Disable DNS lookups for remote messages
#
#   * See the ``-x`` option in ``rsyslogd(8)`` for more information
#
# @param enable_default_rules
#   Enables default rules for logging common services (e.g., iptables, puppet, slapd_auditd)
#
# @param read_journald
#   Enable the forwarding of the ``systemd`` journal to syslog
#
# @param include_rsyslog_d
#   Include all configuration files in the system-standard ``/etc/rsyslog.d``
#
#   * This will place the configuration files **after** the global
#     configuration but **before** the SIMP applied configurations.
#
class rsyslog::config (
  String                                $umask                                              = '0027',
  String                                $localhostname                                      = $facts['fqdn'],
  Boolean                               $preserve_fqdn                                      = true,
  String[1,1]                           $control_character_escape_prefix                    = '#',
  Enum['off','on']                      $drop_msgs_with_malicious_dns_ptr_records           = 'off',
  Enum['off','on']                      $escape_control_characters_on_receive               = 'on',
  String                                $default_template                                   = 'original',

  # Parameters for imuxsock with sensible defaults
  Boolean                               $syssock_ignore_timestamp                           = true,
  Boolean                               $syssock_ignore_own_messages                        = true,
  Boolean                               $syssock_use                                        = true,
  Optional[String]                      $syssock_name                                       = undef,
  Boolean                               $syssock_flow_control                               = false,
  Boolean                               $syssock_use_pid_from_system                        = false,
  Integer[0]                            $syssock_rate_limit_interval                        = 0,
  Integer[0]                            $syssock_rate_limit_burst                           = 1000,
  Integer[0]                            $syssock_rate_limit_severity                        = 5,
  Boolean                               $syssock_use_sys_timestamp                          = true,
  Boolean                               $syssock_annotate                                   = false,
  Boolean                               $syssock_parse_trusted                              = false,
  Boolean                               $syssock_unlink                                     = true,

  # Main message queue global defaults
  Enum['LinkedList','FixedArray']       $main_msg_queue_type                                = 'LinkedList',
  String                                $main_msg_queue_filename                            = 'main_msg_queue',
  Integer[0]                            $main_msg_queue_max_file_size                       = 5,
  Optional[Integer[0]]                  $main_msg_queue_size                                = undef,
  Optional[Integer[0]]                  $main_msg_queue_high_watermark                      = undef,
  Optional[Integer[0]]                  $main_msg_queue_low_watermark                       = undef,
  Optional[Integer[0]]                  $main_msg_queue_discardmark                         = undef,
  Optional[Integer[0]]                  $main_msg_queue_worker_thread_minimum_messages      = undef,
  Optional[Integer[0]]                  $main_msg_queue_worker_threads                      = undef,
  Integer[0]                            $main_msg_queue_worker_timeout_thread_shutdown      = 5000,
  Integer[0]                            $main_msg_queue_timeout_enqueue                     = 100,
  Integer[0]                            $main_msg_queue_dequeue_slowdown                    = 0,
  Enum['on','off']                      $main_msg_queue_save_on_shutdown                    = 'on',
  Optional[Integer[0]]                  $main_msg_queue_max_disk_space                      = undef,

  Enum['on','off']                      $repeated_msg_reduction                             = 'on',
  Stdlib::Absolutepath                  $work_directory                                     = '/var/spool/rsyslog',
  Integer[0]                            $interval                                           = 0,
  Integer[0]                            $tls_tcp_max_sessions                               = 200,
  Array[String]                         $tls_input_tcp_server_stream_driver_permitted_peers = ["*.${::domain}"],

  Enum['gtls','ptcp']                   $default_net_stream_driver                          = 'gtls',
  Stdlib::Absolutepath                  $default_net_stream_driver_ca_file                  = "${::rsyslog::app_pki_dir}/cacerts/cacerts.pem",
  Stdlib::Absolutepath                  $default_net_stream_driver_cert_file                = "${::rsyslog::app_pki_dir}/public/${::fqdn}.pub",
  Stdlib::Absolutepath                  $default_net_stream_driver_key_file                 = "${::rsyslog::app_pki_dir}/private/${::fqdn}.pem",

  Enum['1','0']                         $action_send_stream_driver_mode                     = ($::rsyslog::pki or $::rsyslog::tls_tcp_server or $::rsyslog::enable_tls_logging) ? { true => '1', default => '0' },
  Optional[String]                      $action_send_stream_driver_auth_mode                = undef,
  Array[String]                         $action_send_stream_driver_permitted_peers          = $::rsyslog::log_servers,

  Variant[Enum['unlimited'],Integer[0]] $ulimit_max_open_files                              = 'unlimited',
  Array[String]                         $host_list                                          = [],
  Array[String]                         $domain_list                                        = [],
  Boolean                               $suppress_noauth_warn                               = false,
  Boolean                               $disable_remote_dns                                 = false,
  Boolean                               $enable_default_rules                               = true,
  Boolean                               $read_journald                                      = $::rsyslog::read_journald,
  Boolean                               $include_rsyslog_d                                  = false
) {
  assert_private()

  $_tcp_server = pick($::rsyslog::tcp_server, false)
  $_tls_tcp_server = pick($::rsyslog::tls_tcp_server, false)
  $_tcp_listen_port = pick($::rsyslog::tcp_listen_port, '514')
  $_tls_tcp_listen_port = pick($::rsyslog::tls_tcp_listen_port, '6514')
  $_udp_server = pick($::rsyslog::udp_server, false)
  $_udp_listen_port = pick($::rsyslog::udp_listen_port, '514')
  $_enable_tls_logging = pick($::rsyslog::enable_tls_logging, false)

  if $facts['os']['name'] in ['RedHat','CentOS'] {
    $_sysconfdir = '/etc/sysconfig'
    $_sysconfig_template = 'sysconfig.erb'
  }
  elsif $facts['os']['name'] in ['Debian','Ubuntu'] {
    $_sysconfdir = '/etc/default'
    $_sysconfig_template = 'default.erb'
  }
  else {
    fail("OS '${facts['os']['name']}' not supported by '${module_name}'")
  }

  if $::rsyslog::pki {
    pki::copy { 'rsyslog':
      source => $::rsyslog::app_pki_external_source,
      pki    => $::rsyslog::pki
    }
  }

  if $read_journald and member($facts['init_systems'], 'systemd') {
    $_read_journald = true
  }
  else {
    $_read_journald = false
  }

  # set the driver auth_mode based on the mode
  if $action_send_stream_driver_auth_mode {
    $_action_send_stream_driver_auth_mode = $action_send_stream_driver_auth_mode
  }
  else {
    $_action_send_stream_driver_auth_mode = $action_send_stream_driver_mode ? {
      '0'     => 'anon',
      default => 'x509/name'
    }
  }

  $_default_template = $default_template ? {
    'traditional' => 'RSYSLOG_TraditionalFormat',
    'original'    => 'RSYSLOG_FileFormat',
    'forward'     => 'RSYSLOG_ForwardFormat',
    default       => $default_template
  }

  # This is where the custom rules will go. They will be purged if not managed!
  file { $::rsyslog::rule_dir:
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    recurse => true,
    purge   => true,
    force   => true,
    mode    => '0750'
  }

  file { '/etc/rsyslog.d':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755'
  }

  file { '/etc/rsyslog.d/README_SIMP.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => '# Place ".conf" files that rsyslog should process independently of SIMP into this directory.\n'
  }

  file { '/var/spool/rsyslog':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0700'
  }

  if $enable_default_rules {
    rsyslog::rule { '99_simp_local/ZZ_default.conf':
      content => file("${module_name}/config/rsyslog.default")
    }
  }

  file { '/etc/rsyslog.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => "\$IncludeConfig ${::rsyslog::rule_dir}/*.conf"
  }

  file { "${_sysconfdir}/rsyslog":
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template("${module_name}/${_sysconfig_template}")
  }

  rsyslog::rule { '00_simp_pre_logging/global.conf':
    content => template("${module_name}/config/pre_logging.conf.erb")
  }

  rsyslog::rule { '09_failover_hack/failover_hack.conf':
    # lint:ignore:variable_scope
    content => @(EOM)
      # For failover to be defined and parse properly, we must place it somewhere
      # after the first rule is defined. Therefore, we are creating this noop rule.

      if $syslogfacility == 'local0' and $msg startswith 'placeholder_rule' then continue
      |EOM
    # lint:endignore
  }

  if $include_rsyslog_d {
    rsyslog::rule { '15_include_default_rsyslog/include_default_rsyslog.conf':
      content => '$IncludeConfig /etc/rsyslog.d/'
    }
  }

  rsyslog::template::string { 'defaultTemplate':
    string => $_default_template
  }

  # Set the maximum number of open files in the init script.
  init_ulimit { 'mod_open_files_rsyslog':
    target => 'rsyslog',
    item   => 'max_open_files',
    value  => $ulimit_max_open_files
  }
}
