class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def update
    user = User.find(params[:id])
    message = {
      "type": "template",
      "altText": "定期アンケート",
      "template": {
        "type": "buttons",
        "imageAspectRatio": "rectangle",
        "title": "今の体調を天気で表すと？",
        "text": "選択してください：",
        "actions": [
            {
              "type": "postback",
              "label": "☀️",
              "data": "sunny"
            },
            {
              "type": "postback",
              "label": "☁️",
              "data": "cloudy"
            },
            {
              "type": "postback",
              "label": "🌧",
              "data": "rainy"
            }
        ]
      }
    }
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
    client.push_message(user.line_user_id, message)
  end
end
