# Check if the correct number of arguments are passed
if [ "$#" -ne 3 ]; then
    echo "retrieveTwistlockScanner : Usage: $0 <TWIST_URL> <TWIST_USERNAME> <TWIST_PASSWORD>"
    exit 1
fi

TWIST_URL=$1
TWIST_USERNAME=$2
TWIST_PASSWORD=$3

echo "retrieveTwistlockScanner : FETCHING twistcli FROM PRISMA CLOUD and REFRESING INTO S3"
# Step-1 Get token and store in TOKEN variable
TOKEN=$(curl -k \
  -H "Content-Type: application/json" \
  -X POST \
  -d \
'{
  "username":"'"${TWIST_USERNAME}"'",
  "password":"'"${TWIST_PASSWORD}"'"
}' \
"${TWIST_URL}"/authenticate | jq -r '.token')

echo $TOKEN

# Check if token retrieval was successful
if [ -z "$TOKEN" ]; then
	echo "retrieveTwistlockScanner : Failed to retrieve token!"
	exit 2
fi

# Step-2 Using token variable download twistcli
curl -L -k --header "authorization: Bearer $TOKEN" "${TWIST_URL}"/util/twistcli > twistcli

# Check if twistcli download was successful
if [ ! -f "twistcli" ]; then
	echo "retrieveTwistlockScanner : Failed to download twistcli!"
	exit 3
fi


echo "retrieveTwistlockScanner : Script completed successfully!"
