if FORMAT:match 'latex' then
    function Span(el)
        for key, value in pairs(el.attributes) do
            local r, g, b = value:match(".*background *: *#(..)(..)(..).*")
            if key == "style" and r and g and b then
                table.insert(
                    el.content,
                    1,
                    pandoc.RawInline(
                        "latex",
                        string.format("\\colorbox[rgb]{%f, %f, %f}{", tonumber(r, 16) / 255, tonumber(g, 16) / 255, tonumber(b, 16) / 255)
                    )
                )
                table.insert(el.content, pandoc.RawInline("latex", "}"))
                return el
            end
        end

        return el
    end

    function RawInline(el)
        if el.format == "html" then
            if el.text == "<u>" then
                return pandoc.RawInline("latex", "\\underline{")
            elseif el.text == "</u>" then
                return pandoc.RawInline("latex", "}")
            end
            
            local r, g, b = el.text:match("<font .*color *=.*#(..)(..)(..).*>")
            if r and g and b then
                return pandoc.RawInline(
                    "latex",
                    string.format("\\textcolor[rgb]{%f, %f, %f}{", tonumber(r, 16) / 255, tonumber(g, 16) / 255, tonumber(b, 16) / 255)
                )
            elseif el.text == "</font>" then
                return pandoc.RawInline("latex", "}")
            end
        end
    end

    return {
        { Span = Span },
        { RawInline = RawInline }
    }
end