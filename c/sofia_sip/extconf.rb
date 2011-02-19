require "mkmf"

extension_name = "sofia_sip"

dir_config(extension_name)

if have_library("sofia-sip-ua") then
  $CFLAGS+= " -D HAVE_SOFIA_SIP"
  $CPPFLAGS+= " -I/usr/include/sofia-sip-1.12"
end

create_makefile(extension_name)
