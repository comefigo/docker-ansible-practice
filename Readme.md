# Docker内でAnsible勉強

先にDockerをある程度学習していて、これからAnsibleを勉強しようとしている方向けです。  
勉強用にゲストを(vagrant + )VMで建てるのも気が引けるので、  
Dockerでゲスト環境とAnsible実行環境をまとめました

※コンテナにsshサーバを導入していますが、あくまでも勉強用に導入しています  
※すぐに学習始められるようにゲスト環境用のsshキー(パスキーなし)をあえて入れます  
  （変えたい場合は再生成し、イメージを再ビルドしてください）

# コンテナの構成

- centos7、ubuntu16 ･･･ ゲスト環境
- myansible ･･･ ansible実行環境

myansibleコンテナでansibleコマンドを実行し、各ゲスト環境を更新する

# 起動方法

以下のコマンドでゲスト環境＋ansible環境が起動されます
```
> docker-compose up -d
```

# ansible環境を利用する

```
> docker exec -it xxx(myansibleコンテナID) /bin/bash
```

# 疎通確認

ubuntuとcentosにpingを送るテスト  

myansibleコンテナで以下のコマンドを実行
```
> ansible all -m ping
```

# playbookの実行

playbooksをmyansibleコンテナの/playbooksにマウントしているので  
playbooks内に定義ファイルを作成し、myansibleコンテナで実行してください

```
> ansible-playbook all /playbooks/xxxx.yml
```

# ゲスト環境が増えた場合

1. docker-compose.ymlのmyansibleサービスのlinksに増やしたゲストのサービス名を追加
2. config/ansible_hostsに手順1で追加したサービス名を追加