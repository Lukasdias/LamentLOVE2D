local buttonLove = {
    _VERSION = "buttonLove v1.0.0",
    _COMPATIBILITY = "Tested on Love 11.1.0",
    _DEVELOPER = "Vinicius C. Castro",
    _DATE = "Jun. 2018",
    _DESCRIPTION = "A simple button library for Love2D",
    _WHERE = "UFMA, São Luís - MA, Brazil",
    _LICENSE = [[
        MIT LICENSE
    
        Copyright (c) 2018 Vinicius Costa Castro
    
        Permission is hereby granted, free of charge, to any person obtaining a
        copy of this software and associated documentation files (the
        "Software"), to deal in the Software without restriction, including
        without limitation the rights to use, copy, modify, merge, publish,
        distribute, sublicense, and/or sell copies of the Software, and to
        permit persons to whom the Software is furnished to do so, subject to
        the following conditions:
    
        The above copyright notice and this permission notice shall be included
        in all copies or substantial portions of the Software.
    
        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
        OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
        MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
        IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
        CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
        TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
        SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    ]]
}

button = { canPressed = true }

--[[verifica se um par coordenado informado
está dentro de um retângulo informado.
@retorna: booleano
@param:
px: ponto x do par coordenado
px: ponto y do par coordenado
x: ponto x do retângulo informado
y: ponto y do retângulo informado
w: tamanho horizontal do retângulo informado
h: tamanho vertical do retângulo informado
]]
local function pointIsInsideRectangle(px, py, x, y, w, h) return px >= x and px <= (x + w) and py >= y and py <= (y + h) end

--[[
@retorna: table
@param:
title: texto a ser impresso no botão
width: tamanho horizontal do botão
height: tamanho vertical do botão
...: varargs (verifique a função para mais informações)
]]
function button:new(title, width, height, ...)
    vararg = {...}

    -- par coordenado do botão é igual a (vararg[1],vararg[2]) se este for informado, ou (0,0) caso contrário
    local __posX = vararg[1] or 0
    local __posY = vararg[2] or 0
    
    -- cor de fundo do botão é igual a vararg[3] se este for informado, ou {255,255,255} caso contrário
    local __backgroundcolor = vararg[3] or { 255,255,255 }
    local __backgroundcolorhover = __backgroundcolor

    -- função a ser executada quando o botão for pressionado
    -- __action é igual a vararg[4] se este for informado, se não, define a função abaixo
    local __action = vararg[4] or function()
        print("Não há evento registrado")
    end

    -- fonte tipográfica do botão é definida vararg[5] se este for informado, se não, nada é definido
    local __textfont = vararg[5] or false

    -- tabela que irá armazenar todas as informações do botão atual
    current = {}

    -- função draw do botão atual
    current.draw = function()
        -- muda o estado do coletor de lixo para "step"
        collectgarbage("step")
        -- se __textfont existir, cria uma nova fonte com a fonte informado e com tamanho 25, se não, cria uma nova fonte com parâmetros padrão
        local textfont = (__textfont and love.graphics.newFont(__textfont, 25)) or love.graphics.newFont()
        -- e agora define textfont como a fonte atual
        love.graphics.setFont(textfont)
        -- e agora define __backgroundcolor como a cor atual
        love.graphics.setColor(__backgroundcolor)

        -- atribui à duas variáveis o tamanho horizontal e vertical da palavra a ser impressa
        local textwidth = textfont:getWidth(title)
        local textheight = textfont:getHeight(title)
        
        -- cria a possibilidade de definir posX ou posY como "right", "left" ou "center"
        if (type(__posX) ~= "number" and type(__posX) == "string") then
            if (__posX == "left") then
                __posX = 25
            elseif (__posX == "center") then
                __posX = (love.graphics.getWidth() / 2) - (width / 2)
            elseif (__posX == "right") then
                __posX = love.graphics.getWidth() - (width - 25)
            else
                error("Orientation invalid. Expected \"left\", \"right\" or \"center\", received [" .. button[i].posX .. "]")
            end
        end

        if (type(__posY) ~= "number" and type(__posY) == "string") then
            if (__posY == "left") then
                __posY = 25
            elseif (__posY == "center") then
                __posY = (love.graphics.getHeight() / 2) - (height / 2)
            elseif (__posY == "bottom") then
                __posY = love.graphics.getHeight() - (height - 25)
            else
                error("Orientation invalid. Expected \"top\", \"bottom\" or \"center\", received " .. button[i].posX .. "")
            end
        end

        -- cria um retângulo na tela
        local buttonRectangle = love.graphics.rectangle("fill",__posX,__posY,width,height)

        -- se a cor atual é preta, define a cor como branca,
        -- se a cor é branca, define a cor como preta
        -- se nenhuma das duas condições é satisfeita, define a cor como branca
        local cRed, cGreen, cBlue = love.graphics.getColor()
        if (cRed == 0 and cGreen == 0 and cBlue == 0) then
            love.graphics.setColor(255, 255, 255)
        elseif (cRed == 1 and cGreen == 1 and cBlue == 1) then
            love.graphics.setColor(0, 0, 0)
        else
            love.graphics.setColor(255, 255, 255)
        end

        -- cria um ponto médio para o texto impresso ser centralizado no retângulo
        local middlePointX = (__posX + (width / 2)) - (textwidth / 2)
        local middlePointY = (__posY + (height / 2)) - (textheight / 2)

        -- desenha o texto informado no ponto médio calculado
        love.graphics.print(string.upper(title), middlePointX, middlePointY)
        love.graphics.setColor(0, 0, 0)
    end

    -- função mousemoved do botão atual
    current.mousemoved = function(x,y)
        -- se o mouse estiver sobre o botão define sua cor para {0,0,0}, caso contrário, __backgroundcolorhover
        if (button.canPressed and type(__posX) == "number" and type(__posY) == "number" and pointIsInsideRectangle(x, y, __posX, __posY, width, height)) then
           -- quando o mouse estiver sobre o botão:
            __backgroundcolor = { 0, 0, 0 }
        else
            -- quando o mouse estiver fora do botão
            __backgroundcolor = __backgroundcolorhover
        end
    end

    --função mousepressed do botão atual
    current.mousepressed = function(x,y,b)
        if (button.canPressed and b == 1 and pointIsInsideRectangle(x,y,__posX,__posY, width, height)) then
            -- executa a função fornecida pelo usuário quando pressionado o botão
            __action()
        end
    end

    return current
end

return button
