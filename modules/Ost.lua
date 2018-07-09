function songs_load()
    main_theme = love.audio.newSource("OST/Main_Theme.mp3")
    menu_theme = love.audio.newSource("OST/Menu_Theme.mp3")
    death_theme = love.audio.newSource("OST/Death_Theme.mp3")
end

function songs_update(dt)
    if gamestate == "title" then
        menu_theme:play()
    elseif gamestate == "play" then
        main_theme:play()
        menu_theme:stop()
    elseif gamestate == "Game Over" then
        death_theme:play()
        main_theme:stop()
    end
end


