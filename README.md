# SequelBot

This bot escaped from the R&D lab of a film studio and now pitches movie ideas on Twitter!

Written in Ruby. Will run on Heroku. Requires a little config to work with _your_ twitter account:

```
CONSUMER_KEY=YOUR_TWITTER_CONSUMER_KEY
CONSUMER_SECRET=YOUR_TWITTER_CONSUMER_SECRET
ACCESS_TOKEN=YOUR_TWITTER_ACCESS_TOKEN
ACCESS_TOKEN_SECRET=YOUR_TWITTER_ACCESS_TOKEN_SECRET
```

Here's what it does:

Every 30 minutes, it:

- picks a random film title from IMDB, particularly the top charts (all time, in theatres, by genre)
- Attempts two split it into its two main components
- Appends '2' to each component

Coming to a theatre near you!