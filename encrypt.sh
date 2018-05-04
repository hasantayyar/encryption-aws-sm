set -e

if [ "$#" -ne 3 ]; then
    echo
    echo "Usage :"
    echo "sh encrypt.sh <KEYALIAS> <INPUT> <OUTPUT>"
    echo
    echo "- KEYALIAS:   Key alias name in AWS Secrets Manager."
    echo "- INPUT:      Input file path, file to be decrypted"
    echo "- OUTPUT:     Output file path, encrypted file"
    echo
    echo "Important: Key will be fetched from AWS. Check your key alias again."
    echo
    exit -1
fi


echo "Creating random IV"
RAND_IV=$(aws secretsmanager get-random-password --password-length 32 --exclude-punctuation --exclude-uppercase --exclude-lowercase --output text)
echo "========================================="
echo "GOT IV : $RAND_IV"
echo "========================================="

echo "Please not the IV value the encrypted file. It will be always different for every encryption!!"
echo 
echo

KEYALIAS=$1
INFILE=$2
OUTFILE=$3
echo "In: $INFILE"
echo "Out: $OUTFILE"

echo "Getting encryption key from AWS"
ENC_KEY=$(aws secretsmanager get-secret-value --secret-id $KEYALIAS  --output json|jq -r '.SecretString')
echo "Got the encryption key"

echo "Encrypting..."
openssl enc  -aes-256-cbc -in $INFILE -out $OUTFILE -k "$ENC_KEY" -iv "$RAND_IV"
echo "Done"
