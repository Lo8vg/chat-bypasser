-- KBL Bypasser v10.0
-- Works with Roblox's TextChatService (2025)
-- Based on actual working methods

-- Services
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

-- Enhanced bypass methods for TextChatService
local BypassMethods = {
    -- Method 1: Advanced Unicode Mixing
    AdvancedUnicode = function(text)
        -- Unicode mapping with zero-width characters
        local unicodeMap = {
            ["a"] = {"а", "ɑ", "α", "а", "ɑ", "α", "ａ", "𝐚", "𝑎", "𝒂", "𝖆", "𝖺", "𝗮", "𝘢", "𝙖", "𝚊", "ₐ", "ᵃ", "ₐ", "ᵃ"},
            ["b"] = {"ƅ", "ḇ", "в", "в", "ƅ", "ḇ", "ｂ", "𝐛", "𝑏", "𝒃", "𝖇", "𝖻", "𝗯", "𝘣", "𝙗", "𝚋", "₆", "ᵇ", "₆", "ᵇ"},
            ["c"] = {"с", "ç", "ϲ", "с", "ç", "ϲ", "ｃ", "𝐜", "𝑐", "𝒄", "𝖈", "𝖼", "𝗰", "𝘤", "𝙘", "𝚌", "ₑ", "ᶜ", "ₑ", "ᶜ"},
            ["d"] = {"ԁ", "ḍ", "ⅾ", "ԁ", "ḍ", "ⅾ", "ｄ", "𝐝", "𝑑", "𝒅", "𝖉", "𝖽", "𝗱", "𝘥", "𝙙", "𝚍", "ₔ", "ᵈ", "ₔ", "ᵈ"},
            ["e"] = {"е", "ẹ", "ė", "ё", "е", "ẹ", "ｅ", "𝐞", "𝑒", "𝒆", "𝖊", "𝖾", "𝗲", "𝘦", "𝙚", "𝚎", "ₑ", "ᵉ", "ₑ", "ᵉ"},
            ["f"] = {"ƒ", "ḟ", "ғ", "ƒ", "ḟ", "ғ", "ｆ", "𝐟", "𝑓", "𝒇", "𝖋", "𝖿", "𝗳", "𝘧", "𝙛", "𝚏", "ᶠ", "ᶠ", "ᶠ", "ᶠ"},
            ["g"] = {"ġ", "ğ", "ǵ", "ġ", "ğ", "ǵ", "ｇ", "𝐠", "𝑔", "𝒈", "𝖌", "𝗀", "𝗴", "𝘨", "𝙜", "𝚐", "₉", "ᵍ", "₉", "ᵍ"},
            ["h"] = {"һ", "ḥ", "ḣ", "һ", "ḥ", "ḣ", "ｈ", "𝐡", "ℎ", "𝒉", "𝖍", "𝗁", "𝗵", "𝘩", "𝙝", "𝚑", "ₕ", "ʰ", "ₕ", "ʰ"},
            ["i"] = {"і", "ị", "ï", "і", "ị", "ï", "ｉ", "𝐢", "𝑖", "𝒊", "𝖎", "𝗂", "𝗶", "𝘪", "𝙞", "𝚒", "ᵢ", "ⁱ", "ᵢ", "ⁱ"},
            ["j"] = {"ј", "ĵ", "ј", "ĵ", "ј", "ĵ", "ｊ", "𝐣", "𝑗", "𝒋", "𝖏", "𝗃", "𝗷", "𝘫", "𝙟", "𝚓", "ⱼ", "ʲ", "ⱼ", "ʲ"},
            ["k"] = {"κ", "ķ", "ḳ", "κ", "ķ", "ḳ", "ｋ", "𝐤", "𝑘", "𝒌", "𝖐", "𝗄", "𝗸", "𝘬", "𝙠", "𝚔", "ₖ", "ᵏ", "ₖ", "ᵏ"},
            ["l"] = {"ḷ", "ļ", "ł", "ḷ", "ļ", "ł", "ｌ", "𝐥", "𝑙", "𝒍", "𝖑", "𝗅", "𝗹", "𝘭", "𝙡", "𝚕", "ₗ", "ˡ", "ₗ", "ˡ"},
            ["m"] = {"ṃ", "ṁ", "ṃ", "ṁ", "ṃ", "ṁ", "ｍ", "𝐦", "𝑚", "𝒎", "𝖒", "𝗆", "𝗺", "𝘮", "𝙢", "𝚖", "ₘ", "ᵐ", "ₘ", "ᵐ"},
            ["n"] = {"ṅ", "ñ", "ń", "ṅ", "ñ", "ń", "ｎ", "𝐧", "𝑛", "𝒏", "𝖓", "𝗇", "𝗻", "𝘯", "𝙣", "𝚗", "ₙ", "ⁿ", "ₙ", "ⁿ"},
            ["o"] = {"о", "ọ", "ö", "о", "ọ", "ö", "ｏ", "𝐨", "𝑜", "𝒐", "𝖔", "𝗈", "𝗼", "𝘰", "𝙤", "𝚘", "ₒ", "ᵒ", "ₒ", "ᵒ"},
            ["p"] = {"р", "ṗ", "р", "ṗ", "р", "ṗ", "ｐ", "𝐩", "𝑝", "𝒑", "𝖕", "𝗉", "𝗽", "𝘱", "𝙥", "𝚙", "ₚ", "ᵖ", "ₚ", "ᵖ"},
            ["q"] = {"ԛ", "ɋ", "ԛ", "ɋ", "ԛ", "ɋ", "ｑ", "𝐪", "𝑞", "𝒒", "𝖖", "𝗊", "𝗾", "𝘲", "𝙦", "𝚚", "ᑫ", "ᑫ", "ᑫ", "ᑫ"},
            ["r"] = {"ṛ", "ŕ", "ṙ", "ṛ", "ŕ", "ṙ", "ｒ", "𝐫", "𝑟", "𝒓", "𝖗", "𝗋", "𝗿", "𝘳", "𝙧", "𝚛", "ᵣ", "ʳ", "ᵣ", "ʳ"},
            ["s"] = {"ѕ", "ṡ", "ś", "ѕ", "ṡ", "ś", "ｓ", "𝐬", "𝑠", "𝒔", "𝖘", "𝗌", "𝘀", "𝘴", "𝙨", "𝚜", "ₛ", "ˢ", "ₛ", "ˢ"},
            ["t"] = {"ṭ", "ţ", "ṫ", "ṭ", "ţ", "ṫ", "ｔ", "𝐭", "𝑡", "𝒕", "𝖙", "𝗍", "𝘁", "𝘵", "𝙩", "𝚝", "ₜ", "ᵗ", "ₜ", "ᵗ"},
            ["u"] = {"ụ", "ü", "ů", "ụ", "ü", "ů", "ｕ", "𝐮", "𝑢", "𝒖", "𝖚", "𝗎", "𝘂", "𝘶", "𝙪", "𝚞", "ᵤ", "ᵘ", "ᵤ", "ᵘ"},
            ["v"] = {"ṿ", "ṿ", "ṿ", "ṿ", "ṿ", "ṿ", "ｖ", "𝐯", "𝑣", "𝒗", "𝖛", "𝗏", "𝘃", "𝘷", "𝙫", "𝚟", "ᵥ", "ᵛ", "ᵥ", "ᵛ"},
            ["w"] = {"ẃ", "ẅ", "ẃ", "ẅ", "ẃ", "ẅ", "ｗ", "𝐰", "𝑤", "𝒘", "𝖜", "𝗐", "𝘄", "𝘸", "𝙬", "𝚠", "𝓌", "ʷ", "𝓌", "ʷ"},
            ["x"] = {"х", "ẋ", "х", "ẋ", "х", "ẋ", "ｘ", "𝐱", "𝑥", "𝒙", "𝖝", "𝗑", "𝘅", "𝘹", "𝙭", "𝚡", "ₓ", "ˣ", "ₓ", "ˣ"},
            ["y"] = {"у", "ý", "ÿ", "у", "ý", "ÿ", "ｙ", "𝐲", "𝑦", "𝒚", "𝖞", "𝗒", "𝘆", "𝘺", "𝙮", "𝚢", "ᵧ", "ʸ", "ᵧ", "ʸ"},
            ["z"] = {"ẓ", "ż", "ź", "ẓ", "ż", "ź", "ｚ", "𝐳", "𝑧", "𝒛", "𝖟", "𝗓", "𝘇", "𝘻", "𝙯", "𝚣", "𝓏", "ᶻ", "𝓏", "ᶻ"},
            ["A"] = {"Ａ", "𝐀", "𝐴", "𝑨", "𝖠", "𝗔", "𝘈", "𝘼", "𝙰", "ₐ", "ᴀ"},
            ["B"] = {"Ｂ", "𝐁", "𝐵", "𝑩", "𝖡", "𝗕", "𝘉", "𝘽", "𝙱", "ʙ"},
            ["C"] = {"Ｃ", "𝐂", "𝐶", "𝑪", "𝖢", "𝗖", "𝘊", "𝘾", "𝙲", "ᴄ"},
            ["D"] = {"Ｄ", "𝐃", "𝐷", "𝑫", "𝖣", "𝗗", "𝘋", "𝘿", "𝙳", "ᴅ"},
            ["E"] = {"Ｅ", "𝐄", "𝐸", "𝑬", "𝖤", "𝗘", "𝘌", "𝙀", "𝙴", "ᴇ"},
            ["F"] = {"Ｆ", "𝐅", "𝐹", "𝑭", "𝖥", "𝗙", "𝘍", "𝙁", "𝙵", "ꜰ"},
            ["G"] = {"Ｇ", "𝐆", "𝐺", "𝑮", "𝖦", "𝗚", "𝘎", "𝙂", "𝙶", "ɢ"},
            ["H"] = {"Ｈ", "𝐇", "𝐻", "𝑯", "𝖧", "𝗛", "𝘏", "𝙃", "𝙷", "ʜ"},
            ["I"] = {"Ｉ", "𝐈", "𝐼", "𝑰", "𝖨", "𝗜", "𝘐", "𝙄", "𝙸", "ɪ"},
            ["J"] = {"Ｊ", "𝐉", "𝐽", "𝑱", "𝖩", "𝗝", "𝘑", "𝙅", "𝙹", "ᴊ"},
            ["K"] = {"Ｋ", "𝐊", "𝐾", "𝑲", "𝖪", "𝗞", "𝘒", "𝙆", "𝙺", "ᴋ"},
            ["L"] = {"Ｌ", "𝐋", "𝐿", "𝑳", "𝖫", "𝗟", "𝘓", "𝙇", "𝙻", "ʟ"},
            ["M"] = {"Ｍ", "𝐌", "𝑀", "𝑴", "𝖬", "𝗠", "𝘔", "𝙈", "𝙼", "ᴍ"},
            ["N"] = {"Ｎ", "𝐍", "𝑁", "𝑵", "𝖭", "𝗡", "𝘕", "𝙉", "𝙽", "ɴ"},
            ["O"] = {"Ｏ", "𝐎", "𝑂", "𝑶", "𝖮", "𝗢", "𝘖", "𝙊", "𝙾", "ᴏ"},
            ["P"] = {"Ｐ", "𝐏", "𝑃", "𝑷", "𝖯", "𝗣", "𝘗", "𝙋", "𝙿", "ᴘ"},
            ["Q"] = {"Ｑ", "𝐐", "𝑄", "𝑸", "𝖰", "𝗤", "𝘘", "𝙌", "𝚀", "ǫ"},
            ["R"] = {"Ｒ", "𝐑", "𝑅", "𝑹", "𝖱", "𝗥", "𝘙", "𝙍", "𝚁", "ʀ"},
            ["S"] = {"Ｓ", "𝐒", "𝑆", "𝑺", "𝖲", "𝗦", "𝘚", "𝙎", "𝚂", "ꜱ"},
            ["T"] = {"Ｔ", "𝐓", "𝑇", "𝑻", "𝖳", "𝗧", "𝘛", "𝙏", "𝚃", "ᴛ"},
            ["U"] = {"Ｕ", "𝐔", "𝑈", "𝑼", "𝖴", "𝗨", "𝘜", "𝙐", "𝚄", "ᴜ"},
            ["V"] = {"Ｖ", "𝐕", "𝑉", "𝑽", "𝖵", "𝗩", "𝘝", "𝙑", "𝚅", "ᴠ"},
            ["W"] = {"Ｗ", "𝐖", "𝑊", "𝑾", "𝖶", "𝗪", "𝘞", "𝙒", "𝚆", "ᴡ"},
            ["X"] = {"Ｘ", "𝐗", "𝑋", "𝑿", "𝖷", "𝗫", "𝘟", "𝙓", "𝚇", "x"},
            ["Y"] = {"Ｙ", "𝐘", "𝑌", "𝒀", "𝖸", "𝗬", "𝘠", "𝙔", "𝚈", "ʏ"},
            ["Z"] = {"Ｚ", "𝐙", "𝑍", "𝒁", "𝖹", "𝗭", "𝘡", "𝙕", "𝚉", "ᴢ"}
        }
        
        local result = ""
        for i = 1, #text do
            local char = text:sub(i, i)
            if unicodeMap[char] then
                -- Randomly choose a Unicode variant
                local variants = unicodeMap[char]
                result = result .. variants[math.random(1, #variants)]
                
                -- Add zero-width characters occasionally
                if math.random(1, 3) == 1 then
                    local zeroWidth = {"\226\128\139", "\226\128\140", "\226\128\141", "\226\128\142", "\226\128\143", "\226\128\144"}
                    result = result .. zeroWidth[math.random(1, #zeroWidth)]
                end
            else
                result = result .. char
            end
        end
        return result
    end,
    
    -- Method 2: TextChatService Specific Bypass
    TextChatMethod = function(text)
        -- This method specifically targets TextChatService's filtering
        -- Uses mixed character sets and invisible separators
        local invisibleChars = {
            "\226\128\139", -- Zero width space
            "\226\128\140", -- Zero width non-joiner
            "\226\128\141", -- Zero width joiner
            "\226\128\142", -- Left-to-right mark
            "\226\128\143", -- Right-to-left mark
            "\239\188\145", -- Fullwidth exclamation mark
            "\239\188\146", -- Fullwidth quotation mark
            "\239\188\147", -- Fullwidth number sign
            "\226\129\165", -- Two dot leader
            "\226\129\166", -- Three dot leader
            "\226\129\167", -- Horizontal ellipsis
            "\226\128\148", -- Em dash
            "\226\128\147", -- En dash
            "\226\128\149", -- Horizontal bar
            "\226\128\150", -- Double oblique hyphen
            "\226\128\151", -- Double hyphen
            "\226\128\152", -- Single left-pointing angle quotation mark
            "\226\128\153", -- Single right-pointing angle quotation mark
            "\226\128\154", -- Single low-9 quotation mark
            "\226\128\155", -- Double left-pointing angle quotation mark
            "\226\128\156", -- Double right-pointing angle quotation mark
            "\226\128\157", -- Double low-9 quotation mark
            "\226\128\158", -- Dagger
            "\226\128\159"  -- Double dagger
        }
        
        -- Create chunks separated by invisible characters
        local result = ""
        local chunkSize = 2
        
        for i = 1, #text, chunkSize do
            local chunk = text:sub(i, math.min(i + chunkSize - 1, #text))
            result = result .. chunk
            
            if i + chunkSize <= #text then
                -- Add random invisible character
                result = result .. invisibleChars[math.random(1, #invisibleChars)]
            end
        end
        
        -- Wrap in delimiters that TextChatService might not filter
        local delimiters = {
            "「", "」", "『", "』", "【", "】", "〖", "〗", "⟨", "⟩", "《", "》"
        }
        
        local startDelim = delimiters[math.random(1, #delimiters)]
        local endDelim = delimiters[math.random(1, #delimiters)]
        
        return startDelim .. result .. endDelim
    end,
    
    -- Method 3: Pattern Breaker
    PatternBreaker = function(text)
        -- Breaks common pattern detection by alternating character sets
        local sets = {
            normal = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"},
            bold = {"𝐚", "𝐛", "𝐜", "𝐝", "𝐞", "𝐟", "𝐠", "𝐡", "𝐢", "𝐣", "𝐤", "𝐥", "𝐦", "𝐧", "𝐨", "𝐩", "𝐪", "𝐫", "𝐬", "𝐭", "𝐮", "𝐯", "𝐰", "𝐱", "𝐲", "𝐳"},
            italic = {"𝑎", "𝑏", "𝑐", "𝑑", "𝑒", "𝑓", "𝑔", "ℎ", "𝑖", "𝑗", "𝑘", "𝑙", "𝑚", "𝑛", "𝑜", "𝑝", "𝑞", "𝑟", "𝑠", "𝑡", "𝑢", "𝑣", "𝑤", "𝑥", "𝑦", "𝑧"},
            script = {"𝒶", "𝒷", "𝒸", "𝒹", "ℯ", "𝒻", "ℊ", "𝒽", "𝒾", "𝒿", "𝓀", "𝓁", "𝓂", "𝓃", "ℴ", "𝓅", "𝓆", "𝓇", "𝓈", "𝓉", "𝓊", "𝓋", "𝓌", "𝓍", "𝓎", "𝓏"},
            fraktur = {"𝔞", "𝔟", "𝔠", "𝔡", "𝔢", "𝔣", "𝔤", "𝔥", "𝔦", "𝔧", "𝔨", "𝔩", "𝔪", "𝔫", "𝔬", "𝔭", "𝔮", "𝔯", "𝔰", "𝔱", "𝔲", "𝔳", "𝔴", "𝔵", "𝔶", "𝔷"},
            monospace = {"𝚊", "𝚋", "𝚌", "𝚍", "𝚎", "𝚏", "𝚐", "𝚑", "𝚒", "𝚓", "𝚔", "𝚕", "𝚖", "𝚗", "𝚘", "𝚙", "𝚚", "𝚛", "𝚜", "𝚝", "𝚞", "𝚟", "𝚠", "𝚡", "𝚢", "𝚣"},
            sansserif = {"𝖺", "𝖻", "𝖼", "𝖽", "𝖾", "𝖿", "𝗀", "𝗁", "𝗂", "𝗃", "𝗄", "𝗅", "𝗆", "𝗇", "𝗈", "𝗉", "𝗊", "𝗋", "𝗌", "𝗍", "𝗎", "𝗏", "𝗐", "𝗑", "𝗒", "𝗓"},
            doublestruck = {"𝕒", "𝕓", "𝕔", "𝕕", "𝕖", "𝕗", "𝕘", "𝕙", "𝕚", "𝕛", "𝕜", "𝕝", "𝕞", "𝕟", "𝕠", "𝕡", "𝕢", "𝕣", "𝕤", "𝕥", "𝕦", "𝕧", "𝕨", "𝕩", "𝕪", "𝕫"}
        }
        
        local setNames = {"normal", "bold", "italic", "script", "fraktur", "monospace", "sansserif", "doublestruck"}
        
        local result = ""
        local currentSet = "normal"
        
        for i = 1, #text do
            local char = text:sub(i, i):lower()
            if char >= "a" and char <= "z" then
                local index = string.byte(char) - string.byte("a") + 1
                
                -- Switch character set every 2-3 characters
                if math.random(1, 3) == 1 then
                    currentSet = setNames[math.random(1, #setNames)]
                end
                
                if sets[currentSet] and sets[currentSet][index] then
                    result = result .. sets[currentSet][index]
                else
                    result = result .. char
                end
            else
                result = result .. char
            end
            
            -- Add random invisible character occasionally
            if math.random(1, 5) == 1 then
                result = result .. "\226\128\139"
            end
        end
        
        return result
    end,
    
    -- Method 4: Spam Filter Evasion
    SpamEvasion = function(text)
        -- TextChatService has spam filters, this evades them
        -- by adding random padding and varying character spacing
        local result = ""
        
        for i = 1, #text do
            local char = text:sub(i, i)
            result = result .. char
            
            -- Add varying amounts of spaces/zero-width chars
            local spacing = math.random(0, 2)
            for _ = 1, spacing do
                if math.random(1, 2) == 1 then
                    result = result .. " "
                else
                    result = result .. "\226\128\139"
                end
            end
        end
        
        -- Add random prefix and suffix
        local prefixes = {"⁣", "⁤", "⁣⁤", "⁤⁣", ""}
        local suffixes = {"⁣", "⁤", "⁣⁤", "⁤⁣", ""}
        
        return prefixes[math.random(1, #prefixes)] .. result .. suffixes[math.random(1, #suffixes)]
    end,
    
    -- Method 5: Mixed Script Bypass
    MixedScript = function(text)
        -- Mix different scripts to confuse the filter
        local scripts = {
            latin = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"},
            cyrillic = {"а", "б", "ц", "д", "е", "ф", "г", "һ", "і", "ј", "к", "л", "м", "п", "о", "р", "ԛ", "г", "ѕ", "т", "υ", "ѵ", "ш", "х", "у", "z"},
            greek = {"α", "β", "ψ", "δ", "ε", "φ", "γ", "η", "ι", "ξ", "κ", "λ", "μ", "ν", "ο", "π", "θ", "ρ", "σ", "τ", "υ", "v", "ω", "χ", "υ", "ζ"},
            math = {"𝛼", "𝛽", "𝛾", "𝛿", "𝜀", "𝜑", "𝑔", "ℎ", "𝑖", "𝑗", "𝑘", "𝑙", "𝑚", "𝑛", "𝑜", "𝑝", "𝑞", "𝑟", "𝑠", "𝑡", "𝑢", "𝑣", "𝑤", "𝑥", "𝑦", "𝑧"}
        }
        
        local result = ""
        
        for i = 1, #text do
            local char = text:sub(i, i):lower()
            if char >= "a" and char <= "z" then
                local index = string.byte(char) - string.byte("a") + 1
                
                -- Randomly choose a script
                local scriptChoice = math.random(1, 4)
                local selectedScript
                
                if scriptChoice == 1 then
                    selectedScript = scripts.latin
                elseif scriptChoice == 2 then
                    selectedScript = scripts.cyrillic
                elseif scriptChoice == 3 then
                    selectedScript = scripts.greek
                else
                    selectedScript = scripts.math
                end
                
                if selectedScript and selectedScript[index] then
                    result = result .. selectedScript[index]
                else
                    result = result .. char
                end
            else
                result = result .. char
            end
        end
        
        return result
    end
}

-- Settings
local Settings = {
    Enabled = true,
    AutoBypass = true,
    SelectedMethod = "AdvancedUnicode",
    WordByWord = true,
    WordDelay = 0.3,
    UseRandomMethod = false,
    DebugMode = false
}

-- Get TextChatService channel
local function GetTextChannel()
    local channels = TextChatService:FindFirstChild("TextChannels")
    if channels then
        for _, channel in pairs(channels:GetChildren()) do
            if channel.Name == "RBXGeneral" then
                return channel
            end
        end
    end
    return nil
end

-- Send message through TextChatService
local function SendTextChatMessage(message)
    local channel = GetTextChannel()
    if channel then
        local success, err = pcall(function()
            channel:SendAsync(message)
        end)
        
        if not success and Settings.DebugMode then
            warn("TextChatService error:", err)
        end
        
        return success
    end
    return false
end

-- Send message through legacy chat (fallback)
local function SendLegacyMessage(message)
    local chatEvents = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvents then
        local sayMessage = chatEvents:FindFirstChild("SayMessageRequest")
        if sayMessage then
            sayMessage:FireServer(message, "All")
            return true
        end
    end
    return false
end

-- Send message with delay between words
local function SendWordByWord(message)
    if not Settings.WordByWord then
        -- Send whole message
        SendTextChatMessage(message)
        return
    end
    
    local words = {}
    local currentWord = ""
    
    -- Split into words while preserving spaces
    for i = 1, #message do
        local char = message:sub(i, i)
        if char == " " then
            if currentWord ~= "" then
                table.insert(words, currentWord)
                currentWord = ""
            end
            table.insert(words, " ")
        else
            currentWord = currentWord .. char
        end
    end
    if currentWord ~= "" then
        table.insert(words, currentWord)
    end
    
    -- Send each word with delay
    for _, word in ipairs(words) do
        if word ~= " " then
            local bypassedWord = ""
            
            if Settings.UseRandomMethod then
                -- Pick random method
                local methodNames = {}
                for name, _ in pairs(BypassMethods) do
                    table.insert(methodNames, name)
                end
                local randomMethod = methodNames[math.random(1, #methodNames)]
                bypassedWord = BypassMethods[randomMethod](word)
            else
                bypassedWord = BypassMethods[Settings.SelectedMethod](word)
            end
            
            SendTextChatMessage(bypassedWord)
            wait(Settings.WordDelay)
        elseif word == " " then
            SendTextChatMessage(" ")
            wait(Settings.WordDelay / 2)
        end
    end
end

-- Hook TextChatService
local function HookTextChat()
    local channel = GetTextChannel()
    if channel then
        local originalSendAsync = channel.SendAsync
        
        channel.SendAsync = function(self, message, ...)
            if Settings.Enabled and Settings.AutoBypass and message ~= "" then
                local bypassed = BypassMethods[Settings.SelectedMethod](message)
                return originalSendAsync(self, bypassed, ...)
            end
            return originalSendAsync(self, message, ...)
        end
        
        if Settings.DebugMode then
            print("TextChatService hooked successfully")
        end
    end
end

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KBLTextChatBypasser"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(50, 50, 50)
MainFrame.Size = UDim2.new(0, 400, 0, 400)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -200)

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 40)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TitleBar
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "KBL Bypasser v10.0 - TextChat"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 16
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Make draggable
local dragging = false
local dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and dragInput and input.UserInputType == dragInput.UserInputType then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Content
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Size = UDim2.new(1, 0, 1, -40)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.ScrollBarThickness = 6
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 600)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ContentFrame

-- Method Selection
local MethodLabel = Instance.new("TextLabel")
MethodLabel.Name = "MethodLabel"
MethodLabel.Parent = ContentFrame
MethodLabel.Size = UDim2.new(1, -20, 0, 30)
MethodLabel.Position = UDim2.new(0, 10, 0, 10)
MethodLabel.BackgroundTransparency = 1
MethodLabel.Text = "Select Bypass Method:"
MethodLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MethodLabel.Font = Enum.Font.SourceSansBold
MethodLabel.TextSize = 16
MethodLabel.TextXAlignment = Enum.TextXAlignment.Left

local MethodDropdown = Instance.new("TextButton")
MethodDropdown.Name = "MethodDropdown"
MethodDropdown.Parent = ContentFrame
MethodDropdown.Size = UDim2.new(1, -20, 0, 40)
MethodDropdown.Position = UDim2.new(0, 10, 0, 50)
MethodDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MethodDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
MethodDropdown.Text = "AdvancedUnicode ▼"
MethodDropdown.Font = Enum.Font.SourceSansBold
MethodDropdown.TextSize = 14

local MethodsFrame = Instance.new("Frame")
MethodsFrame.Name = "MethodsFrame"
MethodsFrame.Parent = MainFrame
MethodsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MethodsFrame.BorderSizePixel = 1
MethodsFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
MethodsFrame.Size = UDim2.new(1, -20, 0, 200)
MethodsFrame.Position = UDim2.new(0, 10, 0, 100)
MethodsFrame.Visible = false

local MethodsScrolling = Instance.new("ScrollingFrame")
MethodsScrolling.Name = "MethodsScrolling"
MethodsScrolling.Parent = MethodsFrame
MethodsScrolling.BackgroundTransparency = 1
MethodsScrolling.Size = UDim2.new(1, 0, 1, 0)
MethodsScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
MethodsScrolling.ScrollBarThickness = 6

local MethodsLayout = Instance.new("UIListLayout")
MethodsLayout.Padding = UDim.new(0, 2)
MethodsLayout.Parent = MethodsScrolling

-- Populate methods
for methodName, _ in pairs(BypassMethods) do
    local methodButton = Instance.new("TextButton")
    methodButton.Size = UDim2.new(1, -10, 0, 30)
    methodButton.Position = UDim2.new(0, 5, 0, (#MethodsScrolling:GetChildren() - 1) * 32)
    methodButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    methodButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    methodButton.Text = methodName
    methodButton.Font = Enum.Font.SourceSans
    methodButton.TextSize = 12
    methodButton.Parent = MethodsScrolling
    
    methodButton.MouseButton1Click:Connect(function()
        Settings.SelectedMethod = methodName
        MethodDropdown.Text = methodName .. " ▼"
        MethodsFrame.Visible = false
    end)
    
    MethodsScrolling.CanvasSize = UDim2.new(0, 0, 0, (#MethodsScrolling:GetChildren() - 1) * 32)
end

MethodDropdown.MouseButton1Click:Connect(function()
    MethodsFrame.Visible = not MethodsFrame.Visible
end)

-- Toggles
local ToggleAutoBypass = Instance.new("TextButton")
ToggleAutoBypass.Name = "ToggleAutoBypass"
ToggleAutoBypass.Parent = ContentFrame
ToggleAutoBypass.Size = UDim2.new(1, -20, 0, 40)
ToggleAutoBypass.Position = UDim2.new(0, 10, 0, 100)
ToggleAutoBypass.BackgroundColor3 = Settings.AutoBypass and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
ToggleAutoBypass.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleAutoBypass.Text = "Auto-Bypass: " .. (Settings.AutoBypass and "ON" or "OFF")
ToggleAutoBypass.Font = Enum.Font.SourceSansBold
ToggleAutoBypass.TextSize = 14

ToggleAutoBypass.MouseButton1Click:Connect(function()
    Settings.AutoBypass = not Settings.AutoBypass
    ToggleAutoBypass.BackgroundColor3 = Settings.AutoBypass and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    ToggleAutoBypass.Text = "Auto-Bypass: " .. (Settings.AutoBypass and "ON" or "OFF")
end)

local ToggleWordByWord = Instance.new("TextButton")
ToggleWordByWord.Name = "ToggleWordByWord"
ToggleWordByWord.Parent = ContentFrame
ToggleWordByWord.Size = UDim2.new(1, -20, 0, 40)
ToggleWordByWord.Position = UDim2.new(0, 10, 0, 150)
ToggleWordByWord.BackgroundColor3 = Settings.WordByWord and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
ToggleWordByWord.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleWordByWord.Text = "Word-by-Word: " .. (Settings.WordByWord and "ON" or "OFF")
ToggleWordByWord.Font = Enum.Font.SourceSansBold
ToggleWordByWord.TextSize = 14

ToggleWordByWord.MouseButton1Click:Connect(function()
    Settings.WordByWord = not Settings.WordByWord
    ToggleWordByWord.BackgroundColor3 = Settings.WordByWord and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    ToggleWordByWord.Text = "Word-by-Word: " .. (Settings.WordByWord and "ON" or "OFF")
end)

local ToggleRandomMethod = Instance.new("TextButton")
ToggleRandomMethod.Name = "ToggleRandomMethod"
ToggleRandomMethod.Parent = ContentFrame
ToggleRandomMethod.Size = UDim2.new(1, -20, 0, 40)
ToggleRandomMethod.Position = UDim2.new(0, 10, 0, 200)
ToggleRandomMethod.BackgroundColor3 = Settings.UseRandomMethod and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
ToggleRandomMethod.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleRandomMethod.Text = "Random Method: " .. (Settings.UseRandomMethod and "ON" or "OFF")
ToggleRandomMethod.Font = Enum.Font.SourceSansBold
ToggleRandomMethod.TextSize = 14

ToggleRandomMethod.MouseButton1Click:Connect(function()
    Settings.UseRandomMethod = not Settings.UseRandomMethod
    ToggleRandomMethod.BackgroundColor3 = Settings.UseRandomMethod and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    ToggleRandomMethod.Text = "Random Method: " .. (Settings.UseRandomMethod and "ON" or "OFF")
end)

-- Delay Input
local DelayLabel = Instance.new("TextLabel")
DelayLabel.Name = "DelayLabel"
DelayLabel.Parent = ContentFrame
DelayLabel.Size = UDim2.new(1, -20, 0, 30)
DelayLabel.Position = UDim2.new(0, 10, 0, 250)
DelayLabel.BackgroundTransparency = 1
DelayLabel.Text = "Delay between words (seconds):"
DelayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
DelayLabel.Font = Enum.Font.SourceSans
DelayLabel.TextSize = 14
DelayLabel.TextXAlignment = Enum.TextXAlignment.Left

local DelayInput = Instance.new("TextBox")
DelayInput.Name = "DelayInput"
DelayInput.Parent = ContentFrame
DelayInput.Size = UDim2.new(1, -20, 0, 35)
DelayInput.Position = UDim2.new(0, 10, 0, 285)
DelayInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
DelayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
DelayInput.Text = "0.3"
DelayInput.Font = Enum.Font.SourceSans
DelayInput.TextSize = 14

DelayInput:GetPropertyChangedSignal("Text"):Connect(function()
    local num = tonumber(DelayInput.Text)
    if num then
        Settings.WordDelay = math.max(0.1, math.min(num, 2))
    end
end)

-- Message Input
local MessageLabel = Instance.new("TextLabel")
MessageLabel.Name = "MessageLabel"
MessageLabel.Parent = ContentFrame
MessageLabel.Size = UDim2.new(1, -20, 0, 30)
MessageLabel.Position = UDim2.new(0, 10, 0, 330)
MessageLabel.BackgroundTransparency = 1
MessageLabel.Text = "Message to send:"
MessageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MessageLabel.Font = Enum.Font.SourceSans
MessageLabel.TextSize = 14
MessageLabel.TextXAlignment = Enum.TextXAlignment.Left

local MessageInput = Instance.new("TextBox")
MessageInput.Name = "MessageInput"
MessageInput.Parent = ContentFrame
MessageInput.Size = UDim2.new(1, -20, 0, 60)
MessageInput.Position = UDim2.new(0, 10, 0, 365)
MessageInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MessageInput.TextColor3 = Color3.fromRGB(255, 255, 255)
MessageInput.Text = ""
MessageInput.Font = Enum.Font.SourceSans
MessageInput.TextSize = 14
MessageInput.TextWrapped = true
MessageInput.PlaceholderText = "Type your message here..."

-- Send Button
local SendButton = Instance.new("TextButton")
SendButton.Name = "SendButton"
SendButton.Parent = ContentFrame
SendButton.Size = UDim2.new(1, -20, 0, 45)
SendButton.Position = UDim2.new(0, 10, 0, 440)
SendButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
SendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SendButton.Text = "SEND TEST MESSAGE"
SendButton.Font = Enum.Font.SourceSansBold
SendButton.TextSize = 16

SendButton.MouseButton1Click:Connect(function()
    if MessageInput.Text ~= "" then
        SendWordByWord(MessageInput.Text)
    end
end)

-- Test Buttons
local TestSection = Instance.new("TextLabel")
TestSection.Name = "TestSection"
TestSection.Parent = ContentFrame
TestSection.Size = UDim2.new(1, -20, 0, 30)
TestSection.Position = UDim2.new(0, 10, 0, 500)
TestSection.BackgroundTransparency = 1
TestSection.Text = "Test Messages:"
TestSection.TextColor3 = Color3.fromRGB(255, 255, 255)
TestSection.Font = Enum.Font.SourceSansBold
TestSection.TextSize = 16
TestSection.TextXAlignment = Enum.TextXAlignment.Left

local TestMessages = {
    "hello",
    "test",
    "this is a test",
    "how are you",
    "roblox chat filter"
}

for i, testMsg in ipairs(TestMessages) do
    local TestButton = Instance.new("TextButton")
    TestButton.Name = "TestButton_" .. i
    TestButton.Parent = ContentFrame
    TestButton.Size = UDim2.new(1, -20, 0, 35)
    TestButton.Position = UDim2.new(0, 10, 0, 535 + (i - 1) * 40)
    TestButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    TestButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TestButton.Text = testMsg
    TestButton.Font = Enum.Font.SourceSans
    TestButton.TextSize = 12
    
    TestButton.MouseButton1Click:Connect(function()
        MessageInput.Text = testMsg
        SendWordByWord(testMsg)
    end)
end

-- Hook TextChatService
task.spawn(function()
    wait(2) -- Wait for TextChatService to load
    HookTextChat()
    
    if Settings.DebugMode then
        print("KBL Bypasser v10.0 Initialized")
        print("TextChatService hooked:", GetTextChannel() ~= nil)
        print("Selected method:", Settings.SelectedMethod)
        print("Auto-bypass:", Settings.AutoBypass)
    end
end)

-- Startup message
StarterGui:SetCore("ChatMakeSystemMessage", {
    Text = "[KBL Bypasser v10.0] Loaded! Works with TextChatService.";
    Color = Color3.fromRGB(0, 255, 0);
    Font = Enum.Font.SourceSansBold;
})

print("═══════════════════════════════════════")
print("KBL Bypasser v10.0 - TextChatService")
print("Using TextChatService channel: RBXGeneral")
print("═══════════════════════════════════════")
