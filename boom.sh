apt-get update
apt-get install -y git
curl -fsSL get.docker.com | bash
rm -r btcpayserver-docker /root/.ssh/id_rsa_btcpay
git clone https://github.com/btcpayserver/btcpayserver-docker
cd btcpayserver-docker
export NBITCOIN_NETWORK="mainnet"
export BTCPAYGEN_CRYPTO1="btc"
export BTCPAYGEN_LIGHTNING="lnd"
export ACME_CA_URI="https://acme-v01.api.letsencrypt.org/directory"
ssh-keygen -t rsa -f /root/.ssh/id_rsa_btcpay -q -P ""
echo "# Key used by BTCPay Server" >> /root/.ssh/authorized_keys
cat /root/.ssh/id_rsa_btcpay.pub >> /root/.ssh/authorized_keys
export BTCPAY_HOST_SSHKEYFILE=/root/.ssh/id_rsa_btcpay
export BTCPAY_HOST=$1
export LETSENCRYPT_EMAIL=$2
export BTCPAYGEN_ADDITIONAL_FRAGMENTS="opt-save-storage-s"
. ./btcpay-setup.sh -i
./btcpay-down.sh
service docker stop
mkfs.ext4 /dev/vdc
mkdir /mnt/dockervolume
mount /dev/vdc /mnt/dockervolume
echo "/dev/vdc        /mnt/dockervolume        ext4   defaults        0 0" >> /etc/fstab
mv /var/lib/docker /mnt/dockervolume
ln -s /mnt/dockervolume /var/lib/docker
service docker start
. ./btcpay-up.sh
