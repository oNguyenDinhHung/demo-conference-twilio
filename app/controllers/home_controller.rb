class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token
  DOMAIN = 'https://5dd9614d.ngrok.io'.freeze

  def join_conference
    booking = Booking.where('access_code LIKE ?', "%#{params['Digits']}%").first
    response = Twilio::TwiML::VoiceResponse.new do |r|
      if booking.present?
        if booking.is_this_time?
          booking.expert.update(online_status: :busy) if expert_is_joining?(params['Digits'], booking)
          r.dial do |dial|
            dial.conference(
              "Conference #{booking.id}",
              end_conference_on_exit: true,
              statusCallback: "#{DOMAIN}/status_callback",
              statusCallbackEvent: 'end'
            )
          end
        else
          r.say(message: 'Sorry, it is not time yet', voice: 'alice')
        end
      else
        r.say(message: 'You have entered the incorrect code', voice: 'alice')
      end
    end
    render xml: response.to_s
  end

  def verify_access_code
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.gather(
        input: 'speech dtmf',
        timeout: 10,
        action: "#{DOMAIN}/join_conference",
        method: 'GET'
      ) do |g|
        g.say(message: 'Please enter your access code,\nfollowed by the pound sign', voice: 'alice')
      end
      r.say(message: "We didn't receive any input. Goodbye!", voice: 'alice')
    end
    render xml: response.to_s
  end

  def status_callback
    if params['StatusCallbackEvent'] == 'conference-end'
      booking = Booking.find_by(id: params['FriendlyName']&.split(' ')&.last&.to_i)
      booking&.expert&.update(online_status: :online)
    end
  end

  private

  def expert_is_joining?(user_access_code, booking)
    booking.access_code&.split('.')&.last == user_access_code
  end
end
