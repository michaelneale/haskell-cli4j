FROM mwotton/meanpath-build

RUN apt-get update
#ADD *.cabal /app/
RUN apt-get install -y tmux make

WORKDIR /app

ENV PATH /opt/ghc/7.8.2/bin:/opt/cabal/1.20/bin/:$PATH
#RUN cabal update && [ -d .cabal-sandbox ] || cabal sandbox init && LANG=en_US.utf-8 cabal install --only-dependencies
