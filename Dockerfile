FROM ruby:2.5.1

# RUN apt-get update && apt-get install -y nodejs --no-install-recommends \
#     && rm -rf /var/lib/apt/lists/*
# nodejsのインストール
# --no-install-recommends → デフォルトだとrecommendsしているだけの必須ではない
# パッケージも一緒に入って時間がかかるのでこれをつける
# rm → ファイル、ディレクトリの削除
# -r(recursive) → 対象にディレクトリを指定
# -f(force) → 存在しないファイルを削除しようとした時などに出る警告メッセージを表示しない
# rm -rf /var/lib/apt/lists/* → これらを削除してイメージのサイズを減らす
# https://26gram.com/category/linux

# RUN apt-get update && apt-get install -y mysql-client --no-install-recommends \
#     && rm -rf /var/lib/apt/lists/*
# mysqlのインストール

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
# -qq → エラー以外何も吐かない
# build-essential → コンパイラなどのビルドに必要
# libpq-dev → postgresqlの接続に必要


RUN mkdir /myapp
# コンテナ内にmyappというディレクトリを作成

ENV RAILS_ROOT /myapp
# 環境変数<key> 値<value>のセット。環境変数に対して1つの値を設定する
# 以降で$RAILS_ROOTと書けばそれは/myappのこと

WORKDIR $RAILS_ROOT
# myappを作業ディレクトリに指定(myappディレクトリに移動)
COPY Gemfile $RAILS_ROOT/Gemfile
COPY Gemfile.lock $RAILS_ROOT/Gemfile.lock
# ホストのGemfileをRailsコンテナにコピー
RUN gem install bundler
RUN bundle install --jobs 20 --retry 5 --without production
# コピーされたGemfileを参照してbundle install

COPY . .
# ホストのアプリケーションディレクトリ内を全てコンテナにコピー