FROM mydatakeeper/archlinux

# Add aarch64 rootfs
ADD ArchLinuxARM-aarch64-latest.tar.gz /usr/aarch64-linux-gnu
COPY qemu-aarch64-static /usr/aarch64-linux-gnu/usr/bin/qemu-aarch64-static

# Add aarch64 cross-pacman tools
COPY aarch64-pacman /usr/bin/aarch64-pacman
COPY aarch64-pacman-conf /usr/bin/aarch64-pacman-conf
COPY aarch64-pacman-db-upgrade /usr/bin/aarch64-pacman-db-upgrade
COPY aarch64-pacman-key /usr/bin/aarch64-pacman-key
COPY aarch64-pacman.conf /etc/aarch64-pacman.conf

# Update aarch64 archlinux image
RUN set -xe \
    && sed \
        -e "s|^\tlocal KEYRING_IMPORT_DIR='/usr/share/pacman/keyrings'$|\tlocal KEYRING_IMPORT_DIR=\"\$(pacman-conf --config=\"\$CONFIG\" rootdir)\"'/usr/share/pacman/keyrings'|" \
        -i /usr/bin/pacman-key \
    && aarch64-pacman-key --init \
    && aarch64-pacman-key --populate archlinuxarm \
    && aarch64-pacman --noconfirm -Syu --needed \
    && aarch64-pacman-db-upgrade \
    && aarch64-pacman -Scc --noconfirm
