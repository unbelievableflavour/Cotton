function shouldUseFastLoader()
    if playdate.isSimulator == nil then
        return true
    end

    return config.useFastLoader
end
