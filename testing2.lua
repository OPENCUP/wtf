-- Based on syn.request and yea

local _T = getgenv()

-- KEYS
_T.Key = "77844f71fe537dbd3e66fbd2b17f8b72" -- Get from https://trello.com/app-key
_T.Token = "73301613b09d365e4566fa3b46b84e588f9ef84ba1ef495e9b350ca9d9f22b86" -- Get from https://trello.com/1/authorize?key=KEYHERE&name=Syn+Trello+Api&expiration=never&response_type=token&scope=read,write


local TrelloApi = {}

-- MAIN

_T.Add = ""

function UseKeyAndToken()
	if _T.Token ~= "" or _T.Token ~= "Your token here" then
		if _T.Key ~= "" or _T.Key ~= "Your key here" then
			_T.Add = "?key=".._T.Key.."&token=".._T.Token
		end	
	end	
	return "?key=".._T.Key.."&token=".._T.Token
end

-- GetBoards
function TrelloApi:GetBoards()
	UseKeyAndToken()
	local BoardRequest = syn.request({
		Url = "https://api.trello.com/1/members/me/boards?fields=name".._T.Add,
		Method = "GET"
	})
	if BoardRequest.Success then
		return game:GetService("HttpService"):JSONDecode(BoardRequest.Body)
	else
		return "An error occured. ("..BoardRequest.StatusCode..")"
	end	
end

-- GetBoardByName

function TrelloApi:GetBoardIdByName(name)
	name = name or nil
	if name == nil then
		return "Please, specify a name of board."
	end
	UseKeyAndToken()
	local BoardIdRequest = syn.request({
		Url = "https://api.trello.com/1/members/me/boards".._T.Add,
		Method = "GET"
	})
	if BoardIdRequest.Success then
		local Data = game:GetService("HttpService"):JSONDecode(BoardIdRequest.Body)
		for _,t in pairs(Data) do
			for i,v in pairs(t) do
				if i == "name" and v == name then
					return t.id
				end	
			end	
		end
	else
		return "An error occured. ("..BoardIdRequest.StatusCode..")"	
	end	
end

-- GetListByName

function TrelloApi:GetList(ListName,BoardId)
	ListName = ListName or nil
	BoardId = BoardId or nil
	if ListName == nil or BoardId == nil then
		return "An error occured while getting ListName or BoardId."
	end	
	UseKeyAndToken()
	local GetListRequest = syn.request({
		Url = "https://api.trello.com/1/boards/"..BoardId.."/lists".._T.Add,
		Method = "GET"
	})
	if GetListRequest.Success then
		local Data = game:GetService("HttpService"):JSONDecode(GetListRequest.Body)
		for _,ta in pairs(Data) do
			for p,t in pairs(ta) do
				if p == "name" and t == ListName then
					return ta.id
				end	
			end	
		end	
	else
		return "An error occured. ("..GetListRequest.StatusCode..")"
	end	
end

-- GetCardsInList

function TrelloApi:GetCardsInList(ListId)
	ListId = ListId or nil
	if ListId == nil then
		return "ListId is invalid or does not exist."
	end	
	UseKeyAndToken()
	local GetCardsRequest = syn.request({
		Url = "https://api.trello.com/1/lists/"..tostring(ListId).."/cards".._T.Add,
		Method = "GET"
	})
	if GetCardsRequest.Success then
		return game:GetService("HttpService"):JSONDecode(GetCardsRequest.Body)
	else
		return "An error occured. ("..GetCardsRequest.StatusCode..")"
	end	
end

-- GetLabels 

function TrelloApi:GetLabels(BoardId)
	BoardId = BoardId or nil
	if BoardId == nil then 
		return "Please specify BoardId." 
	end
	UseKeyAndToken()
	local GetLabelRequest = syn.request({
		Url = "https://api.trello.com/1/boards/"..BoardId.."/labels".._T.Add,
		Method = "GET"
	})
	if GetLabelRequest.Success then
		return game:GetService("HttpService"):JSONDecode(GetLabelRequest.Body)
	else
		return "An error occured. ("..GetLabelRequest.StatusCode..")"
	end	
end


-- GetLabelId

function TrelloApi:GetLabelId(LabelName,BoardId)
	LabelName = LabelName or nil
	BoardId = BoardId or nil
	if LabelName == nil or BoardId == nil then
		return "LabelName or BoardId is not valid."
	end	
	UseKeyAndToken()
	local GetLabelIdRequest = syn.request({
		Url = "https://api.trello.com/1/boards/"..BoardId.."/labels".._T.Add,
		Method = "GET"
	})
	if GetLabelIdRequest.Success then
		local Data = game:GetService("HttpService"):JSONDecode(GetLabelIdRequest.Body)
		local ID 
		for _,v in next,Data do
			if v.name == LabelName then
				ID = v.id
				break
			end	
		end	
	else
		return "An error occured. ("..GetLabelIdRequest.StatusCode..")"
	end
	return ID	
end
return TrelloApi
