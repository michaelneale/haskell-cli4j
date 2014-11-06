install:
	docker build -t cli .

shell: 
	docker run -v $(shell pwd)/src:/app/src -it cli /bin/bash 


