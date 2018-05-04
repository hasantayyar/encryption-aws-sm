set -e

if [ "$#" -ne 4 ]; then
    echo
    echo "Usage :"
    echo "sh decrypt.sh <KEYALIAS> <IV> <INPUT> <OUTPUT>"
    echo
    echo "- KEYALIAS:   Key alias name in AWS Secrets Manager"
    echo "- IV:         You should have the IV from the encryption process."
    echo "- INPUT:      Input file path, encrypted file."
    echo "- OUTPUT:     Output file path, decrypted file"
    echo
    echo "Important: Key will be fetched from AWS. Check your key alias again."
    echo
    exit -1
fi
KEYALIAS=$1
IV=$2
INFILE=$3
OUTFILE=$4

echo "KEY ALIAS: $KEYALIAS"
echo "IV: $IV"
echo "In: $INFILE"
echo "Out: $OUTFILE"

echo "Getting encryption key from AWS"
ENC_KEY=$(aws secretsmanager get-secret-value --secret-id $KEYALIAS --output json|jq -r '.SecretString')
echo "Got the encryption key"

echo "Decrypting..."
openssl enc -d -aes-256-cbc -in $INFILE -out $OUTFILE -k "$ENC_KEY" -iv "$IV"
echo "Done"
