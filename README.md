# Twitter Bot Retweeting News (UK)

This repository contains the code required to create a Twitter Bot that controls [this account](https://twitter.com/kfungdev).
The account follows several other twitter news accounts. Essentially, every 8 minutes, this bot uses GitHub Actions to run the code, which looks through the 15 most recent Tweets in this account's feed. For every tweet that contains the specific keywords, it will retweet them to the account run by the bot. As this bot is currently a WIP, the filter doesn't do a great job. A good way of going about this is to use [TextAnalysis.jl](https://github.com/JuliaText/TextAnalysis.jl) to help detect whether a tweet is related to British affairs through textual data modelling. However, this would take a long time to load and in addition, there isn't a dataset for this.

To learn more about this bot, please check the code in `bot.jl`.

Thanks for reading & Have a great day!
