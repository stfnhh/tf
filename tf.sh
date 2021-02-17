#!/usr/bin/env bash

main() {
    local role_arn=$(aws --profile "$AWS_PROFILE" configure get role_arn)
    if [[ $? != 0  || $role_arn == "" ]]; then
        exec terraform "$@"
        exit 0
    fi

    credentials=($(
        aws sts assume-role  \
        --role-arn="${role_arn}" \
        --role-session-name="terraform-access" \
        --profile="$AWS_PROFILE" \
        --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
        --output text \
        | tr " " "\n"
    ))
    
    unset AWS_PROFILE

    export AWS_ACCESS_KEY_ID=${credentials[0]}
    export AWS_SECRET_ACCESS_KEY=${credentials[1]}
    export AWS_SESSION_TOKEN=${credentials[2]}

    exec terraform "$@"
}

main "$@"