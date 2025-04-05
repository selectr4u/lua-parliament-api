local request = require("request").request

local BASE_URL = "https://now-api.parliament.uk/api/Message/message/"

local function getCurrentAnnunciatorMessage(annunciator_type)
    assert(annunciator_type == "CommonsMain" or annunciator_type == "LordsMain", "invalid annuciator type provided")

    local resp = request(
        {
            url = BASE_URL .. annunciator_type .. "/current"
        }
    )

    if resp == nil then
        return nil
    end

    return resp.body
end

local function getAnnunciatorMessage(annunciator_type, date_time)
    assert(annunciator_type == "CommonsMain" or annunciator_type == "LordsMain", "invalid annuciator type provided")

    local resp = request(
        {
            url = BASE_URL .. annunciator_type .. "/" .. date_time
        }
    )

    if resp == nil then
        return nil
    end

    return resp.body
end

return {
    getAnnunciatorMessage = getAnnunciatorMessage,
    getCurrentAnnunciatorMessage = getCurrentAnnunciatorMessage,
}
