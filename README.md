# Encryption tools using AWS Secrets Manager

These tools will fetch encryption key from AWS Secret Manager and execute a local encryption on a file using the fetched key.

During encryption the script will generate IV with the help of AWS to guarantee the randomness. 

Pre-reqs : 

- openssl
- jq
- awscli
