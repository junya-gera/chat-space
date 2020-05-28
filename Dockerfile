FROM ruby:2.5.1

RUN apt-get update && apt-get install -y nodejs --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*
# nodejsのインストール
# --no-install-recommends → デフォルトだとrecommendsしているだけの必須ではない
# パッケージも一緒に入って時間がかかるのでこれをつける
# rm → ファイル、ディレクトリの削除
# -r(recursive) → 対象にディレクトリを指定
# -f(force) → 存在しないファイルを削除しようとした時などに出る警告メッセージを表示しない
# rm -rf /var/lib/apt/lists/* → これらを削除してイメージのサイズを減らす
# https://26gram.com/category/linux

RUN apt-get update && apt-get install -y mysql-client --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*
# mysqlのインストール

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
# -qq → エラー以外何も吐かない
# build-essential → コンパイラなどのビルドに必要
# libpq-dev → postgresqlの接続に必要

RUN mkdir /myapp
# コンテナ内にmyappというディレクトリを作成
WORKDIR /myapp
# myappを作業ディレクトリに指定(myappディレクトリに移動)
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

ADD . /myapp