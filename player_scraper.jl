using HTTP, Gumbo, Cascadia, Dictionaries

#name_to_scrapy = "Daniil Medvedev";

function scrapy(name)
 	# substitute space with %20
	name = replace(name, " " => "%20")
	url = "https://www.tennisexplorer.com/list-players/?search-text-pl=$name";
	html_page = HTTP.get(url);

	r_parsed = parsehtml(String(html_page.body))
	player_tag = eachmatch(sel"a", eachmatch(sel".t-name", r_parsed.root)[1])[1].attributes["href"];
	

	url = "https://www.tennisexplorer.com$player_tag";
	html_page = HTTP.get(url);
	r_parsed = parsehtml(String(html_page.body))
	result = eachmatch(sel".date", r_parsed.root);

	player_data = dictionary(["Country" => "", "Height" => "", "Age" => "", "Sex" => "", "Plays" => "", "YearOfBirth" => ""])

	for el in result
		dat = split(nodeText(el), ":")
		if !occursin("Current", dat[1]) & !occursin("Today", dat[1])
			if dat[1] == "Age"
				tmp = split(replace(dat[2], r"\(|\.|\)" => ""), " ")
				player_data["Age"] = tmp[2]
				player_data["YearOfBirth"] = tmp[3] * "/" * tmp[4] * "/" * tmp[5]
			elseif (dat[1] == "Height / Weight") || (dat[1] == "Height")
				player_data["Height"] = split(replace(dat[2], r"cm|kg|/" => ""), " ")[2]
			else 
				player_data[dat[1]] = dat[2]
			end
		end
	end
	return player_data
end