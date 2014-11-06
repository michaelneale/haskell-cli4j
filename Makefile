install:
	docker build -t cli .

shell: install 
	docker run -v $(shell pwd)/src:/app/src -it cli /bin/bash 


