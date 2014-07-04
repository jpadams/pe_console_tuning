class pe_console_tuning (
  $console_timeout = 1200,
  $facts_array = ["architecture", "domain", "fqdn", "hardwaremodel", "hostname", "ipaddress", "is_virtual", "manufacturer", "memorytotal", "operatingsystem", "operatingsystemrelease", "physicalprocessorcount", "processorcount", "productname", "puppetversion"] 
) {

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

}
