STACK_NAME=basicAuthLambda2
NAME_SUFFIX="2"

create-stack:
	aws cloudformation create-stack --stack-name $(STACK_NAME) \
	        --template-body file://lambda.yml \
	        --parameters ParameterKey=NameSuffix,ParameterValue=$(NAME_SUFFIX) \
	        --region us-east-1 \
	        --capabilities CAPABILITY_NAMED_IAM

update-stack:
	aws cloudformation update-stack --stack-name $(STACK_NAME) \
	        --template-body file://lambda.yml \
	        --parameters ParameterKey=NameSuffix,ParameterValue=$(NAME_SUFFIX) \
	        --region us-east-1 \
	        --capabilities CAPABILITY_NAMED_IAM

delete-stack:
	aws cloudformation delete-stack --stack-name $(STACK_NAME) \
	        --region us-east-1