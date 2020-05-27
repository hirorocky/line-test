desc "This task is called by the Heroku scheduler add-on"
task :send_weekly_question => :environment do
  user = User.first
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

task :send_monthly_question => :environment do
  puts "Updating feed..."
  puts "done."
end