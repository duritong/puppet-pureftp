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
