class openresty::package {
  include openresty::param

  if ! defined(Package['readline-devel']) { package { 'readline-devel': ensure => installed, } }
  if ! defined(Package['pcre-devel']) { package { 'pcre-devel': ensure => installed, } }
  if ! defined(Package['openssl-devel']) { package { 'openssl-devel': ensure => installed, } }
  if ! defined(Package['wget']) { package { 'wget': ensure => installed, } }
  if ! defined(Package['gcc']) { package { 'gcc': ensure => installed, } }
  if ! defined(Package['gcc-c++']) { package { 'gcc-c++': ensure => installed, } }
  if ! defined(Package['perl']) { package { 'perl': ensure => installed, } }

  exec { 'openresty::package::download_openresty':
    cwd     => '/tmp',
    command => "wget ${openresty::param::openresty_url} -O openresty.tar.gz",
    creates => '/tmp/openresty.tar.gz',
    require  => [
      Package['wget'],
    ]
  }
exec { 'openresty::package::download_pcre':
   cwd	  => '/tmp',
   command => "wget ${openresty::param::pcre_url} -O pcre.tar.gz ; tar zxf pcre.tar.gz",
   require => [
     Package['wget'],
   ]
 }


 exec { 'openresty::package::install_openresty':
    cwd     => '/tmp',
    command => "tar zxf openresty.tar.gz ; cd openresty* ; ./configure --prefix=/usr/local/openresty --with-pcre=/tmp/pcre-${openresty::param::pcre_version} --with-luajit --with-pcre-jit --with-http_ssl_module ; make && make install; rm -rf /tmp/pcre*; rm -rf /tmp/openresty*",
    require  => [
      Package['readline-devel'],
      Package['openssl-devel'],
      Package['gcc'],
      Package['gcc-c++'],
      Package['perl'],
      Exec['openresty::package::download_openresty'],
      Exec['openresty::package::download_pcre'],
    ],
  }
}

