module ObiterDictaSteam
    using Downloads, JSON, HTTP, Base64, Dates

    include("SteamNews.jl")
    include("OpenAIVision.jl")

    export getSteamNews
end
