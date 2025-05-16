## 事前準備
ローカルPCでキーを作成しておく
1. ssh-keygen -t ed25519 -C "yukip"           

GoogleCloud上でプロジェクトを２つ作成しておく
- admin (terraform 実行用)
- test (開発用 flutter など)

## 使い方
1. clone
2. cd admin
3. プロジェクト名とか修正
4. init-admin.sh 実行
5. cd tf
6. terraform plan
7. terraform apply

## なおさないとメモ
### 変数へ切り出すもの
- main.tf 3  プロジェクト名(admin)
- main.tf 11 バケット名(admin)
- main.tf 76 ssh-key
- vm-osaka.tf 8 プロジェクト名(test etc...)
- init-admin.sh プロジェクト名がある(admin)


