# = Class: slapd
#
# Module to manage slapd
#
# == Requirements:
#
# - This module makes use of the example42 functions in the puppi module
#   (https://github.com/credativ/puppet-example42lib)
#
# == Parameters:
#
# [* ensure *]
#   What state to ensure for the package. Accepts the same values
#   as the parameter of the same name for a package type.
#   Default: present
#   
# [* ensure_running *]
#   Weither to ensure running slapd or not.
#   Default: running
#
# [* ensure_enabled *]
#   Weither to ensure that slapd is started on boot or not.
#   Default: true
#
# [* config_source *]
#   Specify a configuration source for the configuration. If this
#   is specified it is used instead of a template-generated configuration
#
# [* config_template *]
#   Override the default choice for the configuration template
#
# [* disabled_hosts *]
#   A list of hosts whose slapd will be disabled, if their
#   hostname matches a name in the list.
#

class slapd (
    $ensure             = params_lookup('ensure'),
    $ensure_running     = params_lookup('ensure_running'),
    $ensure_enabled     = params_lookup('ensure_enabled'),
    $manage_config      = params_lookup('manage_config'),
    $config_file        = params_lookup('config_file'),
    $config_source      = params_lookup('config_source'),
    $config_template    = params_lookup('config_template'),
    $disabled_hosts     = params_lookup('disabled_hosts'),
    ) inherits slapd::params {

    package { 'slapd':
        ensure => $ensure
    }

    service { 'slapd':
        ensure      => $ensure_running,
        enable      => $ensure_enabled,
        hasrestart  => true,
        hasstatus   => true,
        require     => Package['slapd']
    }

    # Disable service on this host, if hostname is in disabled_hosts
    if $::hostname in $disabled_hosts {
        Service <| title == 'slapd' |> {
            ensure  => 'stopped',
            enabled => false,
        }
    }

    if $manage_config {
        file { $config_file:

            mode    => '0644',
            owner   => 'root',
            group   => 'root',
            tag     => 'slapd_config',
            notify  => Service['slapd']
        }


        if $config_source {
            File <| tag == 'slapd_config' |> {
                source  => $config_source
            }
        } elsif $config_template {
            File <| tag == 'slapd_config' |> {
                content => $config_template
            }
        }
    }
}

