FROM nginx

# インクルード用のディレクトリを削除
# rmはディレクトリ削除、-fはディレクトリ指定
RUN rm -f /etc/nginx/conf.d/*

# Nginxの設定ファイルをコンテナにコピー
COPY nginx.conf /etc/nginx/conf.d/myapp.conf

# ビルド完了後にNginxを起動
CMD /use/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf