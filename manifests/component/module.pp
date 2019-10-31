define rsyslog::component::module (
  Integer           $priority,
  String            $target,
  String            $confdir,
  Optional[Hash]    $config = {},
  Optional[String]  $type = 'external',
  Optional[String]  $format = '<%= $content %>'
) {

  include rsyslog

  $content = epp('rsyslog/modules.epp', {
        'config_item' => $name,
        'type'        => $type,
        'config'      => $config,
  })

  rsyslog::generate_concat { "rsyslog::concat::module::${name}":
    confdir => $confdir,
    target  => $target,
  }

  concat::fragment {"rsyslog::component::module::${name}":
    target  => "${confdir}/${target}",
    content => inline_epp($format),
    order   => $priority,
  }
}

