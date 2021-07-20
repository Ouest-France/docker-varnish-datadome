FROM rockylinux/rockylinux:8 as builder
WORKDIR /tmp
COPY ./asset/varnish.repo /etc/yum.repos.d/varnish.repo
RUN dnf module disable varnish -y && dnf install epel-release -y && dnf install varnish varnish-devel libtool automake libtool varnish-devel python3 make python3-docutils -y && dnf clean all
RUN curl -L https://package.datadome.co/linux/DataDome-Varnish-latest.tgz -o ./DataDome-Varnish-latest.tgz &&tar -zxvf DataDome-Varnish-latest.tgz && cd DataDome-VarnishDome-* && \
./autogen.sh && ./configure && make && make install && cp datadome.vcl /etc/varnish/datadome.vcl
FROM rockylinux/rockylinux:8
COPY ./asset/varnish.repo /etc/yum.repos.d/varnish.repo
RUN dnf module disable varnish -y && dnf install epel-release -y && dnf install varnish -y && dnf clean all
COPY --from=builder /usr/lib64/varnish/vmods/libvmod_data_dome_shield.so /usr/lib64/varnish/vmods/libvmod_data_dome_shield.so
COPY --from=builder /usr/lib64/varnish/vmods/libvmod_data_dome_shield.la /usr/lib64/varnish/vmods/libvmod_data_dome_shield.la
COPY --from=builder /etc/varnish/datadome.vcl /etc/varnish/datadome.vcl
COPY ./asset/default.vcl /etc/varnish/default.vcl
RUN varnishd -C -f /etc/varnish/default.vcl
