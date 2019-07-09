function soundLoad()
    main_theme = love.audio.newSource("OST/Main_Theme.mp3", "static")
    menu_theme = love.audio.newSource("OST/Menu_Theme.mp3", "static")
    death_theme = love.audio.newSource("OST/Death_Theme.mp3", "static")
    win_theme = love.audio.newSource("OST/Win_theme.mp3", "static")
end

function soundUpdate(dt)
    if gamestate == "menu" then
        menu_theme:play()
    elseif gamestate == "play" then
        love.audio.stop(win_theme)
        death_theme:stop()
        menu_theme:stop()
        main_theme:play()
    elseif gamestate == "death" then
        main_theme:stop()
        death_theme:play()
    elseif gamestate == "end" then 
        main_theme:stop()
        win_theme:play()
    end
end


