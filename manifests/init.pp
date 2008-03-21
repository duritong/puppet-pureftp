# modules/pureftp/manifests/init.pp - manage pureftp stuff
# Copyright (C) 2007 admin@immerda.ch
#

# modules_dir { "pureftp": }

class pureftp {
    case $operatingsystem {
        gentoo: { include pure-ftpd::gentoo }
        default: { include pure-ftpd::base }
    }
}

class pureftp::base {
    package { pure-ftpd:
        ensure => present,
    }

    file{"/srv/ftp":
        ensure => directory,
        owner => root,
        uid => 0,
        mode => 755,
        require => File[/srv],
    }

    file{
        "/srv/ftp/pureftpd.passwd":
            source => [
                "puppet://$server/dist/pureftp/${fqdn}/pureftpd.passwd",
                "puppet://$server/dist/pureftp/${fqdn}/pureftpd.passwd",
                "puppet://$server/pureftp/pureftpd.passwd"
            ],
            owner => root,
            group => 0,
            mode => 600,
            require => [ Package[pure-ftpd], File[/srv/ftp] ],
            notify => Exec[update_pure-ftpd_db],
    }

    exec{update_pure-ftpd_db:
        command => "pure-pw mkdb /srv/ftp/pureftpd.pdb -f /srv/ftp/pureftpd.passwd",
        path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin:/usr/local/sbin",
        refreshonly => true,
    }

    service { 
        pure-ftpd: 
            ensure  => running,
            enable => true,
            hasstatus => true,
            hasrestart => true,
    } 
}

class pureftpd::gentoo inherits pureftpd::base {
    Package[pure-ftpd]{
        category => 'net-ftp'
    }

    gentoo::etcconfd { pure-ftpd: require => Package[pure-ftpd], notify => Service[pure-ftpd]}
}
