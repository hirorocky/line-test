class LineEventsController < ApplicationController
  require 'line/bot'

  protect_from_forgery :except => [:callback]

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request
    end

    events = client.parse_events_from(body)

    events.each do |event|
      line_user_id = event['source']['userId']
      user = User.find_by(line_user_id: line_user_id)
      case event
      when Line::Bot::Event::Follow
        if user.nil?
          User.create!(line_user_id: line_user_id, status: 0)
          client.reply_message(event['replyToken'], want_company_code)
        elsif user.status == 0
          client.reply_message(event['replyToken'], want_company_code)
        end
      when Line::Bot::Event::Message
        case user.status
        when 0 # company_code未登録
          code = event.message['text']
          company = Company.find_by(company_code: code)
          if company.nil?
            client.reply_message(event['replyToken'], compnay_not_found)
          else
            company.users.append(user)
            user.update(status: 1)
            client.reply_message(event['replyToken'], want_user_name)
          end
        when 1 # name未登録
          user.name = event.message['text']
          if user.save
            user.update(status: 2)
            client.reply_message(event['replyToken'], user_name_saved)
          else
            client.reply_message(event['replyToken'], invalid_user_name)
          end
        end
      when Line::Bot::Event::Postback
        weather = event['postback']['data']
        client.reply_message(event['replyToken'], answer_accepted(weather))
      end
    end

    head :ok
  end

  private

  def want_company_code
    {
      'type': 'text',
      'text': '会社コードを入力してください。'
    }
  end

  def want_user_name
    {
      'type': 'text',
      'text': 'あなたのお名前を入力してください。'
    }
  end

  def compnay_not_found
    {
      'type': 'text',
      'text': '入力された会社コードは無効です。'
    }
  end

  def user_name_saved
    {
      'type': 'text',
      'text': 'お名前を登録しました。'
    }
  end

  def invalid_user_name
    {
      'type': 'text',
      'text': '入力された名前は無効です。'
    }
  end

  def answer_accepted(weather)
    {
      'type': 'text',
      'text': '回答ありがとうございます：' + weather
    }
  end
end
