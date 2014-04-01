class cloudpd_nagiosclient {

  $user = "nagios"
  $group = "nagios"
  $uid = 50310
  $gid = 50310
  $shell = "/bin/bash"
  $home_dir ="/home/nagios"
  $ssh_key_type ="ssh-rsa"
  $ssh_key = "AAAAB3NzaC1yc2EAAAABIwAAAQEAq5Q+DGMesZgGftrhoCqq+FC9aAPY+9JiOImlmi/ZCd6rsbybi9AuLRdThK/1RO7ctdOyHZ1JyldXUEaIAYOeFtgu9ClHzPmxCujf2A2+x5sYYl7zO73TZeU6Zq619e+sBNZ7/kU0NWYsr/FTJHUiCLH9LT2xf672riWGtfVBaL6IdMl1Y5kG0VQ+ET6gKIKonXmJtJ3/40vhPzAnDkU3FUUQIaIxKZKn6z8lUxqNpNF2HNKoUg9YItPXZRSmwmSzNA5X9b/Vu1539s8nb6eTz1zssgPX6gTejXvVlPpAXRsF9N/fYINgZ2XBMS72n2ziPIzMLWCvwaqOLhc/YZ1x4w=="

  
  # Install nagios plugins packages
  $pluginspackages = [ "nagios-plugins", "nagios-plugins-disk", "nagios-plugins-load", "nagios-plugins-procs" ]
  package { $pluginspackages: ensure => "installed" }

  # Create nagios group 
  group { "$group":
        gid => $gid,
        ensure => "present",
  }

  # Create nagios user 
  user { "$user":
      ensure     => "present",
      managehome => true,
      uid        => $uid,
      shell      => $shell,
      gid        => $gid,
      home       => $home_dir,
    }

  # Creates the ssh dir  
  file {
      "nagios_home":
              ensure  => "directory",
              path    => $home_dir,
              owner   => $user,
              group   => $group,
              mode    => 0750;

       "nagios_sshdir":
              ensure  => "directory",
              path    => "${home_dir}/.ssh",
              owner   => $user,
              group   => $group,
              mode    => 0700;
        }

  # Creates the ssh_authorized_key file
  File["nagios_sshdir"]->
            ssh_authorized_key {
                    $title:
                              ensure  => "present",
                              type    => $ssh_key_type,
                              name    => "${user} SSH Key",
                              user    => $user,
                      key     => $ssh_key,
                      }
        
}
 
  
