## Docker command

## build

- docker-compose build

## 起動

- docker-compose up -d

## 停止

- docker-compose down

### ログイン

- docker exec -it rails_app sh # app コンテナ
- docker exec -it rails_db sh # DB コンテナ

## Reference

- https://qiita.com/Shogo1222/items/d90b3fa01a2dca14aeeb
- https://zenn.dev/shima_zu/articles/docker_on_rails6_mysql8

## 構築方法

初期のディレクトリはこんな感じ

```
app // 任意の名前で良い
├─docker-compose.yml
├─front
|   ├─Dockerfile
└─back
    ├─Dockerfile
    ├─Gemfile
    └─Gemfile.lock
```

- Dockerfile, docker-compose.yml はこのリポジトリのものを流用しても OK(新規作成時)
- Gemfile だけ初期はこの内容

```
source 'https://rubygems.org'
gem 'rails', '~>6'
```

- backend/.env を作成し、DB 設定を記載

```
MYSQL_ROOT_PASSWORD=rootpassword
MYSQL_USER=username
MYSQL_PASSWORD=userpassword
```

- ビルド
  docker-compose build

## Rails アプリ作成する際

この行の処理は以下に修正
https://qiita.com/Shogo1222/items/d90b3fa01a2dca14aeeb#rails%E3%82%A2%E3%83%97%E3%83%AA%E3%81%AE%E4%BD%9C%E6%88%90

```
# railsアプリ作成(apiモード)
# データベースはMySQLを選択。
docker-compose run [コンテナ名] rails new . -f -d mysql --api

# railsアプリ作成(apiモードじゃない)
# データベースはMySQLを選択。
docker-compose run [コンテナ名] rails new . -f -d mysql

例
docker-compose run backend rails new . -f -d mysql

# webpackerをインストール (rails6.0から必要になった)
docker-compose run [コンテナ名] bin/rails webpacker:install

例
docker-compose run backend bin/rails webpacker:install

# ビルド
docker-compose build

```

## DB の設定

./backend/config/database.yml は以下のように編集(このリポジトリは編集済み)

```
default: &default
  adapter: mysql2
  encoding: utf8mb4
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: <%= ENV.fetch('MYSQL_USER') { 'root' } %> #追加します。
  password: <%= ENV.fetch('MYSQL_PASSWORD') { 'password' } %> #追加します。
  host: db #変更します。
```

- .env で記載した user に、権限を付与します。
- ./backend/db/grant_user.sql を作成し、以下を記載

```
GRANT ALL PRIVILEGES ON *.* TO 'username'@'%';
FLUSH PRIVILEGES;
```

- 以下の処理を実施

```
# コンテナ起動します。
docker-compose up

# dbコンテナで、上記のSQLを流します。
docker-compose exec db mysql -u root -p -e"$(cat backend/db/grant_user.sql)"

# DBの作成。
docker-compose run backend rails db:create
```

- http://localhost:3000/でアクセスできる
