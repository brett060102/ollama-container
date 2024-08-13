#! /bin/bash
PATH=/usr/bin:/bin

KEEP_USERID=""
if [[ $(id -ru) != "0" ]]; then
    KEEP_USERID="--userns=keep-id"
fi

# make symlinks for mount points
# this needed to hand colons in file path names
LINK_DIR=`mktemp -d -p /tmp`
ln -s $(pwd)  ${LINK_DIR}/work
ln -s ${HOME} ${LINK_DIR}/home


# process arguments to support command wrapping
# but we also want, dev-ollama to drop intal bash in container
cmd_args=()
if [[ "$(basename "${0}")" != "dev-ollama" ]]; then
    cmd_args+=("$(basename "${0}")")
fi

cmd_args+=("$@")

# Launch container
podman run  --security-opt label=disable -it -v ${LINK_DIR}/work:/work -v ${LINK_DIR}/home:${HOME} ${KEEP_USERID} --rm dev-ollama "${cmd_args[@]}"

# clean up symlink area
rm ${LINK_DIR}/work ${LINK_DIR}/home
rmdir ${LINK_DIR}
