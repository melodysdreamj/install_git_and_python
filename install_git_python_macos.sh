#!/bin/bash

# Homebrew 설치 확인 및 설치
if ! command -v brew &> /dev/null
then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

# Git 설치 확인 및 설치
if ! command -v git &> /dev/null
then
    echo "Git not found. Installing..."
    brew install git
else
    echo "Git is already installed."
fi

# Python 3.10.x 설치 확인 및 설치
installed_python_version=$(python3 --version 2>&1 | cut -d' ' -f2 | cut -d'.' -f1,2)
required_python_version="3.10"
if [ "$installed_python_version" != "$required_python_version" ]
then
    echo "Required Python version not found. Installing..."
    brew install python@3.10
    if [[ $SHELL == *"zsh"* ]]; then
        echo 'export PATH="/usr/local/opt/python@3.10/bin:$PATH"' >> ~/.zshrc
        source ~/.zshrc
    elif [[ $SHELL == *"bash"* ]]; then
        echo 'export PATH="/usr/local/opt/python@3.10/bin:$PATH"' >> ~/.bashrc
        source ~/.bashrc
    else
        echo "Shell not supported for PATH modification. Please manually add '/usr/local/opt/python@3.10/bin' to your PATH."
    fi
else
    echo "Required Python version is already installed."
fi
