#!/bin/bash

eval $(cat config.txt)
unset PYTHONPATH

TemplateBucket=jmfveneroso

array=(
deployment-pipeline.yaml
ecs-cluster.yaml
load-balancer.yaml
service.yaml
vpc.yaml
)

for f in "${array[@]}"; do
  aws s3api put-object --bucket jmfveneroso --key templates/$f --body templates/$f
done

aws cloudformation create-stack --stack-name website --template-body file://templates/main.yaml \
  --capabilities CAPABILITY_IAM --disable-rollback --parameters \
  ParameterKey=GitHubUser,ParameterValue=$GITHUB_USER \
  ParameterKey=GitHubToken,ParameterValue=$GITHUB_KEY
