class pe_console_tuning (
  $console_timeout = 1200,
  $facts_array = ["architecture", "domain", "fqdn", "hardwaremodel", "hostname", "ipaddress", "is_virtual", "manufacturer", "memorytotal", "operatingsystem", "operatingsystemrelease", "physicalprocessorcount", "processorcount", "productname", "puppetversion"],
  $resources_array = ['user','package','host','group','service'],
  $show_certnames_live_mgmt = false
) {

  if ! is_integer($console_timeout) {
    fail("\$console_timeout param must be an integer but was ${console_timeout}")
  }
  validate_array($facts_array)
  validate_array($resources_array)
  validate_bool($show_certnames_live_mgmt)

  file_line { 'console timeout setting 1 of 2':
    path  => '/etc/puppetlabs/rubycas-server/config.yml',
    match => 'maximum_session_lifetime:',
    line  => "maximum_session_lifetime: ${console_timeout}",
  }

  file_line { 'console timeout setting 2 of 2':
    path  => '/etc/puppetlabs/console-auth/cas_client_config.yml',
    match => 'session_timeout:',
    # Spaces in 'line' value must be present or PE Console will not start
    line  => "  session_timeout: ${console_timeout}",
  }

  $facts = inline_template('<%= @facts_array.to_s %>')

  file_line { 'facts suggestions for Live Management':
    path  => '/opt/puppet/share/live-management/public/javascripts/app_controller.js',
    match => "PuppetEnterpriseConsole.set\('factNames',",
    line  => "    PuppetEnterpriseConsole.set('factNames', ${facts});",
  }

  $resources = inline_template('<%= @resources_array.to_s.gsub(/ /, "").gsub(/"/,"\'")  %>')

  file_line { 'browsable resources in Live Management':
    path   => '/opt/puppet/share/live-management/live_management.rb',
    match  => 'collect do',
    line   => "    ${resources}.collect do |type|",
    notify => Service['pe-mcollective'],
  }

  case $show_certnames_live_mgmt {
    true:  { $mode = 'block' }
    false: { $mode = 'none' }
    default: {
      fail("\$show_certnames_live_mgmt must be boolean but was ${show_certnames_live_mgmt}")
    }
  }

  file_line { 'show certnames by default in Live Management':
    path  => '/opt/puppet/share/live-management/views/index.erb',
    match => '<div class="node-list" style="display:',
    line  => "      <div class=\"node-list\" style=\"display: ${mode}\">",
  }

}
