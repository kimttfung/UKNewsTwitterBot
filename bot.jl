import Pkg
Pkg.add(["OAuth", "HTTP", "JSON"])
using OAuth, HTTP, JSON

function filter_tweets(tweets::Array)
    filtered_tweets = String[]
    keywords = ["brexit", "european union", "referendum", "conservative", "labour", "boris johnson", "united kingdom", "scotland", "ukip"]
    for i in keywords
        for k = 1:length(tweets)
            if occursin(i, lowercase(tweets[k]["text"]))
                push!(filtered_tweets, tweets[k]["id_str"])
            end
        end
    end
    filtered_tweets
end

function main()
    tweets = JSON.parse(String(oauth_get("https://api.twitter.com/1.1/statuses/home_timeline.json", Dict("count" => "$no_of_tweets")).body))
    filtered_tweets = filter_tweets(tweets)
    if length(filtered_tweets) == 0
        println("sorry, no new brexit news :(")
    else
        for k = 1:length(filtered_tweets)
            try
                id = tweets[k]["id_str"]
                println("tweet no. $(k)'s id: ", id)
                retweet_url = "https://api.twitter.com/1.1/statuses/retweet/$id.json"
                oauth_post(retweet_url, Dict("id" => "$id"))
            catch
                continue
            end
        end
    end
end

consumer_key = "Lr2dHopg7DTgjl3YJVB6W3CJb"
secret_consumer_key = "o4CSNEg0R2UnIg4gHVoAwEPMacmQEjZJI4xGhZBQA7vRVjx6fW"
access_token = "1210249574398361600-hQAMP5bkYWSPP5cUgn53EQsMCkst2I"
secret_access_token = "RItuQ4QjzXLTeC1SlXjLzz5Ce2HJTCCXbPSSCyvT7P69u"
oauth_get(endpoint::String, options::Dict) = oauth_request_resource(endpoint, "GET", options, consumer_key, secret_consumer_key, access_token, secret_access_token)
oauth_post(endpoint::String, options::Dict) = oauth_request_resource(endpoint, "POST", options, consumer_key, secret_consumer_key, access_token, secret_access_token)

no_of_tweets = 12

main()
