FROM mwotton/meanpath-build

RUN apt-get update
ADD . /app
WORKDIR /app

ENV PATH /opt/ghc/7.8.2/bin:/opt/cabal/1.20/bin/:$PATH

RUN cabal update
RUN [ -d .cabal-sandbox ] || cabal sandbox init
RUN cabal install --only-dependencies
RUN cabal run Main
