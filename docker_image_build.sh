#!/usr/bin/env bash
set -e

echo "─────────────────────────────"
echo " Reflex Docker 環境構築スクリプト "
echo "─────────────────────────────"

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
BACKEND_DIR="${PROJECT_ROOT}/backend"
FRONTEND_DIR="${PROJECT_ROOT}/frontend"

# Pythonの環境を設定する
echo "Python 仮想環境を確認中..."
if [ ! -d ".venv" ]; then
  echo ".venv を作成します..."
  python -m venv .venv
  source .venv/bin/activate
else
  echo "Python仮想環境は作成済みです。"
  source .venv/bin/activate
fi

# 依存パッケージのインストール
if [ ! -f "requirements.txt" ]; then
  echo "エラー: requirements.txt が見つかりません。"
  echo "このスクリプトを実行する前に、Reflex プロジェクトのルートに requirements.txt を配置してください。"
  exit 1
else
  echo "依存パッケージをインストール中..."
  pip install --upgrade pip
  pip install -r requirements.txt
fi

# Reflexアプリのエクスポート
echo "🚀 Reflex export を実行..."
reflex db init || true
reflex export

# 既存の展開ディレクトリを削除
echo "🧹 古い build ディレクトリを削除..."
rm -rf "${BACKEND_DIR}" "${FRONTEND_DIR}"
mkdir -p "${BACKEND_DIR}" "${FRONTEND_DIR}"

# ZIPファイル展開
echo "ZIPファイルを展開中..."
unzip -o backend.zip -d backend
unzip -o frontend.zip -d frontend


# backend Dockerfile の配置
if [ ! -f "${BACKEND_DIR}/Dockerfile" ]; then
  cp Dockerfile_backend ${BACKEND_DIR}/Dockerfile
else
  echo "backend/Dockerfile は既に存在します。"
fi

# frontend Dockerfile の配置
if [ ! -f "${FRONTEND_DIR}/Dockerfile" ]; then
  cp Dockerfile_frontend ${FRONTEND_DIR}/Dockerfile
else
  echo "frontend/Dockerfile は既に存在します。"
fi

echo "Docker イメージをクリーンアップ"
sudo docker compose down --rmi all --volumes

echo "Docker イメージをビルド中..."
sudo docker compose build --no-cache

echo "コンテナを起動します..."
sudo docker compose up
