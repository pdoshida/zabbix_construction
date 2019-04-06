# 手順実施における成果物
- zabbix
  - server 4.0 LTS
  - action (slack)

## requeired
- amzn2
- t3.small 以上相当のインスタンスタイプ

## Zabbixサーバーインストール
1. AmazonLinux2作成
2. rootでシェル実行  
bash -x install_zabbix4_amzn2.sh
3. ブラウザからzabbix初期設定を行う  
http://${INSTANCE_GLOBAL_IP}/zabbix

**※注意事項**
- インストールにおけるdbname, dbpassなど適当なので適宜変更してください


## OS設定変更
**TimeZone変更**
```
timedatectl set-timezone Asia/Tokyo
```
**swap領域割り当て**

|  物理 RAM の量 | 推奨されるスワップ領域 |
| :---: | :---: |
|  2 GB 以下の RAM | RAM 容量の 2 倍 (32 MB 以上) |
|  2 GB 以上の RAM 容量 (最大 32 GB) | 4 GB + (RAM – 2 GB) |
|  32 GB 以上の RAM | RAM 容量の 1 倍 |

```
# 1. dd コマンドを使用してルートファイルシステムにスワップファイルを作成します。ここで「bs」はブロックサイズ、「count」はブロック数です。この例で、スワップファイルは 2 GB です。
dd if=/dev/zero of=/swapfile bs=1G count=2

# 2. スワップファイルの読み書きのアクセス許可を更新します。 
chmod 600 /swapfile

# 3. Linux スワップ領域のセットアップ: 
mkswap /swapfile

# 4. スワップ領域にスワップファイルを追加して、スワップファイルを即座に使用できるようにします。 
swapon /swapfile

#5. 手順が正常に完了したことを確認します。 
swapon -s

#6. /etc/fstab ファイルを編集して、起動時にスワップファイルを有効にします。
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
```

参考

https://aws.amazon.com/jp/premiumsupport/knowledge-center/ec2-memory-swap-file/

**ホスト名変更**

```hostnamectl set-hostname zabbix40```

## Zabbix設定リソース
**Action**
```
名前：
NotificationAction

デフォルトの件名： （復旧の件名も同様）
{TRIGGER.STATUS}: {TRIGGER.NAME} : {HOST.NAME1}({TRIGGER.HOSTGROUP.NAME})

デフォルトのメッセージ：　（リカバリメッセージも同様）
{ITEM.VALUE1}
Event ID: {EVENT.ID}
```
**アクションの実行条件**
```
And/Or A and B
A メンテナンスの状態
B トリガーの値=障害
```
**アクションの実行内容**
```
ユーザーグループにメッセージを送信
```
**スクリプトタイプ**
```
スクリプト
slack.sh

スクリプトパラメータ
{ALERT.SENDTO}
{ALERT.SUBJECT}
{ALERT.MESSAGE}
```
