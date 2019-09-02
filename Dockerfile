FROM johnjq/lojban-tool-dependencies:latest

####################### Configure the project #######################

# Copy project configuration files
COPY stack.yaml /lojto/stack.yaml
COPY lojto.cabal /lojto/lojto.cabal

# Copy source code
COPY courses /lojto/courses
COPY app /lojto/app
COPY src /lojto/src
COPY LICENSE /lojto/LICENSE

# Copy resources
COPY resources /lojto/resources

# Compile source code and documentation
RUN cd /lojto && stack haddock --no-haddock-deps --haddock-internal

# Move documentation
RUN mv /lojto/.stack-work/install/x86_64-linux-nix/*/*/doc /lojto/doc

# Copy additional resources
COPY static /lojto/static

# Compile stylesheet files
COPY buildscripts /lojto/buildscripts
RUN cd /lojto && LOJBAN_TOOL_BYPASS_NIX=true ./buildscripts/compile-less.sh

####################### Expose ports #######################
EXPOSE 8000/tcp

####################### Default command #######################
CMD echo "hosts: files dns" > /etc/nsswitch.conf && cd /lojto && .stack-work/install/x86_64-linux-nix/*/*/bin/server
