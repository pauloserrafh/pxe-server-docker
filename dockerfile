FROM debian:bullseye

RUN apt update -qy && apt upgrade -qy \
    && apt install -qy dnsmasq pxelinux \
    syslinux-efi nfs-kernel-server \
    nano vim iproute2

RUN mkdir -p /var/lib/tftpboot/bios \
    && cp \
    /usr/lib/syslinux/modules/bios/ldlinux.c32 \
    /usr/lib/syslinux/modules/bios/vesamenu.c32 \
    /usr/lib/syslinux/modules/bios/libutil.c32 \
    /usr/lib/PXELINUX/pxelinux.0 \
    /var/lib/tftpboot/bios

RUN mkdir -p /var/lib/tftpboot/efi64 \
    && cp \
    /usr/lib/syslinux/modules/efi64/ldlinux.e64 \
    /usr/lib/syslinux/modules/efi64/vesamenu.c32 \
    /usr/lib/syslinux/modules/efi64/libcom32.c32 \
    /usr/lib/syslinux/modules/efi64/libutil.c32 \
    /usr/lib/SYSLINUX.EFI/efi64/syslinux.efi \
    /var/lib/tftpboot/efi64

COPY tftpboot/ /var/lib/tftpboot

RUN ln -rs /var/lib/tftpboot/pxelinux.cfg /var/lib/tftpboot/bios \
    && ln -rs /var/lib/tftpboot/pxelinux.cfg /var/lib/tftpboot/efi64

COPY etc/ /etc
