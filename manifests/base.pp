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
                "puppet://$server/modules/site-pureftp/${fqdn}/pureftpd.passwd",
                "puppet://$server/modules/site-pureftp/pureftpd.passwd",
                "puppet://$server/modules/pureftp/pureftpd.passwd"
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
