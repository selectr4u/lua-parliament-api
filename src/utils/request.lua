---@alias HttpMethod "GET" | "POST" | "PUT" | "DELETE" | "PATCH"

---@class RequestOptions
---@field url string
---@field method? HttpMethod
---@field headers? table<string, string>
---@field body? any

---@class HttpResponse
---@field body any
---@field status number
---@field headers table<string, string>

local json = require("json")

local function defaultRequest(opts)
    local http = require("socket.http")
    local ltn12 = require("ltn12")
    local socket = require("socket")

    assert(opts.url ~= nil, "must have a url")

    local attempts = 0
    local max_attempts = 5

    local method = "GET"
    local url = opts.url
    local response_body = {}
    local headers = {}
    local body = nil

    local _, status_code, response_headers

    if opts.method ~= nil then
        method = opts.method
    end

    if opts.headers ~= nil then
        headers = opts.headers
    end

    if opts.body then
        body = json.encode(opts.body)
        headers["Content-Type"] = "application/json"
        headers["Content-Length"] = tostring(#opts.body)
    end

    -- request retryer
    while attempts < max_attempts do
        _, status_code, response_headers = http.request {
            url = url,
            sink = ltn12.sink.table(response_body),
            headers = headers,
            source = ltn12.source.string(body) or nil,
            method = method,
        }

        if status_code == 200 then
            break
        else
            attempts = attempts + 1
            local delay = 2 ^ attempts -- exponential backoff
            print("request failed, retrying in " .. delay .. " seconds...")
            socket.sleep(delay)

            if attempts >= max_attempts then
                print("failed to send requests")
                return nil
            end
        end
    end


    local success, resp_body = pcall(function()
        return json.decode(table.concat(response_body))
    end)

    if not success then
        print("unable to decode resp body due to :" .. resp_body)
        print("original response body: " .. response_body)
        return nil
    end

    return {
        body = resp_body,
        status = status_code,
        headers = response_headers,
    }
end

local current_request = defaultRequest

return {
    ---Sends an HTTP request with retry and optional JSON encoding
    ---@param opts RequestOptions
    ---@return HttpResponse | nil
    request = function(opts)
        return current_request(opts)
    end,

    ---Set a custom request function
    ---@param fn fun(opts: RequestOptions): HttpResponse | nil
    setRequestFunc = function(fn)
        current_request = fn
    end,

    ---Call the built-in default request function
    ---@param opts RequestOptions
    ---@return HttpResponse | nil
    defaultRequest = function(opts)
        return defaultRequest(opts)
    end
}
