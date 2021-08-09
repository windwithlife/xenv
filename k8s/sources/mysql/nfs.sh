
yum install nfs-utils
mkdir -p /net/mysql-0 /net/mysql-1 /net/mysql-2

echo '/net/mysql-0 *(rw,no_root_squash)' >> /etc/exports
echo '/net/mysql-1 *(rw,no_root_squash)' >> /etc/exports
echo '/net/mysql-2 *(rw,no_root_squash)' >> /etc/exports

systemctl restart nfs-server

showmount -e 本机IP # 验证

ifconfig | head -2| tail -1|awk '{print $2}'
