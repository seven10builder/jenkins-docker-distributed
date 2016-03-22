#!/bin/bash

if [ "$#" -ne 2 ]; then
     echo "Usage: ./start-docker-cloud-slave.sh <stack uuid> <api-key>"
     exit 1
fi
if [ -z "$1" ]; then
     echo "Must supply a stack uuid"
     exit 1
else
     UUID="$1"
     echo "Using stack id '$UUID'"
fi
if [ -z "$2" ]; then
     echo "Must supply an API key to cloud.docker.com"
     exit 1
else
     API_KEY="$2"
     echo "Using API key '$API_KEY'"
fi


CREATE_RESULT=$(curl -u seven10builder:$API_KEY --write-out %{http_code} --silent --output /dev/nul \
				-H "Accept: application/json" \
				-X POST https://cloud.docker.com/api/app/v1/stack/$UUID/redeploy/?reuse_volumes=false)
case "$CREATE_RESULT" in
	400)
 	 	RVAL=1
        echo "Bad Request – There’s a problem in the content of your request. Retrying the same request will fail.";;
	401)
 		RVAL=1
        echo "Unauthorized – Your API key is wrong or your account has been deactivated.";;
	404) 
		RVAL=1
        echo "Not Found – The requested object cannot be found.";;
	405)
 		RVAL=1
        echo "Method Not Allowed – The endpoint requested does not implement the method sent.";;
	409) 
		RVAL=1
        echo "Conflict – The object cannot be created or updated because another object exists with the same unique fields";;
	415) 
		RVAL=1
        echo "Unsupported Media Type – Make sure you are using Accept and Content-Type headers as application/json and that the data your are POST-ing or PATCH-ing is in valid JSON format.";;
	429) 
		RVAL=1
        echo "Too Many Requests – You are being throttled because of too many requests in a short period of time.";;
	500)
 		RVAL=1
        echo "Internal Server Error – There was a server error while processing your request. Try again later, or contact support.";;
	503)
 		RVAL=1
        echo "Service Unavailable – We’re temporarially offline for maintanance. Please try again later.";;
	504)
		RVAL=1
        echo "Gateway Timeout – Our API servers are at full capacity. Please try again later.";;
    202)
		RVAL=0
		echo "API Call successful";;
	*)
    	RVAL=1
        echo "Unknown error '$CREATE_RESULT', cannot create container";;
esac
exit $RVAL