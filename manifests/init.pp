# modules/pureftp/manifests/init.pp - manage pureftp stuff
# Copyright (C) 2007 admin@immerda.ch
#

# modules_dir { "pureftp": }

class pureftp {
    case $operatingsystem {
        gentoo: { include pureftp::gentoo }
        default: { include pureftp::base }
    }
}

class pureftp::base {
    package { pure-ftpd:
        ensure => present,
    }

    file{"/srv/ftp":
        ensure => directory,
        owner => root,
        group => 0,
        mode => 755,
        require => File["/srv"],
    }

    file{"/srv/logs/ftp":
        ensure => directory,
        owner => root,
        group => 0,
        mode => 755,
        require => File["/srv/logs"],
    }

    file{
        "/srv/ftp/pureftpd.passwd":
            source => [
                "puppet://$server/files/pureftp/${fqdn}/pureftpd.passwd",
                "puppet://$server/files/pureftp/pureftpd.passwd",
                "puppet://$server/pureftp/pureftpd.passwd"
            ],
            owner => root,
            group => 0,
            mode => 600,
            require => [ Package[pure-ftpd], File["/srv/ftp"] ],
            notify => Exec[update_pure-ftpd_db],
    }

    file{"/etc/ssl/private/pure-ftpd.pem":
        ensure => "/e/certs/server.pem",
        require => File["selfsigned_pem"],
        notify => Service[pure-ftpd],
    }

    exec{update_pure-ftpd_db:
        command => "pure-pw mkdb /srv/ftp/pureftpd.pdb -f /srv/ftp/pureftpd.passwd",
        refreshonly => true,
    }

    service { 
        pure-ftpd: 
            ensure  => running,
            enable => true,
            hasstatus => true,
            hasrestart => true,
            require => [ File["/srv/ftp/pureftpd.passwd"], Package[pure-ftpd] ],
    } 
}

class pureftp::gentoo inherits pureftp::base {
    Package[pure-ftpd]{
        category => 'net-ftp'
    }

    gentoo::etcconfd {pure-ftpd: require => Package[pure-ftpd], notify => Service[pure-ftpd]}
}
