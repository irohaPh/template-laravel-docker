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

## DB接続設定(MySQLを使う場合)
`/work/[プロジェクト名]/.env` を以下のように修正する
```:.env
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=laravel_db
DB_USERNAME=laravel
DB_PASSWORD=laravel
```

## Artisanコマンド等の実行
```sh:例)Laravelのバージョンを確認
$ docker-compose exec php php [プロジェクト名]/artisan -V
```

# nginx
## 任意のLaravelプロジェクトをドキュメントルートに指定したい場合
1. `./docker/nginx/default.conf` の `server.root` を、 `/work/[Laravelプロジェクト名]/public` などに変更する
2. nginxを再起動する
```sh
$ docker-compose exec nginx nginx -s reload
```
