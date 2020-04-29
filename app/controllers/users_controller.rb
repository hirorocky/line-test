class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def update
    user = User.find(params[:id])
    message = {
      type: 'text',
      text: 'しつもんテスト'
    }
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
    client.push_message(user.line_user_id, message)
  end
end
