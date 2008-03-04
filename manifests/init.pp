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
    $file1name="pureftpd.pdb"
    $file1path="/srv/ftp"
    file{
        "${file1path}/${$file1name}":
            source => [
                "puppet://$server/dist/${modulename}/${fqdn}/${file1name}",
                "puppet://$server/${modulename}/${fqdn}/${file1name}",
                "puppet://$server/${modulename}/${file1name}"
            ],
            owner => root,
            group => 0,
            mode => 0444,
            require => Package[$pkgname],
            notify => Service[$pkgname],
    }

    $file2name="pureftpd.passwd"
    $file2path="/srv/ftp"
    file{
        "${file2path}/${$file2name}":
            source => [
                "puppet://$server/dist/${modulename}/${fqdn}/${file2name}",
                "puppet://$server/${modulename}/${fqdn}/${file2name}",
                "puppet://$server/${modulename}/${file2name}"
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
