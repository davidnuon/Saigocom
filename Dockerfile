FROM alpine:edge

FROM alpine:edge

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" | tee -a /etc/apk/repositories

RUN apk update
RUN apk add alpine-sdk build-base apk-tools alpine-conf busybox fakeroot syslinux xorriso squashfs-tools sudo mtools dosfstools grub-efi

RUN adduser -h /home/build -D build -G abuild

RUN echo 'build ALL=(ALL) NOPASSWD: ALL' | tee -a /etc/sudoers

USER build

RUN SUDO=sudo abuild-keygen -i -a -n

RUN git clone --depth=1 https://gitlab.alpinelinux.org/alpine/aports.git /home/build/aports
RUN cd /home/build/aports && sudo apk update

RUN mkdir /home/build/wd
COPY ./mkimg.saigo.sh /home/build/aports/scripts/
COPY ./genapkovl-saigo.sh /home/build/aports/scripts/
COPY ./openbox.tar.gz /home/build/aports/scripts/
COPY ./search.py /home/build/aports/scripts/
COPY ./tint2.tar.gz /home/build/aports/scripts/

RUN sh ~/aports/scripts/mkimage.sh --tag v3.21 \
    --outdir ~/iso \
    --arch x86 \
    --workdir /home/build/wd \
    --repository http://dl-cdn.alpinelinux.org/alpine/v3.21/main \
    --repository http://dl-cdn.alpinelinux.org/alpine/v3.21/community \
    --profile saigo