FROM centos:7

RUN yum install -y gcc gcc-c++ \
                   libtool libtool-ltdl \
                   make cmake \
                   git \
                   pkgconfig \
                   sudo \
                   automake autoconf \
                   yum-utils rpm-build \
                   createrepo \
                   rpmdevtools \
                   epel-release && \ 
    yum clean all

COPY pkg /srv/pkg

RUN useradd builder -u 1000 -m -G users,wheel && \
    echo "builder ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    echo "# macros"                      >  /home/builder/.rpmmacros && \
    echo "%_topdir    /home/builder/rpm" >> /home/builder/.rpmmacros && \
    echo "%_sourcedir %{_topdir}"        >> /home/builder/.rpmmacros && \
    echo "%_builddir  %{_topdir}"        >> /home/builder/.rpmmacros && \
    echo "%_specdir   %{_topdir}"        >> /home/builder/.rpmmacros && \
    echo "%_rpmdir    %{_topdir}/RPMS"        >> /home/builder/.rpmmacros && \
    echo "%_srcrpmdir %{_topdir}/SRPMS"        >> /home/builder/.rpmmacros && \
    echo "%dist .el7.uuz" >> /home/builder/.rpmmacros && \
    echo "%vendor uuz" /home/builder/.rpmmacros && \
    mkdir /home/builder/rpm && \
    chown -R builder /home/builder
USER builder

ENV FLAVOR=rpmbuild OS=centos DIST=el7

CMD /srv/pkg
