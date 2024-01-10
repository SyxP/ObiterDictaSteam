function getSteamURL(count = 50)
    return SteamNewsURL = "https://api.steampowered.com/ISteamNews/GetNewsForApp/v0002/?appid=1973530&count=$count&format=json"
end

function getSteamNewsJSON()
    data = Downloads.download(getSteamURL())
    return JSON.parsefile(data)["appnews"]["newsitems"]
end

function extractImageURL(entry :: Dict{String, Any})
    return extractImageURL(get(entry, "contents", ""))
end

function extractImageURL(str :: String)
    SteamClanImageURL = "https://clan.cloudflare.steamstatic.com/images/"
    S = eachmatch(r"\[img\](.*)\[/img\]", str)
    Links = String[]
    
    for match in S
        url = match.captures[1]
        push!(Links, replace(url, "{STEAM_CLAN_IMAGE}" => SteamClanImageURL))
    end
    newStr = replace(str, r"\[img\].*\[/img\]" => "")

    return Links, newStr
end

function getTextfromURLImage(url)
    tmpImageLink = Downloads.download(url)
    return getImageToText(tmpImageLink)
end

function getContent(entry)
    Links, newStr = extractImageURL(entry["contents"])
    io = IOBuffer()
    println(io, newStr)
    for link in Links
        println(io, getTextfromURLImage(link))
    end

    return String(take!(io))
end

function getTitle(entry)
    Date = string(unix2datetime(get(entry, "date", 0)))
    return Date * " " * get(entry, "title", "")
end