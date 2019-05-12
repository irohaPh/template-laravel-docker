# Dockerコンテナ、イメージ操作
## コンテナ起動（初回時はビルドも行う）
```sh
$ docker-compose up -d
```

## コンテナ停止
```sh
$ docker-compose stop

# 停止&コンテナ削除
$ docker-compose down
```

## イメージを再ビルド
```sh
$ docker-compose build --no-cache
```

# Laravel
## プロジェクトを新規作成
```sh
$ docker-compose exec php laravel new [プロジェクト名]
```

## DB接続設定
`./work/[プロジェクト名]/.env` と `./work/[プロジェクト名]/config/database.php` を修正  
修正箇所は `./work/laravel_settings.example` 配下のファイルを参考に 

## Artisanコマンドの実行
```sh:Laravelのバージョンを確認
$ docker-compose exec php php [プロジェクト名]/artisan -V
```
```sh:マイグレーション
$ docker-compose exec php php [プロジェクト名]/artisan migrate
```
```sh:マイグレーションのロールバック
$ docker-compose exec php php [プロジェクト名]/artisan migrate:rollback
```

# nginx
## 任意のLaravelプロジェクトをドキュメントルートに指定したい場合
1. `./docker/nginx/default.conf` の `server.root` を、 `./work/[Laravelプロジェクト名]/public` などに変更する
2. nginxを再起動する
```sh
$ docker-compose exec nginx nginx -s reload
```

# ブラウザからの確認
`http://localhost:8080/` へアクセス
