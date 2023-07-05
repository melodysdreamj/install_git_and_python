#!/bin/bash

# Check if the script is running as root
if [ "$EUID" -eq 0 ]
then
    echo "Do not run this script as root."
    exit
fi

# Homebrew installation check and installation
if ! command -v brew &> /dev/null
then
    read -p "Homebrew not found. Do you wish to install it? (y/n)" -n 1 -r
    echo    # Move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || { echo "Homebrew installation failed"; exit 1; }
        if [[ $SHELL == *"zsh"* ]]; then
            echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
            source ~/.zshrc
        elif [[ $SHELL == *"bash"* ]]; then
            echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
            source ~/.bashrc
        else
            echo "Shell not supported for PATH modification. Please manually add '/usr/local/bin' to your PATH."
        fi
    fi
else
    echo "Homebrew is already installed."
fi

# Git installation check and installation
if ! command -v git &> /dev/null
then
    read -p "Git not found. Do you wish to install it? (y/n)" -n 1 -r
    echo    # Move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installing Git..."
        brew install git || { echo "Git installation failed"; exit 1; }
    fi
else
    echo "Git is already installed."
fi

# Python 3.10.x installation check and installation
installed_python_version=$(python3 --version 2>&1 | cut -d' ' -f2 | cut -d'.' -f1,2)
required_python_version="3.10"
if [ "$installed_python_version" != "$required_python_version" ]
then
    read -p "Required Python version not found. Do you wish to install it? (y/n)" -n 1 -r
    echo    # Move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installing Python 3.10..."
        brew install python@3.10 || { echo "Python installation failed"; exit 1; }
        if [[ $SHELL == *"zsh"* ]]; then
            if ! grep -q 'export PATH="/usr/local/opt/python@3.10/bin:$PATH"' ~/.zshrc
            then
                echo 'export PATH="/usr/local/opt/python@3.10/bin:$PATH"' >> ~/.zshrc
            fi
            source ~/.zshrc
        elif [[ $SHELL == *"bash"* ]]; then
            if ! grep -q 'export PATH="/usr/local/opt/python@3.10/bin:$PATH"' ~/.bashrc
            then
                echo 'export PATH="/usr/local/opt/python@3.10/bin:$PATH"' >> ~/.bashrc
            fi
            source ~/.bashrc
        else
            echo "Shell not supported for PATH modification. Please manually add '/usr/local/opt/python@3.10/bin' to your PATH."
        fi
    fi
else
    echo "Required Python version is already installed."
fi

echo "Script execution completed. Please check any error messages above."
