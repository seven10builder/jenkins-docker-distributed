# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM seven10/emc-libs
MAINTAINER kmilner "kmilner@seven10storage.com"

ENV MAVEN_VERSION 3.3.3

# Make sure the package repository is up to date.
RUN apt-get update
RUN apt-get -y upgrade

# Install a basic SSH server
RUN apt-get install -y openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd && \
# generate a default locale to keep certain warnings at bay
   locale-gen en_US.UTF-8 && \
#  Add user jenkins to the image. Note: the password is encrypted via
#  password="some-good-passwd"; perl -e 'printf("%s\n", crypt($ARGV[0], "password"))' "$password"
   useradd -m -p "paZMSFlwB0Lw6" jenkins

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
