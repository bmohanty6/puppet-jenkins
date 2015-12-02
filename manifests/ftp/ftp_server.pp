class jenkins::ftp::ftp_server(
     $server_package_name = $::jenkins::ftp::ftp_params::server_package_name,
     $service_name = $::jenkins::ftp::ftp_params::service_name,
     $conf_dir = $::jenkins::ftp::ftp_params::conf_dir,
  )inherits ::jenkins::ftp::ftp_params{

  package { $server_package_name:
     ensure => 'installed'
  }

  service { $service_name:
    require   => Package[$server_package_name],
    enable    => true,
    ensure    => running,
    hasstatus => true,
  }

  file { "${conf_dir}/vsftpd.conf":
    require => Package[$server_package_name],
    source => ["puppet:///modules/jenkins/vsftpd.conf"],
    notify  => Service[$service_name],
  }

  exec { "enable Home directory access" :
    require => Service[$service_name],
    command => 'setsebool -P ftp_home_dir on',
  }

  exec { "enable ftpd full access" :
    require => Service[$service_name],
    command => 'setsebool -P allow_ftpd_full_access on',
  }

 file { '/tmp/ftp-data':
    ensure => 'directory',
    mode => '0765',
    recurse => 'true',
    owner => 'jenkins',
  }

 file { '/tmp/ftp-data/pub':
    ensure => 'directory',
    require => File['/tmp/ftp-data'],
    mode => '0765',
    recurse => 'true',
    owner => 'jenkins',
  }

  user {'anonymous':
    ensure => 'present',
    require => File['/tmp/ftp-data/pub'],
    password => 'anonymous',
    home => '/tmp/ftp-data'
  }

  user {'ftp' :
    ensure => 'present',
    home => '/tmp/ftp-data'
  }
}
