# modules/pureftp/manifests/init.pp - manage pureftp stuff
# Copyright (C) 2007 admin@immerda.ch
#

# modules_dir { "pureftp": }

class pureftp {
    $modulename = "pureftp" 
    $pkgname = "pure-ftpd"
    $gentoocat = "net-ftp"
    $cnfname = "pure-ftpd"
    $cnfpath = "/etc/conf.d"

    package { $pkgname:
        ensure => present,
        category => $operatingsystem ? {
            gentoo => $gentoocat,
            default => '',
        }
    }

    file{
        "${cnfpath}/${cnfname}":
            source => [
                "puppet://$server/dist/${modulename}/${fqdn}/${cnfname}",
                "puppet://$server/${modulename}/${fqdn}/${cnfname}",
                "puppet://$server/${modulename}/${cnfname}"
            ],
            owner => root,
            group => 0,
            mode => 0444,
            require => Package[$pkgname],
            notify => Service[$pkgname],
    }

    # db
    $filename="pureftpd.pdb"
    $filepath="/srv/ftp"
    file{
        "${filepath}/${$filename}":
            source => [
                "puppet://$server/dist/${modulename}/${fqdn}/${filename}",
                "puppet://$server/${modulename}/${fqdn}/${filename}",
                "puppet://$server/${modulename}/${filename}"
            ],
            owner => root,
            group => 0,
            mode => 0444,
            require => Package[$pkgname],
            notify => Service[$pkgname],
    }

    $filename="pureftpd.passwd"
    $filepath="/srv/ftp"
    file{
        "${filepath}/${$filename}":
            source => [
                "puppet://$server/dist/${modulename}/${fqdn}/${filename}",
                "puppet://$server/${modulename}/${fqdn}/${filename}",
                "puppet://$server/${modulename}/${filename}"
            ],
            owner => root,
            group => 0,
            mode => 0444,
            require => Package[$pkgname],
    }

    service { 
        $pkgname: 
            ensure  => running,
            enable => true,
            hasstatus => true,
            hasrestart => true,
    } 


}
