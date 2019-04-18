# 成果物
- zabbix
  - server4.0
  - action (slack)
  - agent4.0

## requeired
- amzn2
- t3.small 以上相当のインスタンスタイプ
- ec2のタグ付与権限を持ったIAM User

## Zabbixサーバーインストール
1. AmazonLinux2作成
2. rootでシェル実行  
`bash -x install_zabbix4_server_amzn2.sh`
3. ブラウザからzabbix初期設定を行う  
`http://${インスタンスIP}/zabbix`

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
**管理 > メディアタイプ**
- slack.shの配置。 `/usr/lib/zabbix/alertscripts`
- sendmail.shの配置 `/usr/lib/zabbix/alertscripts`
- ZabbixWEBでスクリプトタイプの追加
```
1. スクリプト slack.sh
スクリプトパラメータ
{ALERT.SENDTO}
{ALERT.SUBJECT}
{ALERT.MESSAGE}
2. スクリプト sendmail.sh
スクリプトパラメータ
{ALERT.SENDTO}
{ALERT.SUBJECT}
{ALERT.MESSAGE}
```

**ユーザー**
- Adminのメディアにsendmailとslackを追加する

**Action (Notify)**
- 名前、条件など適当に。メッセージなどデフォでOK.
  - 通知だけなら名前は `NotificationAction` が好きです。
- 通知先ユーザーをAdminにする

**Action (自動登録)**
- 名前 
適当に。
- 実行条件

サンプル　（agentのメタタグと一致させる）

```
web_autoregistration
cms_autoregistration
api_autoregistration
batch_autoregistration
```

- 実行内容

```
ユーザーにメッセージを送信: Admin (Zabbix Administrator) via すべてのメディア
ホストを追加
ホストグループに追加: web
テンプレートとリンク: Template OS Linux
```

**ZabbixAPI準備**

```
curl -kL https://bootstrap.pypa.io/get-pip.py | python
pip install pyzabbix
```

## Zabbixエージェント設定
cloneしてから実行

**ホスト名変更**

```
cat renamehost >>/etc/rc.local
chmod +x /etc/rc.local
```

***エージェント導入**

```bash -x install_zabbix4_agent_amzn2.sh```
