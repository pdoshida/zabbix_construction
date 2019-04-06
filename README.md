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
- TimeZone変更
```
timedatectl set-timezone Asia/Tokyo
```
- swap領域割り当て  
https://aws.amazon.com/jp/premiumsupport/knowledge-center/ec2-memory-swap-file/

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
