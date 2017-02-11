### What does this do?
1. Imports a custom column for each slack user
2. Adds active users to a twitter list
3. Removes deleted users from the twitter list

### How do I get this to work?
- Generate a Slack User Token [here](https://api.slack.com/docs/oauth-test-tokens) and set it as `SLACK_USER_TOKEN`
- Determine the Custom Field ID for the slack profile, set it as `SLACK_TWITTER_PROFILE_ID`
  - Can run the below to see what the ID is:
```ruby
require 'slack-ruby-client'

slack_client = Slack::Web::Client.new(token: SLACK_USER_TOKEN)
slack_client.users_profile_get(include_labels: true).profile.fields.each { |k,v| puts "#{k}: #{v.label}" }
```

- Create a Twitter App [here](https://apps.twitter.com/app/new) and set the `TWITTER_CONSUMER_KEY` and `TWITTER_CONSUMER_SECRET`
- Add the user that owns the twitter list to the app, using the values to set `TWITTER_ACCESS_TOKEN` and `TWITTER_ACCESS_SECRET`
- Figure out the Twitter List ID and set it to `TWITTER_LIST_ID`
  - Can run the below to see what the List ID is:
```ruby
require 'twitter'

twitter_client = Twitter::REST::Client.new do |config|
  config.consumer_key        = TWITTER_CONSUMER_KEY
  config.consumer_secret     = TWITTER_CONSUMER_SECRET
  config.access_token        = TWITTER_ACCESS_TOKEN
  config.access_token_secret = TWITTER_ACCESS_SECRET
end

twitter_client.lists.each { |i| puts "#{i.id}: #{i.name}" }
```
- `bundle` to install the needed gems
- `ruby app.rb`
💥
