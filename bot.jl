#Adding all the packages we need for this bot
import Pkg
Pkg.add(["OAuth", "HTTP", "JSON"])
using OAuth, HTTP, JSON

#Creating a function to filter out the tweets we want
function filter_tweets(tweets::Array)
    
    #List of tweets to be returned
    filtered_tweets = String[]
    
    #List of keywords we want the tweet to have
    keywords = ["brexit", "european union", "referendum", "conservative", "labour", "boris johnson", "united kingdom", "scotland", "ukip", "london", "manchester", "birmingham", "edinburgh", "british", "britain"]
    
    #Loop checking whether each tweet has contains any of the keywords, and if so, adds the tweet's id to the list of tweets to be returned
    for i in keywords
        for k = 1:length(tweets)
            if occursin(i, lowercase(tweets[k]["text"]))
                push!(filtered_tweets, tweets[k]["id_str"])
            end
        end
    end
    
    #Returns the list of the id of the tweets containing the keywords
    filtered_tweets
end

#Main function containing the body of the bot
function main()
    
    #Returns the JSON from the OAuth Request to get the most recent <number of tweets specified in the variable below> tweets
    tweets = JSON.parse(String(oauth_get("https://api.twitter.com/1.1/statuses/home_timeline.json", Dict("count" => "$no_of_tweets")).body))
    
    #Passes the tweets to be filtered and returns the tweets we want
    filtered_tweets = filter_tweets(tweets)
    
    #If there are no new tweets, we will give the user a message to let them know
    if length(filtered_tweets) == 0
        println("sorry, no new brexit news :(")
        
    #If there are new tweets, we want to retweet each and one of them
    else
        for k = 1:length(filtered_tweets)
            
            #Catches the error given when it tries to retweet the same tweet for the 2nd time
            try
                id = tweets[k]["id_str"] #gives the id of the tweet we want to retweet
                println("tweet no. $(k)'s id: ", id) #let's the user know its id
                retweet_url = "https://api.twitter.com/1.1/statuses/retweet/$id.json" #url for the retweet request
                oauth_post(retweet_url, Dict("id" => "$id")) #runs the retweet request
            
            #Skips the rest of the current loop iteration to move onto the next retweet
            catch
                continue
            end
        end
    end
end

#Variables containing the keys and tokens required to power the account the bot is running on
consumer_key = "Lr2dHopg7DTgjl3YJVB6W3CJb"
secret_consumer_key = "o4CSNEg0R2UnIg4gHVoAwEPMacmQEjZJI4xGhZBQA7vRVjx6fW"
access_token = "1210249574398361600-hQAMP5bkYWSPP5cUgn53EQsMCkst2I"
secret_access_token = "RItuQ4QjzXLTeC1SlXjLzz5Ce2HJTCCXbPSSCyvT7P69u"

#Rewriting GET and POST functions to make life easier: we don't need to call the keys and tokens every time!
oauth_get(endpoint::String, options::Dict) = oauth_request_resource(endpoint, "GET", options, consumer_key, secret_consumer_key, access_token, secret_access_token)
oauth_post(endpoint::String, options::Dict) = oauth_request_resource(endpoint, "POST", options, consumer_key, secret_consumer_key, access_token, secret_access_token)

#The number of the most recent tweets the bot looks through on its home timeline every 8 minutes
no_of_tweets = 12

#Runs the main function
main()
