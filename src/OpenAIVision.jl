function getOpenAIKey()
    keyPath = joinpath(pkgdir(@__MODULE__), "OpenAIKey.txt")
    read(keyPath, String)
end

# Function to encode the image
function encode_image(image_path)
    return base64encode(open(read, image_path))
end

# Getting the base64 string
function getImageToText(imagePath)
    base64_image = encode_image(imagePath)
    
    headers = ["Content-Type" => "application/json",
               "Authorization" => "Bearer $(getOpenAIKey())"]

    payload = Dict(
        "model" => "gpt-4-vision-preview",
        "messages" => [
            Dict(
                "role" => "user",
                "content" => [
                    Dict("type" => "text", "text" => "Extract the text in the image. Keep the answer accurate and succinct. Do not add any additional text."),
                    Dict("type" => "image_url", "image_url" => Dict("url" => "data:image/jpeg;base64,$base64_image"))])],
        "max_tokens" => 1_000
    )

    response = HTTP.post("https://api.openai.com/v1/chat/completions", headers=headers, body=JSON.json(payload))
    return JSON.parse(String(response.body))["choices"][1]["message"]["content"]
end
