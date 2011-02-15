Name: rbox
Summary: R-Box FastDataTel Archiviatore
Version: 1.0
Release: 2.fc12
Source0: %{name}-%{version}.tar.gz
License: Licensed only for approved usage, see COPYING for details.
Group: Productivity/Telephony
Vendor: FastDataTel s.r.l.

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch: noarch

BuildRequires: python => 2.6
Requires: Django
Requires: mod_python
Requires: python-lxml
Requires: python-twisted
Requires: python-twisted-core
Requires: python-twisted-web
Requires: postgresql
Requires: postgresql-server
Requires: python-psycopg2

%description
FastDataTel Archiviatore

%package devel
Summary: Source Code R-Box FastDataTel Archiviatore
License: Licensed only for approved usage, see COPYING for details.
Group: Development/Libraries
Vendor: FastDataTel s.r.l.

BuildRequires: python => 2.6
Requires: Django
Requires: mod_python
Requires: python-lxml
Requires: python-twisted
Requires: python-twisted-core
Requires: python-twisted-web
Requires: postgresql
Requires: postgresql-server
Requires: python-psycopg2

%description devel
Sorgenti Python del FastDataTel Archiviatore

%prep
%setup -q

%build

%install
rm -rf $RPM_BUILD_ROOT

mkdir -p $RPM_BUILD_ROOT/var/www/html/rbox
mkdir -p $RPM_BUILD_ROOT/usr/local/fdt-arch
mkdir -p $RPM_BUILD_ROOT/usr/local/fdt-arch/rbox2
mkdir -p $RPM_BUILD_ROOT/usr/local/fdt-arch/web
mkdir -p $RPM_BUILD_ROOT/usr/local/fdt-arch/web/rbox
mkdir -p $RPM_BUILD_ROOT/usr/local/fdt-arch/web/rbox/fixtures
mkdir -p $RPM_BUILD_ROOT/usr/local/fdt-arch/web/rbox/forms
mkdir -p $RPM_BUILD_ROOT/usr/local/fdt-arch/web/rbox/libs
mkdir -p $RPM_BUILD_ROOT/usr/local/fdt-arch/web/rbox/models
mkdir -p $RPM_BUILD_ROOT/usr/local/fdt-arch/web/rbox/views
mkdir -p $RPM_BUILD_ROOT/usr/local/fdt-arch/web/media
mkdir -p $RPM_BUILD_ROOT/usr/local/fdt-arch/web/media/css
mkdir -p $RPM_BUILD_ROOT/usr/local/fdt-arch/web/media/css/ui-lightness
mkdir -p $RPM_BUILD_ROOT/usr/local/fdt-arch/web/media/css/ui-lightness/images
mkdir -p $RPM_BUILD_ROOT/usr/local/fdt-arch/web/media/images
mkdir -p $RPM_BUILD_ROOT/usr/local/fdt-arch/web/media/js
mkdir -p $RPM_BUILD_ROOT/usr/local/fdt-arch/web/media/swf
mkdir -p $RPM_BUILD_ROOT/usr/local/fdt-arch/web/templates

install -p -m 644 -D httpd-rbox.conf $RPM_BUILD_ROOT/etc/httpd/conf.d/httpd-rbox.conf
install -p -m 644 -D cron-rbox $RPM_BUILD_ROOT/etc/cron.d/cron-rbox
install -p -m 644 -D web.log $RPM_BUILD_ROOT/var/log/web.log
install -p -m 644 -D rbox.sql $RPM_BUILD_ROOT/var/www/html/rbox/rbox.sql

for i in rbox2/*py ; do
    install -p -m 644 -D $i $RPM_BUILD_ROOT/usr/local/fdt-arch/rbox2
done

for i in web/*py ; do
    install -p -m 644 -D $i $RPM_BUILD_ROOT/usr/local/fdt-arch/web
done

for i in web/rbox/*py ; do
    install -p -m 644 -D $i $RPM_BUILD_ROOT/usr/local/fdt-arch/web/rbox
done

for i in web/rbox/fixtures/*json ; do
    install -p -m 644 -D $i $RPM_BUILD_ROOT/usr/local/fdt-arch/web/rbox/fixtures
done

for i in web/rbox/forms/*py ; do
    install -p -m 644 -D $i $RPM_BUILD_ROOT/usr/local/fdt-arch/web/rbox/forms
done

for i in web/rbox/libs/*py ; do
    install -p -m 644 -D $i $RPM_BUILD_ROOT/usr/local/fdt-arch/web/rbox/libs
done

for i in web/rbox/models/*py ; do
    install -p -m 644 -D $i $RPM_BUILD_ROOT/usr/local/fdt-arch/web/rbox/models
done

for i in web/rbox/views/*py ; do
    install -p -m 644 -D $i $RPM_BUILD_ROOT/usr/local/fdt-arch/web/rbox/views
done

for i in web/templates/*html ; do
    install -p -m 644 -D $i $RPM_BUILD_ROOT/usr/local/fdt-arch/web/templates
done

for i in web/media/css/*css ; do
    install -p -m 644 -D $i $RPM_BUILD_ROOT/usr/local/fdt-arch/web/media/css
done

for i in web/media/css/ui-lightness/*css ; do
    install -p -m 644 -D $i $RPM_BUILD_ROOT/usr/local/fdt-arch/web/media/css/ui-lightness
done

for i in web/media/css/ui-lightness/images/* ; do
    install -p -m 644 -D $i $RPM_BUILD_ROOT/usr/local/fdt-arch/web/media/css/ui-lightness/images
done

for i in web/media/images/* ; do
    install -p -m 644 -D $i $RPM_BUILD_ROOT/usr/local/fdt-arch/web/media/images
done

for i in web/media/js/*js ; do
    install -p -m 644 -D $i $RPM_BUILD_ROOT/usr/local/fdt-arch/web/media/js
done

for i in web/media/swf/*swf ; do
    install -p -m 644 -D $i $RPM_BUILD_ROOT/usr/local/fdt-arch/web/media/swf
done

%clean
rm -rf $RPM_BUILD_ROOT

%post
ln -s /usr/local/fdt-arch/rbox2 /usr/lib/python2.6/site-packages/rbox2
ln -s /usr/lib/python2.6/site-packages/django/contrib/admin/media /var/www/html/rbox/media
ln -s /usr/local/fdt-arch/web/media /var/www/html/rbox/site_media
chown postgres:postgres /var/lib/pgsql/data
su - postgres -c "initdb"
service postgresql restart
service crond restart
service httpd restart
sleep 5
createdb -U postgres rbox
psql -U postgres rbox < /var/www/html/rbox/rbox.sql
python /usr/local/fdt-arch/web/manage.pyc loaddata foldtype.json
python /usr/local/fdt-arch/web/manage.pyc loaddata settings.json

%files
%dir %attr(755,apache,apache) /usr/local/fdt-arch
%dir %attr(755,apache,apache) /usr/local/fdt-arch/rbox2
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/rbox
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/rbox/fixtures
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/rbox/forms
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/rbox/libs
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/rbox/models
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/rbox/views
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/media
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/media/css
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/media/css/ui-lightness
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/media/css/ui-lightness/images
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/media/images
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/media/js
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/media/swf
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/templates

%defattr(644,root,root,755)
/etc/httpd/conf.d/httpd-rbox.conf
/etc/cron.d/cron-rbox

%defattr(644,apache,apache,755)
/var/log/web.log
/var/www/html/rbox/rbox.sql
/usr/local/fdt-arch/rbox2/*pyo
/usr/local/fdt-arch/rbox2/*pyc
/usr/local/fdt-arch/web/*pyo
/usr/local/fdt-arch/web/*pyc
/usr/local/fdt-arch/web/rbox/*pyo
/usr/local/fdt-arch/web/rbox/*pyc
/usr/local/fdt-arch/web/rbox/fixtures/*json
/usr/local/fdt-arch/web/rbox/forms/*pyo
/usr/local/fdt-arch/web/rbox/forms/*pyc
/usr/local/fdt-arch/web/rbox/libs/*pyo
/usr/local/fdt-arch/web/rbox/libs/*pyc
/usr/local/fdt-arch/web/rbox/models/*pyo
/usr/local/fdt-arch/web/rbox/models/*pyc
/usr/local/fdt-arch/web/rbox/views/*pyo
/usr/local/fdt-arch/web/rbox/views/*pyc
/usr/local/fdt-arch/web/media/css/*css
/usr/local/fdt-arch/web/media/css/ui-lightness/*css
/usr/local/fdt-arch/web/media/css/ui-lightness/images/*
/usr/local/fdt-arch/web/media/images/*
/usr/local/fdt-arch/web/media/js/*js
/usr/local/fdt-arch/web/media/swf/*swf
/usr/local/fdt-arch/web/templates/*html

%files devel
%dir %attr(755,apache,apache) /usr/local/fdt-arch
%dir %attr(755,apache,apache) /usr/local/fdt-arch/rbox2
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/rbox
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/rbox/fixtures
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/rbox/forms
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/rbox/libs
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/rbox/models
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/rbox/views
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/media
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/media/css
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/media/css/ui-lightness
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/media/css/ui-lightness/images
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/media/images
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/media/js
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/media/swf
%dir %attr(755,apache,apache) /usr/local/fdt-arch/web/templates

%defattr(644,apache,apache,755)
/var/log/web.log
/usr/local/fdt-arch/rbox2/*py
/usr/local/fdt-arch/web/*py
/usr/local/fdt-arch/web/rbox/*py
/usr/local/fdt-arch/web/rbox/fixtures/*json
/usr/local/fdt-arch/web/rbox/forms/*py
/usr/local/fdt-arch/web/rbox/libs/*py
/usr/local/fdt-arch/web/rbox/models/*py
/usr/local/fdt-arch/web/rbox/views/*py
/usr/local/fdt-arch/web/media/css/*css
/usr/local/fdt-arch/web/media/css/ui-lightness/*css
/usr/local/fdt-arch/web/media/css/ui-lightness/images/*
/usr/local/fdt-arch/web/media/images/*
/usr/local/fdt-arch/web/media/js/*js
/usr/local/fdt-arch/web/media/swf/*swf
/usr/local/fdt-arch/web/templates/*html
