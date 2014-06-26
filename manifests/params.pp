class slapd::params {
    $ensure         = 'present'
    $ensure_running = true
    $ensure_enabled = true
    $manage_config      = true
    $config_file        = '/etc/ldap/slapd.conf'
    $config_template    = undef
    $config_source      = undef
    $disabled_hosts     = []
}

