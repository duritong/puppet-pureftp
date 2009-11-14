class pureftp::gentoo inherits pureftp::base {
    Package[pure-ftpd]{
        category => 'net-ftp'
    }

    gentoo::etcconfd {pure-ftpd: require => Package[pure-ftpd], notify => Service[pure-ftpd]}
}
