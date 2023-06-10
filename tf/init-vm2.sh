#!/bin/bash

logname="startup-script-log.txt"
username="yukip"

echo "$(date) [ START ] metadata_startup_script" >> $logname 2>&1

for i in {1..60}; do
    if id "$username" >/dev/null 2>&1; then
        break;
    fi
    echo "$(date) $i '$username' not exist" >> $logname 2>&1
    sleep 1
done

cat <<'END' | sed 's/^ \{4\}//' > /home/$username/init.sh
    #!/bin/bash
    set -x
    echo "\$nrconf{restart} = 'a';" \
    | sudo tee /etc/needrestart/conf.d/100.add-yukip.conf

    key="/usr/share/keyrings/hashicorp-archive-keyring.gpg"
    url="https://apt.releases.hashicorp.com"

    if ! test -e ${key}; then
        wget -O- ${url}/gpg \
        | sudo gpg --dearmor -o ${key}

        echo "deb [signed-by=${key}] ${url} $(lsb_release -cs) main" \
        | sudo tee /etc/apt/sources.list.d/hashicorp.list
    fi

    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y git
    sudo apt install -y terraform
    sudo apt install -y vim
END

chmod 744 /home/$username/init.sh >> $logname 2>&1
chown $username:$username /home/$username/init.sh >> $logname 2>&1

if ! test -e /home/$username/yukip.bashrc; then
    echo "source ~/yukip.bashrc" >> /home/$username/.bashrc

    cat <<'....END' | sed 's/^ \{8\}//' > /home/$username/yukip.bashrc
        # timezone
        export TZ=Asia/Tokyo

        # history
        HISTSIZE=20000
        HISTFILESIZE=20000
        alias hist='history 20000 | grep -v "hist " | grep --color=never'

        # etc
        unalias l
        unalias grep
        alias la='ls -al'
        alias ll='ls -l'

        # git
        alias gitlog='git fetch;git log --oneline --graph --all origin/master'
        alias gitcommit='git add .;git commit -m '
        alias gitpush='git push;git push --tags'
        alias gitdiff='git fetch;git diff --name-status master origin/master'

        # prompt
        PS1='\n\e[1;33m[$(date +%Y/%m/%d) \t \w]\n\$\e[0m '
....END

    chmod 664 /home/$username/yukip.bashrc >> $logname 2>&1
    chown $username:$username /home/$username/yukip.bashrc >> $logname 2>&1
fi

echo "$(date) [ FINISH ] metadata_startup_script" >> $logname 2>&1
