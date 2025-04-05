local request = require("request").request

local BASE_URL = "https://oralquestionsandmotions-api.parliament.uk/"

local function getEarlyDayMotion(motion_id)
    assert(motion_id ~= nil)

    local resp = request(
        {
            url = BASE_URL .. "EarlyDayMotion/" .. tostring(motion_id)
        }
    )

    if resp == nil then
        return nil
    end

    return resp.body
end

-- TODO: add paramaters stuff
local function getEarlyDayMotions()
    local resp = request(
        {
            url = BASE_URL .. "EarlyDayMotions/list"
        }
    )

    if resp == nil then
        return nil
    end

    return resp.body
end

-- TODO: add paramaters stuff
local function getOralQuestions()
    local resp = request(
        {
            url = BASE_URL .. "oralquestions/list"
        }
    )

    if resp == nil then
        return nil
    end

    return resp.body
end

-- TODO: add paramaters stuff
local function getOralQuestionTimes()
    local resp = request(
        {
            url = BASE_URL .. "oralquestiontimes/list"
        }
    )

    if resp == nil then
        return nil
    end

    return resp.body
end

return {

}
