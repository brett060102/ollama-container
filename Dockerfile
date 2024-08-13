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

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN mkdir /container
COPY entrypoint.sh /container/entrypoint.sh
RUN chmod +x /container/entrypoint.sh
COPY dev-ollama-wrapper.sh /container/dev-ollama-wrapper.sh
RUN chmod +x /container/dev-ollama-wrapper.sh
COPY label-install /container
COPY label-uninstall /container


WORKDIR /work

LABEL INSTALL="/usr/bin/podman run --env IMAGE=IMAGE --rm --security-opt label=disable -v \${PWD}/:/host IMAGE /bin/bash /container/label-install"
LABEL UNINSTALL="/usr/bin/podman run --rm --security-opt label=disable -v \${PWD}/:/host IMAGE /bin/bash /container/label-uninstall"

ENTRYPOINT [ "/container/entrypoint.sh" ]
CMD ["/bin/bash"]

RUN zypper --non-interactive --gpg-auto-import-keys addrepo 'https://download.opensuse.org/repositories/openSUSE:Tools/openSUSE_Tumbleweed/openSUSE:Tools.repo'; zypper --non-interactive --gpg-auto-import-keys refresh; zypper -v -n in gcc libffi-devel python3 python3-pip wget sshpass openssh-clients git emacs emacs-nox scout-command-not-found vim tar bash-completion sudo osc obs-service-extract_file obs-service-tar_scm obs-service-verify_file  obs-service-source_validator obs-service-set_version  obs-service-recompress obs-service-obs_scm-common obs-service-obs_scm obs-service-format_spec_file obs-service-extract_file obs-service-download_files obs-service-renderspec rpm-build ollama; zypper clean --all


