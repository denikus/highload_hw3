# get course of currencies from bank.gov.ua

require 'net/http'
require 'json'
require 'securerandom'

url = 'https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?json&valcode=USD'
uri = URI(url)

bank_response = Net::HTTP.get(uri)

res = JSON.parse(bank_response)


tracking_id = 'UA-212799322-1'

# random user id
cid = SecureRandom.uuid
custom_metric_value = res[0]["rate"]
event = 'event'
event_action = 'trigger'
event_category = 'hit'
event_label = 'USD'
event_value = (custom_metric_value * 1000).to_i
hostname = "highload-course.com"


params_query = "tid=#{tracking_id}&dh=#{hostname}&cid=#{cid}&cm1=#{custom_metric_value}&ev=#{event_value}&el=#{event_label}&t=#{event}&dp=exchange_rate&ea=#{event_action}&ec=#{event_category}"
ga_url = URI("https://www.google-analytics.com/collect?v=1&#{params_query}")

ga_response = Net::HTTP.post_form(ga_url, {} )

puts ga_response

# cron worker
# path = '/Users/denis/vhosts/projector/homework_3'
# command = 'cd /Users/denis/vhosts/projector/homework_3 && rvm use 3.0.1 && pry parser.rb > /Users/denis/Downloads/crontab.log'

