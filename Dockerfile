#Rubyのイメージを元にコンテナを作成
FROM ruby:2.6.5

#railsに必要なnodejsとpostgresをインストール
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

#yarnパッケージ管理ツールをインストール
RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
apt-get update && apt-get install -y yarn

# Node.jsをインストール
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - && \
apt-get install nodejs

#ディレクトリの構築
RUN mkdir /myapp                       #作業ディレクトリの作成
WORKDIR /myapp                         #作業ディレクトリの設定
COPY Gemfile /myapp/Gemfile            #Gemfileをコンテナにコピー
COPY Gemfile.lock /myapp/Gemfile.lock  #Gemfile.lockをコンテナにコピー
RUN bundle install                     #Gemfileで管理されているライブラリーをインストール
COPY . /myapp                          #コンテナにローカルのファイルをコピー

# コンテナがスタートする度に実行される
COPY entrypoint.sh /usr/bin/           #binにentrypoint.shをコピー
RUN chmod +x /usr/bin/entrypoint.sh    #entrypoint.shを実行
ENTRYPOINT ["entrypoint.sh"]           #docker run時に実行
EXPOSE 3000                            #コンテナのポート番号

# railsの立ち上げコマンド
CMD ["rails", "server", "-b", "0.0.0.0"]