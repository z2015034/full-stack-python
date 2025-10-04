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

以下の手順で

```bash
# 現在の作業ディレクトリを確認します。
pwd # 現在のディレクトリを確認。full-stack-pythonディレクトリにいると思うが、そうでない場合、先の手順でfull-stack-pythonディレクトリに移動すること

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
# このMVPアプリケーションは、ユーザデータの管理にSQLiteを利用しており、以下のコマンドでデータベースの作成、初期化を実施しておきます。
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

```


```
