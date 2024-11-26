ARG VARIANT=22
FROM node:${VARIANT}

ARG USERNAME=node
ARG NPM_GLOBAL=/usr/local/share/npm-global

USER root
RUN useradd -m vscode

# Add NPM global to PATH.
ENV PATH=${NPM_GLOBAL}/bin:${PATH}

RUN \
    # Configure global npm install location, use group to adapt to UID/GID changes
    if ! cat /etc/group | grep -e "^npm:" > /dev/null 2>&1; then groupadd -r npm; fi \
    && usermod -a -G npm ${USERNAME} \
    && umask 0002 \
    && mkdir -p ${NPM_GLOBAL} \
    && touch /usr/local/etc/npmrc \
    && chown ${USERNAME}:npm ${NPM_GLOBAL} /usr/local/etc/npmrc \
    && chmod g+s ${NPM_GLOBAL} \
    && npm config -g set prefix ${NPM_GLOBAL} \
    && su ${USERNAME} -c "npm config -g set prefix ${NPM_GLOBAL}" \
    # Install eslint
    && su ${USERNAME} -c "umask 0002 && npm install -g eslint" \
    && npm cache clean --force > /dev/null 2>&1

# Install extra apps.
# RUN apt-get update && apt-get install -y git && apt-get clean

# Install grunt globally.
RUN npm -g install grunt-cli

# Set up quality of life improvements. Add to all users.
RUN echo "alias ll='ls -la'" >> /etc/bash.bashrc

RUN mkdir -p /workspace && chown -R vscode:vscode /workspace
COPY . /workspace
RUN chown -R vscode:vscode /workspace

USER vscode

CMD ["bash", "-c", "cd /workspace && exec /bin/bash"]

