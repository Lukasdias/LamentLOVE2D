function songs_load()
    main_theme = love.audio.newSource("OST/Main_Theme.mp3", "static")
    menu_theme = love.audio.newSource("OST/Menu_Theme.mp3", "static")
    death_theme = love.audio.newSource("OST/Death_Theme.mp3", "static")
    win_theme = love.audio.newSource("OST/Win_theme.mp3", "static")
end

function songs_update(dt)
    if gamestate == "title" then
        menu_theme:play()
    elseif gamestate == "play" then
        love.audio.stop(win_theme)
        death_theme:stop()
        menu_theme:stop()
        main_theme:play()
    elseif gamestate == "Game Over" then
        main_theme:stop()
        death_theme:isLooping(false)
        death_theme:play()
    elseif gamestate == "Ending" then 
        main_theme:stop()
        win_theme:isLooping(false)
        win_theme:play()
    end
end


