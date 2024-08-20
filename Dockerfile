# SPDX-License-Identifier: MIT
# Define the tags for OBS and build script builds:
#!BuildTag: suse/alp/workloads/dev-ollama:latest
#!BuildTag: suse/alp/workloads/dev-ollama:%PKG_VERSION%.%TAG_OFFSET%
#!BuildTag: suse/alp/workloads/dev-ollama:%PKG_VERSION%.%TAG_OFFSET%.%RELEASE%


FROM opensuse/tumbleweed
# Mandatory labels for the build service:
#   https://en.opensuse.org/Building_derived_containers
# Define labels according to https://en.opensuse.org/Building_derived_containers
# labelprefix=com.suse.alp.workloads.dev-ollama
LABEL org.opencontainers.image.title="Dev Env base container"
LABEL org.opencontainers.image.description="Container for Dev Env"
LABEL org.opencontainers.image.created="%BUILDTIME%"
LABEL org.opencontainers.image.version="0.1"
LABEL org.openbuildservice.disturl="%DISTURL%"
LABEL org.opensuse.reference="registry.opensuse.org/suse/alp/workloads/tumbleweed_containerfiles/suse/alp/workloads/dev-ollama:0.1-%RELEASE%"
LABEL com.suse.supportlevel="techpreview"
LABEL com.suse.eula="beta"
LABEL com.suse.image-type="application"
LABEL com.suse.release-stage="alpha"
# endlabelprefix

# openssh-clients : for ansble ssh

RUN zypper --non-interactive --gpg-auto-import-keys addrepo 'https://download.opensuse.org/repositories/openSUSE:Tools/openSUSE_Tumbleweed/openSUSE:Tools.repo'
RUN zypper --non-interactive --no-gpg-checks --gpg-auto-import-keys addrepo http://download.opensuse.org/tumbleweed/repo/oss oss
RUN zypper -v -n --no-gpg-checks in ollama
RUN zypper clean --all

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

EXPOSE 11434
ENV OLLAMA_HOST 0.0.0.0
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENTRYPOINT ["/usr/bin/ollama"]
CMD ["serve"]


