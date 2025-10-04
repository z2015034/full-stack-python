# Reflex MVP アプリ

このサンプルアプリケーションの実行・ビルドに関する手順の解説です。

## ソースコードの入手

現在、ローカルにこのリポジトリを持っていないとします。その場合、WebブラウザでGitHubにあるこのリポジトリを参照していると思いますので、このリポジトリをローカルにクローンします。
WSLの環境の利用を前提として、説明を実施いたします。まず、Windows TerminalでWSLの環境へアクセスをします。リポジトリをクローンしたい場所へ移動します。

```bash
# リポジトリをローカルへクローンします。
git clone git@github.com:z2015034/full-stack-python.git
cd full-stack-python

# VS Codeを起動します。
code .
```

VS Codeが起動し、リポジトリの内容が左ペインのExprolerに表示されれば、クローン成功です。


## ローカル実行手順

ローカル環境で実行する前に必要な設定を実施します。

```bash
# 現在のPythonのバージョンを確認します。
python --version

# ここで、3.10.18になっていない場合、pyenvで対象のバージョンをインストールします。
pyenv versions # pyenvでインストールされているバージョンの確認。3.10.18が入って"いない"ことが確認できると思います。
pyenv install 3.10.18
pyenv versions # 再度、確認。3.10.18が入って"いる"ことが確認できると思います。

# 再度、現在のPythonのバージョンを確認してください。
python --version

# 仮想化環境の作成
python -m venv .venv # さまざまな流儀があると思いますが、ここでは.venvとして実行します。また、このプロジェクトの.gitignoreにも.venvで登録してあります。なんらかの事情で別の名前を使用する場合は、適宜、.gitignoreも修正して利用してください。

# 仮想化環境の有効化
source .venv/bin/actibate # 成功すると、プロンプトに(.venv)が追加されていれば、成功です。

# Pythonパッケージのインストール
pip install --upgrade pip
pip install -r requirements.txt # これで、Reflexフレームワークと必要な依存関係パッケージがインストールされます。




# ---
# nodeがインストールされていなくとも、Reflex実行時にインストールされますが、事前にインストールしておくとビルドの時間が短縮されます。
# また、将来的にAIの利活用などで、nodeやnpmのお世話になる機会も多いため、nodeは入れておきましょう。

# nodeのインストール確認
node --version
nvm list

# データベースの初期化

```bash
# このMVPアプリケーションは、データベースの管理にSQLAlchemy(Alembic)を利用しており、以下のコマンドでデータベースの作成、初期化を実施しておきます。
reflex db init
reflex db makemigrations
reflex db migrate
```


# MVPプロジェクトの実行

MVPアプリケーションを実行します。
```bash
reflex run # Reflexは、.webディレクトリにPythonのコードからReact（Next.js）をベースにしたJavaScriptを生成します。
```

また、このような警告が出ると思いますが、このMVPアプリケーションは、Reflex 0.5.3にもとづいて作成されており、0.8.3にアップグレードすると動作しませんので、ご注意ください。（記法やコマンド体系などが変わっており、プロジェクトのコードの修正が必要になります。）

```bash
Warning: Your version (0.5.3) of reflex is out of date. Upgrade to 0.8.13 with 'pip install reflex --upgrade'
```

以下の出力が得られれば、起動成功です。

```bash
App running at: http://localhost:3000
```

### 動作確認

それでは、動作が出来ているか確認してみましょう。
ますは、バックエンドが動作しているか確認します。

```bash
curl http://127.0.0.1:8000/ping # "pong"とレスポンスがあれば、バックエンドが動作しています。
```

つぎに、Webブラウザで、動作確認をしてみましょう。`http://localhost:3000` へアクセスします。以下のような表示がされれば成功です。

![MVPアプリケーション](image.png)



## ビルド手順

Docker環境でフロントエンドとバックエンドを実行する手順です。
ビルドについては、docker_image_build.shにて実行手順をbashスクリプトにまとめてあります。
それほど、複雑なスクリプトではないので、読めばわかると思いますが、一通りの手順を以下にまとめます。

1. ビルド用にPythonの仮想化環境を作成します。
2. ビルドに必要なpipパッケージをインストールします。
3. reflexコマンドでフロントエンド用、バックエンド用のファイルをExportします。
4. Exportされたファイルは、Zipにて生成されるため、それらを解凍します。
5. ビルド用のDockerfileを適切なディレクトリに配置します。
6. Docker Composeでビルドを実行します。
7. Docker Composeで作成したイメージを起動します。

ビルドの実行には、以下のコマンドを実行してください。

```bash
bash docker_image_build.sh
```

## 各種ファイルの説明
ビルドに関連した各種ファイルの役割を解説します。

Docker関連

以下のファイルは、それぞれフロントエンドとバックエンドのDockerfileになります。先に説明したbashスクリプトで、`backend`ディレクトリ、`frontend`ディレクトリに配置されます。
- Dockerfile_frontend
- Dockerfile_backend

docker-composeのファイルです。上記のDokcerfileで作成したコンテナイメージを起動、複数のコンテナの制御をおこないます。
- docker-compose.yml

ローカル環境では、意識しなくてもよかったフロントエンドとバックエンドの連携（アクセスポートでのみ識別）ですが、コンテナイメージ化することで、アクセス先のコンテナを検知する必要があります。そのため、フロントエンドコンテナ内でバックエンドへのアクセスが発生した場合、そのアクセスをどこへルーティングさせるかの情報が必要です。その情報は、Webサーバの設定でリバースプロキシを設定することで実現しています。
bashスクリプトでは、コンテナイメージを作成するタイミングで、コンテナイメージ内のNGINXの設定ファイルを上書きしています。
- nginx.conf




また、フロントエンドの参照パスをローカル実行用ではなく、コンテナ用に参照先を変更するため、nginx.confを用意しておきます。（このリポジトリでは、すでに用意済み）

```conf
# frontend/nginx.conf
server {
    listen 80;
    server_name localhost;

    # Serve static frontend files
    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
        try_files $uri $uri/ /index.html;
    }

    # Proxy API calls to backend
    location /_api/ {
        proxy_pass         http://reflex-backend:8000;
        proxy_http_version 1.1;
        proxy_set_header   Upgrade $http_upgrade;
        proxy_set_header   Connection "upgrade";
        proxy_set_header   Host $host;
    }
}
```

コンテナ用に参照先を変更とは、バックエンド用のコンテナを別に作成するため、そのコンテナへアクセスする必要があるため。ローカル実行では、ポート番号違いで、おなじlocalhostを参照している。


```bash
sudo docker compose build --no-cache
sudo docker compose up


```

ブラウザで以下のURLを開くと応答を確認できます：

http://localhost:8000/ping

（バックエンドのFastAPIが返す{"ping": "pong"}）

http://localhost:3000

（Nginxで配信されるReactフロント）



## Dockerコンテナの削除

sudo docker compose down --rmi all --volumes

sudo docker compose ps -a
sudo docker network ls
sudo docker volume ls
sudo docker images




sudo docker images
sudo docker rmi <IMAGE_ID>
sudo docker image prune -a
sudo docker system prune -a