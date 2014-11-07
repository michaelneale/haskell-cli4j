image:
	docker build -t cli .

shell:  image
	docker run -v $(shell pwd):/app -it cli tmux 

# run this when brand new
cabal-init:
	cabal update
	[ -d .cabal-sandbox ] || cabal sandbox init 
	LANG=en_US.utf-8 cabal install --only-dependencies

