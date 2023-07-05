#!/bin/bash

# sudo 권한을 얻습니다. 패스워드를 물어봅니다.
if sudo true; then
    echo "Auth Pass"
else 
    echo "Auth Fail"
fi
