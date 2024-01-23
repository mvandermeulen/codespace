# Ubuntu Setup Guide

## Why??

  Although we have dockers and everything to make our developing work easier and faster, Nothing beats having eveything setup in your own local environment

  **Note:-** This setup is just my own preference.
  
## Solve audio problems with latest linux kernels

    echo 'options snd-intel-dspcfg dsp_driver=1' | sudo tee -a /etc/modprobe.d/alsa-legacy.conf > /dev/null

## Disable sudo from asking password for you user

  ```bash
  sudo EDITOR=/usr/bin/nano visudo
  ```
  ### Add following content

  ```text
  outside ALL=(ALL) NOPASSWD: ALL
  ```

  ![visudo passwordless](./visudo.png?raw=true "Title")
  
  ## Please reboot after the vi sudo command above

## Reusing existing keys

  >Copy expisting id_rsa and public ket to ~/.ssh

# One line setup

 After completing the task above, you can use the scripts to setup your ubuntu. It is recommended to only use these scripts for fresh install.
 This will install and configure followings for you:

 - [x] mysql-client
 - [x] oh-my-zsh and set zsh as default shell, along with some nice plugins and themes
 - [x] docker with docker compose v2 
 - [x] ruby version 3 with rbenv. Nokogiri and HTTParty gems are preinstalled (They are used to install nvm and docker)
 - [x] nvm with latest node installed
 - [x] Add all of the pre required softwares (defined in basic software installaion) and fonts to work with powerlevel10k theme.
 - [x] zsh history completion
 - [x] create docker network by default named pagevamp
 - [x] create port proxy to redirect all request from

      1. 127.0.0.2:80 -> 127.0.0.1:81
      2. 127.0.0.2:443 -> 127.0.0.2:444

      > Reason for this is to be able to use nginx from host machine with port 80 and from docker in port 81/444

  - [x] Add www-data to your user group so that nginx can access your home folder

 1. ### Setup git (No longer required)

    ```bash
    sudo apt install git-core
    ```
 2. ### Clone repo

    ```bash
    git clone git@github.com:priosshrsth/ubuntu-setup-helper.git
    cd ubuntu-setup-helper
    ```
 3. ### Run script

    ```bash
    ./setup.sh
    ```

## Basic Software Installations

1. ### Install all required packages

     (Note:- Do not install phpstorm, RubyMine and Node from snap package. Use official website to download and install them)

     ```bash
     sudo apt update
     ```

      ```bash
      sudo apt install --no-install-recommends google-perftools
      sudo apt install zsh vlc gimp gpart curl libfuse2 nginx \
      gstreamer1.0-libav zlib1g-dev build-essential libssl-dev libreadline-dev \
      libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev \
      libcurl4-openssl-dev software-properties-common libffi-dev \
      fonts-powerline mysql-client libmysqlclient-dev \
      fonts-font-awesome exa python3-venv python3-pip
      ```

2. ### Setup Shortcuts

   **Setup These Shortcuts to make your life easier**

    * **Win + E** => Open File Manager
  ```nautilus --new-window```
  
    * **Win + D** => Toggle Desktop

## Install and Use *Oh My ZSH*

2. ### Make ZSH your default Shell

    * For current user

    ```bash
      chsh -s $(which zsh)
    ```

    * For root user

    ```bash
      sudo chsh -s $(which zsh)
    ```

3. ### Install Oh My Zsh

   ```bash
   sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
   git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
   ```

4. ### Switch to powerlevel10k theme

  ```bash
  ZSH_THEME="powerlevel10k/powerlevel10k"
  ```

> [Donot forget to install MesloLGS fonts](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k)

5. Configure powerlevel theme
   
   ```bash
   p10k configure
   ```
## Setup and configure git and github

1. ### Generate SSH keys

    ```bash
    git config --global color.ui true
    git config --global user.name "name"
    git config --global user.email "email"
    ssh-keygen -t ed25519 -C "email"
    ```

    The next step is to take the newly generated SSH key and add it to your Github account. You want to copy and paste the output of the following command and [paste it here](https://github.com/settings/ssh).

    ```bash
    cat ~/.ssh/id_rsa.pub
    ```

    Once you've done this, you can check and see if it worked:

    ```bash
    ssh -T git@github.com
    ```

    You should get a message like this:

    ```bash
    Hi priosshrsth! You've successfully authenticated, but GitHub does not provide shell access.
    ```


2. ### Set These port proxy

    ```bash
      sudo iptables -t nat -A OUTPUT -o lo -d 127.0.0.2 -p tcp --dport 80 -j DNAT  --to-destination 127.0.0.1:81
      sudo iptables -t nat -A OUTPUT -o lo -d 127.0.0.2 -p tcp --dport 443 -j DNAT  --to-destination 127.0.0.1:444
    ```

3. ### To make these changes permanent, put the commands in the ~/.profile

   ```bash
   gedit ~/.profile
   ```

   Then, Put these lines at the end:

    ```bash
    sudo iptables -t nat -A OUTPUT -o lo -d 127.0.0.2 -p tcp --dport 80 -j DNAT  --to-destination 127.0.0.1:81
    sudo iptables -t nat -A OUTPUT -o lo -d 127.0.0.2 -p tcp --dport 443 -j DNAT  --to-destination 127.0.0.1:444
    ```

    **Since, iptables requires sudo, we need to add it to sudoers to stop password prompt**

    ```bash
    sudo EDITOR=/usr/bin/nano visudo
    ```

   And then, add this line at the end

   > *[username]* ALL=NOPASSWD: /usr/sbin/iptables

   > **Please remember to leave empty line at the end of crontab file**

## Reusing old ssh keys

Run these commands

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
ssh-add
```

## Setup asdf

https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/asdf

  ```bash
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0
  ```
  
## Install Docker

Goto: <https://docs.docker.com/engine/install/ubuntu/>


5. ### Allow docker to be run withou sudo

    ```bash
    sudo usermod -aG docker $USER
    newgrp docker
    ```

7. ### Create docker network

    ```bash
    docker network create --gateway 172.18.0.1 --subnet 172.18.0.0/24 pagevamp
    ```

### When getting handshake error in docker
  edit `~/.docker/config.json` file. Add following code assuming 192..168.1.69 is your local ip
  `
    "proxies": {
    "default": {
      "noProxy": "192.168.1.69,127.0.0.0/8"
    }
  }
  `

## Setup Nginx

   > We have already installed nginx with our first apt install command.

1. ### Allow www-data to access local user directory

    ```bash
    sudo gpasswd -a www-data $USER
    sudo nginx -s reload
    ```

    > If above commmand fails, then run ```sudo systemctl restart nginx```
    >
2. ### Add webp support

     1. Add to the /etc/nginx/mime.types **“image/webp webp”**
     2. Add to the main nginx.conf

        ```text
        map $http_accept $webp_suffix {
          default “”;
          “~*webp” “.webp”;
        }
        ```

        And in the server block

        ```text
        location ~* ^/wp-content/.+\.(png|jpg)$ {
          add_header Vary Accept;
          try_files $uri$webp_suffix $uri =404;
        }
        ```

## SetUp MySQL-Client ( we will use mysql server from docker)

Edit **`/etc/mysql/my.cnf`** and include these lines

```text
[client]
host=172.18.0.15
user=root
password=root
```

> If you fail to get the path `for my.cnf`, then use following command:

```bash
 mysql --help | grep "Default options" -A 1
 ```

## Setup Postgres (Optional)

1. ### Install postgresql-client

    ```bash
    sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

    sudo apt-get update

    # Install the latest version of PostgreSQL.
    # If you want a specific version, use 'postgresql-12' or similar instead of 'postgresql':
    sudo apt-get -y install libpq-dev postgresql-client
    ```

2. ### Set defailt host for postgre client

    ```bash
    export PGHOST="postgres"
    ```

## Install PHP

  ```bash
    sudo apt install php php-fpm php-cli php-mysql php-zip php-xml \
     php-mbstring php-curl php-intl php-mongodb php-bcmath php-gd \
     php-sqlite3
  ```
## Additional Setup

1. Install `Desktop Folder` App to set notes, images and folders in your desktop

2. Also Install LocalTunnel instead of ngrok
<https://localtunnel.github.io/www/>
