# zabbix resource

**Action**
```
名前：
適当な物を。

デフォルトの件名： （復旧の件名も同様）
{TRIGGER.STATUS}: {TRIGGER.NAME} : {HOST.NAME1}({TRIGGER.HOSTGROUP.NAME})

デフォルトのメッセージ：　（リカバリメッセージも同様）
{TRIGGER.STATUS}: {TRIGGER.NAME} : {HOST.NAME1}({TRIGGER.HOSTGROUP.NAME})
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

