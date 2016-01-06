# Class: jenkins::params
#
#
class jenkins::params inherits srp::srp{
  $version            = 'installed'
  $lts                = false
  $repo               = true
  $service_enable     = true
  $service_ensure     = 'running'
  $install_java       = true
  $swarm_version      = '1.16'
  $srp_config		  =  $::srp::srp_config,
  $cluster		  	  =  $::srp::cluster,
  $facet		  	  =  $::srp::facet,
  $facet_index		  =  $::srp::facet_index
} 


