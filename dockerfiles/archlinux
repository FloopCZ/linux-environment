ARG tag="latest"
FROM iterait/archlinux-dev:${tag}
MAINTAINER Filip Matzner <docker@floop.cz>

# set up users and passwords
RUN useradd -m -s /usr/bin/zsh somebody \
  && echo 'somebody ALL=(ALL) ALL' > /etc/sudoers.d/somebody \
  && echo 'Defaults env_keep += "EDITOR"' >> /etc/sudoers.d/somebody \
  && echo "somebody:bluntMoreWater" | chpasswd \
  && echo "root:crudePlayfulSpoon" | chpasswd

# install linux environment for root
RUN cd /root \
  && git clone https://github.com/FloopCZ/linux-environment.git \
  && cd linux-environment \
  && ./deploy.sh --install

# install linux environment for unprivileged user
RUN cp -r /root/linux-environment /home/somebody/ \
  && chown -R somebody:somebody /home/somebody/linux-environment
USER somebody
RUN cd /home/somebody/linux-environment && ./deploy.sh
USER root

# install basic python packages
RUN pacman --noconfirm --needed -Syu \
  ipython \
  jupyter-notebook \
  python-ipywidgets \
  python-pip

# install jupyter nbextensions
RUN pip install --upgrade --no-cache-dir jupyter_contrib_nbextensions \
  && jupyter contrib nbextension install --system \
  && pip install --upgrade --no-cache-dir jupyter_nbextensions_configurator \
  && jupyter nbextensions_configurator enable --system

# install and configure ssh server
RUN pacman --noconfirm --needed -Syu openssh
RUN ssh-keygen -A && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# start ssh server
ENTRYPOINT ["/usr/bin/sshd", "-D"]
