class LineEventsController < ApplicationController
  require 'line/bot'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:receive]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def receive
    body = request.body.read
    events = client.parse_events_from(body)
    events.each do |event|
      user_id = event['source']['userId']  #user_id取得
      p 'UserID: ' + user_id # user_idを確認
    end
  end
end