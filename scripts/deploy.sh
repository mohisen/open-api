#!/bin/bash
set -e

BRANCH=${TRAVIS_BRANCH:-$(git rev-parse --abbrev-ref HEAD)} 

if [[ $BRANCH == 'master' ]]; then
  STAGE="prod"
  export AWS_ACCESS_KEY_ID=$AWS_ACCESS_ID_PROD
  export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY_PROD
  export MONGODB_URL=$MONGODB_URL_PROD
  export GRAPHQL_ENDPOINT_URL=$GRAPHQL_ENDPOINT_URL_PROD
elif [[ $BRANCH == 'staging' ]]; then
  STAGE="stage"
  export AWS_ACCESS_KEY_ID=$AWS_ACCESS_ID_STAGE
  export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY_STAGE
  export MONGODB_URL=$MONGODB_URL_STAGE
  export GRAPHQL_ENDPOINT_URL=$GRAPHQL_ENDPOINT_URL_STAGE
fi

if [ -z ${STAGE+x} ]; then
  echo "Only deploying for staging or production branches"
  exit 0
fi

if [[ $STAGE != 'stage' ]]; then
  echo "Only stage deployments for now, sorry!"
  exit 0
fi


echo "Deploying from branch $BRANCH to stage $STAGE"
npm prune --production  #remove devDependencies
sls deploy --stage $STAGE --region $AWS_REGION
