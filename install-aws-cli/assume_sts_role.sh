#!/bin/bash
# this is a script to help you assume STS roles
#
# This script will write the creds to /tmp/creds.json and then parse them into exported VARs in your shell
#
#  You have to have created a Role in AWS ahead of time, for my work its "DasmlabTfAdmin"
#
#  ASSUMES: you have already run "aws configure" and are setup on your machine creds wise

SESSION="dasmlab-ci-session"
ACCOUNT_ID="0913-0327-7114"
ROLE_NAME="DasmlabTfAdmin"

# Gettting JSON STS File
echo "Getting AWS STS info"
aws sts assume-role   --role-arn arn:aws:iam::091303277114:role/DasmlabTfAdmin   --role-session-name dasmlab-ci-session > /tmp/creds.json

echo "Assiging AWS Variabbles"
export AWS_ACCESS_KEY_ID=$(jq -r .Credentials.AccessKeyId /tmp/creds.json)
export AWS_SECRET_ACCESS_KEY=$(jq -r .Credentials.SecretAccessKey /tmp/creds.json)
export AWS_SESSION_TOKEN=$(jq -r .Credentials.SessionToken /tmp/creds.json)


echo "Printing new env vars for AWS"
env | grep AWS
	 

