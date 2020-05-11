# Docker内でAnsible勉強

先にDockerをある程度学習していて、これからAnsibleを勉強しようとしている方向けです。
勉強用にゲストを(vagrant + )VMで建てるのも気が引けるので、
Dockerでゲスト環境とAnsible実行環境をまとめました

※コンテナにsshサーバを導入していますが、あくまでも勉強用に導入しています
※すぐに学習始められるようにゲスト環境用のsshキー(パスキーなし)をあえて入れます
  （変えたい場合は再生成し、イメージを再ビルドしてください）

# フォルダ構成

- config ･･･ ansibleの設定ファイル関連
- nodes ･･･ ゲスト環境のDockerfile
- playbooks ･･･ playbookの保存
- ssh ･･･ ゲスト環境にアクセスするためのsshキー


# コンテナの構成

- centos7、ubuntu20 ･･･ ゲスト環境
- myansible ･･･ ansible実行環境

myansibleコンテナでansibleコマンドを実行し、各ゲスト環境を更新する

# 起動方法

以下のコマンドでゲスト環境＋ansible環境が起動されます
```
> docker-compose up -d
```

VSCode Remote Containerにも対応しています

# ansible環境を利用する

```
> docker exec -it myansible /bin/bash
```

# 疎通確認

サンプルコード

```
> ansible-playbook -i hosts book.yml
```
実行結果

```

PLAY [all] **************************************************************************************************************************************************************************************************
TASK [Gathering Facts] **************************************************************************************************************************************************************************************ok: [ubuntu20]
ok: [centos7]

TASK [debug] ************************************************************************************************************************************************************************************************ok: [centos7] => {
    "msg": "hello from centos7 !!"
}
ok: [ubuntu20] => {
    "msg": "hello from ubuntu20 !!"
}

PLAY RECAP **************************************************************************************************************************************************************************************************centos7                    : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu20                   : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```


# playbookの実行

playbooksをmyansibleコンテナの`/myansible`にマウントしているので、
playbooksフォルダにplaybookを作成し試すことができます。

```
> ansible-playbook all /playbooks/xxxx.yml

```

# ゲスト環境が増えた場合

1. docker-compose.ymlに新たのコンテナを追加します。
2. playbooksフォルダのhostsに対象のサービス名を追加します。