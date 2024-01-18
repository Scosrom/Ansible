#Requisitos
apt update
apt upgrade
apt install ssh
apt install python3


#UBUNTU
#Instalar ansible
apt install software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
apt install ansible

#DEBIAN
#Instalar ansible

# UBUNTU_CODENAME=jammy
# wget -O- "https://keyserver.ubuntu.com/pks/lookup #fingerprint=on&op=get&search=0x6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367" | sudo gpg --dearmour -o /#usr/share/keyrings/ansible-archive-keyring.gpg
# echo "deb [signed-by=/usr/share/keyrings/ansible-archive-keyring.gpg] http://ppa.launchpad.net/#ansible/ansible/ubuntu $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/ansible.list
# sudo apt update && sudo apt install ansible


# Dentro del archivo /etc/ssh/sshd_config -> PermitRootLogin yes
systemctl restart ssh

# Creamos un par de claves, publicas y privadas.
#primerdebian:172.26.19.169
#segundodebian:172.26.19.173
ssh-keygen
cd .ssh/
ssh-copy-id -i id_rsa.pub root@172.26.19.169
ssh-copy-id -i id_rsa.pub root@172.26.19.173

