user { 'sachin':
  ensure => present,
  home => '/home/sachin',
  shell => '/bin/bash',
  uid => '1010',
  password => '$1$jzi/Xjfd$Fpj3P16NBzfiiQGlDj9rG0'
}
